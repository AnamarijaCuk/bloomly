# -*- coding: utf-8 -*-
"""
provjera_rls.py — provjera sigurnosnih pravila na razini redaka (RLS)
nad tablicom progress.

Provjerava četiri slučaja:
  R1  neautentificirani pristup tablici napretka
  R2  korisnik A čita vlastiti napredak
  R3  korisnik A pokušava pročitati zapise korisnika B
  R4  korisnik A pokušava izmijeniti zapis korisnika B

Pokretanje:
    pip install requests
    python provjera_rls.py
Rezultati se ispisuju i zapisuju u rls.csv
"""

import csv, json, requests

# ---------------------------------------------------------------- postavke
SUPABASE_URL = "https://tnpedjwayexwgeuautgw.supabase.co"
ANON_KEY = "sb_publishable_5i-e-9J--xXUIEGLb3g_8g_F7v_8kf9"   # javni (publishable) ključ

# Upiši dva STVARNA računa iz aplikacije (drugi račun neka ima barem jedan
# riješen kviz, da u tablici napretka postoji zapis).
KORISNIK_A = {"email": "UPISI_EMAIL", "password": "UPISI_LOZINKU"}
KORISNIK_B = {"email": "UPISI_EMAIL", "password": "UPISI_LOZINKU"}

AUTH = f"{SUPABASE_URL}/auth/v1/token?grant_type=password"
REST = f"{SUPABASE_URL}/rest/v1/progress"


def prijava(korisnik):
    r = requests.post(AUTH, headers={"apikey": ANON_KEY, "Content-Type": "application/json"},
                      json=korisnik, timeout=15)
    if r.status_code != 200:
        raise SystemExit(f"Prijava nije uspjela za {korisnik['email']}: {r.status_code} {r.text[:200]}")
    d = r.json()
    return d["access_token"], d["user"]["id"]


def zaglavlja(token=None):
    h = {"apikey": ANON_KEY, "Content-Type": "application/json"}
    if token:
        h["Authorization"] = f"Bearer {token}"
    return h


redci = []


def zapisi(oznaka, opis, ocekivano, status, tijelo):
    kratko = tijelo[:160].replace("\n", " ")
    redci.append({"id": oznaka, "provjera": opis, "ocekivano": ocekivano,
                  "http_status": status, "odgovor": kratko})
    print(f"{oznaka}  {opis}\n    očekivano: {ocekivano}\n    dobiveno:  HTTP {status} | {kratko}\n")


tokenA, idA = prijava(KORISNIK_A)
tokenB, idB = prijava(KORISNIK_B)
print(f"Korisnik A: {idA}\nKorisnik B: {idB}\n")

# R1 — neautentificirani pristup
r = requests.get(f"{REST}?select=*", headers=zaglavlja(), timeout=15)
zapisi("R1", "Neautentificirani pokušaj čitanja tablice progress",
       "prazan rezultat ili odbijen pristup", r.status_code, r.text)

# R2 — korisnik A čita vlastiti napredak
r = requests.get(f"{REST}?select=*", headers=zaglavlja(tokenA), timeout=15)
podaci = r.json() if r.status_code == 200 else []
samo_svoji = all(z.get("user_id") == idA for z in podaci) if isinstance(podaci, list) else False
zapisi("R2", "Korisnik A čita vlastiti napredak",
       "vraćeni isključivo zapisi korisnika A", r.status_code,
       f"{len(podaci) if isinstance(podaci, list) else '?'} zapisa, svi pripadaju korisniku A: {samo_svoji}"
       + ("" if r.status_code == 200 else f" | {r.text[:120]}"))

# R3 — korisnik A pokušava pročitati zapise korisnika B
r = requests.get(f"{REST}?select=*&user_id=eq.{idB}", headers=zaglavlja(tokenA), timeout=15)
podaci = r.json() if r.status_code == 200 else []
zapisi("R3", "Korisnik A pokušava pročitati zapise korisnika B",
       "prazan rezultat", r.status_code,
       f"{len(podaci) if isinstance(podaci, list) else '?'} zapisa: {json.dumps(podaci)[:120]}")

# R4 — korisnik A pokušava izmijeniti zapis korisnika B
r = requests.patch(f"{REST}?user_id=eq.{idB}", headers={**zaglavlja(tokenA), "Prefer": "return=representation"},
                   json={"last_score": 999}, timeout=15)
promijenjeno = r.json() if r.status_code in (200, 204) and r.text.strip() else []
zapisi("R4", "Korisnik A pokušava izmijeniti zapis korisnika B",
       "nijedan zapis nije izmijenjen", r.status_code,
       f"izmijenjeno zapisa: {len(promijenjeno) if isinstance(promijenjeno, list) else '?'}")

# R5 — korisnik A mijenja VLASTITI rezultat (dopušteno pravilima, pokazuje
# razliku između vlasništva nad zapisom i vjerodostojnosti ocjene)
r = requests.patch(f"{REST}?user_id=eq.{idA}", headers={**zaglavlja(tokenA), "Prefer": "return=representation"},
                   json={"last_score": 99}, timeout=15)
promijenjeno = r.json() if r.status_code in (200, 204) and r.text.strip() else []
zapisi("R5", "Korisnik A mijenja vlastiti rezultat izravnim zahtjevom bazi",
       "izmjena je dopuštena jer je zapis njegov", r.status_code,
       f"izmijenjeno zapisa: {len(promijenjeno) if isinstance(promijenjeno, list) else '?'}")

with open("rls.csv", "w", newline="", encoding="utf-8-sig") as f:
    w = csv.DictWriter(f, fieldnames=list(redci[0].keys()), delimiter=";")
    w.writeheader(); w.writerows(redci)
print("Zapisano u rls.csv")