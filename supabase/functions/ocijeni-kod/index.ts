// supabase/functions/ocijeni-kod/index.ts
// @ts-nocheck
//
// Poslužiteljska funkcija koja posreduje prema Gemini API-ju.
// Gemini ključ čuva se kao tajna na poslužitelju i nikada se ne šalje klijentu.
// Funkciju može pozvati samo prijavljeni korisnik, uz ograničenje broja zahtjeva.
//
// Funkcija dodatno provjerava valjanost odgovora modela: prazan odgovor,
// odgovor blokiran sigurnosnim filtrima, nevaljan JSON te istek vremena
// obrađuju se kao pogreška i ne prosljeđuju se aplikaciji kao rezultat.

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const GEMINI_KEY = Deno.env.get("GEMINI_API_KEY")!;
const GEMINI_MODEL = "gemini-3.6-flash";
const GEMINI_URL =
  `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent`;

const OGRANICENJE_NA_SAT = 60;
const ISTEK_MS = 25000;            // najdulje čekanje odgovora modela

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

    // --- 2. ograničenje broja zahtjeva po korisniku ---
    const prijeSat = new Date(Date.now() - 60 * 60 * 1000).toISOString();
    const { count } = await supabase
      .from("ai_zahtjevi")
      .select("*", { count: "exact", head: true })
      .eq("user_id", user.id)
      .gte("created_at", prijeSat);

    if ((count ?? 0) >= OGRANICENJE_NA_SAT) {
      return odgovor({ greska: "Prekoračen dopušten broj zahtjeva. Pokušaj kasnije." }, 429);
    }
    await supabase.from("ai_zahtjevi").insert({ user_id: user.id });

    // --- 3. provjera sadržaja upita ---
    const { uputa } = await req.json();
    if (typeof uputa !== "string" || uputa.length === 0 || uputa.length > 20000) {
      return odgovor({ greska: "Neispravan sadržaj upita." }, 400);
    }

    // --- 4. poziv modela, uz ograničeno vrijeme čekanja ---
    const prekid = new AbortController();
    const mjerac = setTimeout(() => prekid.abort(), ISTEK_MS);
    let gem: Response;
    try {
      gem = await fetch(GEMINI_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json", "x-goog-api-key": GEMINI_KEY },
        body: JSON.stringify({ contents: [{ parts: [{ text: uputa }] }] }),
        signal: prekid.signal,
      });
    } catch (_e) {
      return odgovor({ greska: "Model nije odgovorio u predviđenom vremenu." }, 504);
    } finally {
      clearTimeout(mjerac);
    }

    if (!gem.ok) {
      return odgovor({ greska: `AI servis nije dostupan (${gem.status}).` }, 502);
    }

    // --- 5. provjera valjanosti odgovora modela ---
    let podaci: Record<string, unknown>;
    try {
      podaci = await gem.json();
    } catch (_e) {
      return odgovor({ greska: "Odgovor modela nije u očekivanom obliku." }, 502);
    }

    // Odgovor može izostati i kada je poziv tehnički uspješan: model ga može
    // odbiti vratiti (sigurnosni filtri) ili prekinuti prije dovršetka.
    const blokada = (podaci as any)?.promptFeedback?.blockReason;
    if (blokada) {
      return odgovor({ greska: `Model je odbio odgovoriti (${blokada}).` }, 502);
    }

    const kandidati = (podaci as any)?.candidates;
    if (!Array.isArray(kandidati) || kandidati.length === 0) {
      return odgovor({ greska: "Model nije vratio odgovor." }, 502);
    }

    const razlog = kandidati[0]?.finishReason;
    if (razlog && razlog !== "STOP" && razlog !== "MAX_TOKENS") {
      return odgovor({ greska: `Odgovor modela je prekinut (${razlog}).` }, 502);
    }

    const tekst = kandidati[0]?.content?.parts?.[0]?.text;
    if (typeof tekst !== "string" || tekst.trim().length === 0) {
      return odgovor({ greska: "Model je vratio prazan odgovor." }, 502);
    }

    return odgovor({ tekst });
  } catch (e) {
    return odgovor({ greska: `Neočekivana pogreška: ${e}` }, 500);
  }
});