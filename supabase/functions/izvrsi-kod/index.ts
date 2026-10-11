// supabase/functions/izvrsi-kod/index.ts
// @ts-nocheck
//
// Poslužiteljska funkcija koja posreduje prema Piston poslužitelju.
// Tajno zaglavlje kojim se Piston štiti čuva se kao tajna na poslužitelju,
// pa Piston nije izravno dostupan iz preglednika. Funkciju može pozvati
// samo prijavljeni korisnik.

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const PISTON_URL = Deno.env.get("PISTON_URL")!;       // npr. http://212.39.115.52:2001/api/v2/execute
const PISTON_TOKEN = Deno.env.get("PISTON_TOKEN")!;   // tajno zaglavlje

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const odgovor = (tijelo: unknown, status = 200) =>
  new Response(JSON.stringify(tijelo), {
    status,
    headers: { ...cors, "Content-Type": "application/json" },
  });

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });

  try {
    // --- 1. provjera prijave korisnika ---
    const zaglavlje = req.headers.get("Authorization");
    if (!zaglavlje) return odgovor({ greska: "Nedostaje autorizacija." }, 401);

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_ANON_KEY")!,
      { global: { headers: { Authorization: zaglavlje } } },
    );

    const { data: { user }, error: authGreska } = await supabase.auth.getUser();
    if (authGreska || !user) return odgovor({ greska: "Korisnik nije prijavljen." }, 401);

    // --- 2. provjera sadržaja zahtjeva ---
    const { kod } = await req.json();
    if (typeof kod !== "string" || kod.trim().length === 0 || kod.length > 10000) {
      return odgovor({ greska: "Neispravan sadržaj koda." }, 400);
    }

    // --- 3. izvršavanje na Piston poslužitelju ---
    const piston = await fetch(PISTON_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-Piston-Token": PISTON_TOKEN,     // tajno zaglavlje, nikad vidljivo klijentu
      },
      body: JSON.stringify({
        language: "python",
        version: "3.12.0",
        files: [{ content: kod }],
      }),
    });

    if (!piston.ok) {
      return odgovor({ greska: `Poslužitelj za izvršavanje nije dostupan (${piston.status}).` }, 502);
    }

    const podaci = await piston.json();
    const run = podaci?.run;
    if (!run) return odgovor({ greska: "Neočekivan odgovor poslužitelja." }, 502);

    return odgovor({
      stdout: (run.stdout ?? "").trimEnd(),
      stderr: (run.stderr ?? "").trimEnd(),
      code: run.code ?? null,
      signal: run.signal ?? null,
    });
  } catch (e) {
    return odgovor({ greska: `Neočekivana pogreška: ${e}` }, 500);
  }
});