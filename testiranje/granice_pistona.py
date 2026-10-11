# -*- coding: utf-8 -*-
"""
granice_pistona.py — provjera ponašanja Piston poslužitelja pri prekoračenju
ograničenja izvršavanja (vrijeme, memorija, veličina izlaza, broj procesa).

Pokretanje:
    pip install requests
    python granice_pistona.py

Rezultat se ispisuje u terminal i zapisuje u granice.csv
"""

import csv, time, requests

PISTON_URL = "http://212.39.115.52:2001/api/v2/execute"

TESTOVI = [
    ("G1", "Beskonačna petlja (prekoračenje vremena)",
     "while True:\n    pass"),
    ("G2", "Zauzimanje velike količine memorije",
     "x = []\nwhile True:\n    x.append('a' * 10_000_000)"),
    ("G3", "Vrlo velik ispis",
     "for i in range(2_000_000):\n    print('a' * 100)"),
    ("G4", "Velik broj procesa (fork bomba, ograničeni oblik)",
     "import os\nfor i in range(200):\n    try:\n        os.fork()\n    except Exception as e:\n        print(type(e).__name__)\n        break"),
    ("G5", "Pokušaj pristupa mreži iz izoliranog okruženja",
     "import urllib.request\ntry:\n    print(urllib.request.urlopen('http://example.com', timeout=5).status)\nexcept Exception as e:\n    print('PRISTUP ODBIJEN:', type(e).__name__)"),
    ("G6", "Pokušaj čitanja datoteke izvan radnog direktorija",
     "try:\n    print(open('/etc/passwd').read()[:80])\nexcept Exception as e:\n    print('PRISTUP ODBIJEN:', type(e).__name__)"),
    ("G7", "Uobičajeno rješenje (referentna vrijednost)",
     "for i in range(1, 4):\n    for j in range(1, 4):\n        print(i * j)"),
]

redci = []
for tid, opis, kod in TESTOVI:
    print(f"{tid} {opis} ...", end=" ", flush=True)
    t0 = time.time()
    try:
        r = requests.post(PISTON_URL, headers={"X-Piston-Token": "OVDJE_UPISI_TAJNI_NIZ"}, json={
            "language": "python", "version": "3.12.0",
            "files": [{"content": kod}],
        }, timeout=60)
        trajanje = time.time() - t0
        if r.status_code != 200:
            ishod, izlaz, poruka, signal, kod_izlaza = f"HTTP {r.status_code}", "", r.text[:200], "", ""
        else:
            run = r.json().get("run", {})
            izlaz = (run.get("stdout") or "")
            poruka = (run.get("stderr") or "")
            signal = str(run.get("signal") or "")
            kod_izlaza = str(run.get("code"))
            ishod = "izvršeno"
    except Exception as e:
        trajanje = time.time() - t0
        ishod, izlaz, poruka, signal, kod_izlaza = "iznimka", "", f"{type(e).__name__}: {e}", "", ""

    redci.append({
        "id": tid, "opis": opis, "ishod": ishod,
        "izlazni_status": kod_izlaza, "signal": signal,
        "trajanje_s": round(trajanje, 2),
        "duljina_ispisa": len(izlaz),
        "ispis_pocetak": izlaz[:120].replace("\n", " "),
        "poruka_pogreske": poruka[:300].replace("\n", " "),
    })
    print(f"{ishod} | status={kod_izlaza} signal={signal} | {trajanje:.2f} s | ispis {len(izlaz)} znakova")
    if poruka:
        print("   stderr:", poruka[:200].replace("\n", " "))

with open("granice.csv", "w", newline="", encoding="utf-8-sig") as f:
    w = csv.DictWriter(f, fieldnames=list(redci[0].keys()), delimiter=";")
    w.writeheader(); w.writerows(redci)
print("\nZapisano u granice.csv")