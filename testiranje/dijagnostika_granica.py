# -*- coding: utf-8 -*-
# =====================================================================
#  UPOZORENJE: datoteka sadrži tajni niz u izvornom obliku (redak ispod).
#  Prije objave repozitorija zamijeni ga rezerviranim mjestom:
#      PISTON_TOKEN = "OVDJE_UPISI_DUGI_TAJNI_NIZ"
# =====================================================================
"""
dijagnostika_granica.py — dodatna mjerenja uz granice_pistona.py.

Odgovara na dva pitanja koja osnovno mjerenje ostavlja otvorenima:
  D1  Pri kojoj se točno količini ispisa prekida izvršavanje i što se pritom
      zapisuje na dijagnostički izlaz (stderr)?
  D2  Zaustavlja li program koji zauzima memoriju doista memorijsko
      ograničenje, i pri kojoj količini?

Pokretanje:
    pip install requests
    python dijagnostika_granica.py

Rezultat se ispisuje u terminal i zapisuje u dijagnostika.csv
"""

import csv, time, requests

PISTON_URL = "http://212.39.115.52:2001/api/v2/execute"
PISTON_TOKEN = "OVDJE_UPISI_TAJNI_NIZ"

# D1 — ispisuje retke poznate duljine i broji ih, pa se iz zadnjeg vraćenog
#      retka vidi točno mjesto prekida. Veličina retka je 101 bajt (100 + \n).
D1 = """
import sys
RETAK = 'a' * 100
for i in range(1_000_000):
    print(RETAK)
    if i % 100 == 0:
        sys.stderr.write(f'zapisano redaka: {i}\\n')
"""

# D2 — zauzima memoriju u koracima od 16 MB i nakon svakog koraka ispisuje
#      koliko je ukupno zauzeto, pa zadnji vraćeni redak pokazuje dosegnutu
#      količinu prije prekida.
D2 = """
import sys
KORAK = 16 * 1024 * 1024
drzi = []
ukupno = 0
while True:
    drzi.append(bytearray(KORAK))
    ukupno += KORAK
    print(f'zauzeto MB: {ukupno // (1024*1024)}', flush=True)
"""

TESTOVI = [("D1", "Mjesto prekida pri velikom ispisu", D1),
           ("D2", "Dosegnuta memorija prije prekida", D2)]

redci = []
for tid, opis, kod in TESTOVI:
    print(f"\n{tid}  {opis}")
    t0 = time.time()
    try:
        r = requests.post(PISTON_URL, headers={"X-Piston-Token": PISTON_TOKEN},
                          json={"language": "python", "version": "3.12.0",
                                "files": [{"content": kod}]}, timeout=120)
    except Exception as e:
        print(f"   zahtjev nije uspio: {type(e).__name__}: {e}")
        continue
    trajanje = time.time() - t0
    if r.status_code != 200:
        print(f"   poslužitelj je vratio HTTP {r.status_code}: {r.text[:200]}")
        continue
    run = r.json().get("run", {})
    izlaz = run.get("stdout") or ""
    greske = run.get("stderr") or ""
    zadnji = izlaz.rstrip().split("\n")[-1] if izlaz.strip() else "(nema ispisa)"
    print(f"   izlazni status : {run.get('code')}")
    print(f"   signal         : {run.get('signal') or '(nema)'}")
    print(f"   trajanje       : {trajanje:.2f} s")
    print(f"   duljina ispisa : {len(izlaz)} znakova")
    print(f"   zadnji redak   : {zadnji[:70]}")
    print(f"   stderr (kraj)  : {greske.rstrip()[-200:] or '(prazno)'}")
    redci.append({"id": tid, "opis": opis, "izlazni_status": run.get("code"),
                  "signal": run.get("signal") or "", "trajanje_s": round(trajanje, 2),
                  "duljina_ispisa": len(izlaz), "zadnji_redak": zadnji[:120],
                  "stderr_kraj": greske.rstrip()[-300:].replace("\n", " ")})

if redci:
    with open("dijagnostika.csv", "w", newline="", encoding="utf-8-sig") as f:
        w = csv.DictWriter(f, fieldnames=list(redci[0].keys()), delimiter=";")
        w.writeheader(); w.writerows(redci)
    print("\nZapisano u dijagnostika.csv")

print("""
Preostaje još jedno očitanje, koje se radi NA POSLUŽITELJU, odmah nakon D2:

    ssh acuk@212.39.115.52
    docker exec piston-api-1 sh -c 'cat /sys/fs/cgroup/memory.events 2>/dev/null || \\
        cat /sys/fs/cgroup/memory/memory.failcnt 2>/dev/null'
    dmesg 2>/dev/null | tail -20 | grep -i -E 'oom|killed' || echo '(nema zapisa o OOM)'

Ako oom_kill ili failcnt poraste nakon D2, memorijsko ograničenje je potvrđeno.
""")