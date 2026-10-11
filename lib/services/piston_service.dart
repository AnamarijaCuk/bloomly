// lib/services/piston_service.dart
//
// Šalje Python kod na izvršavanje kroz poslužiteljsku funkciju "izvrsi-kod",
// koja čuva tajno zaglavlje kojim je Piston zaštićen.
//
// Rezultat izvršavanja razlikuje četiri odvojena podatka:
//   - izlazni status programa (exit code)
//   - signal kojim je proces eventualno prekinut (npr. SIGKILL)
//   - standardni ispis programa (stdout)
//   - dijagnostiku, odnosno standardni izlaz za pogreške (stderr)
//
// Uspješnim izvršavanjem smatra se izlazni status 0 bez prekidnog signala.
// Sadržaj stderr-a sam po sebi NIJE kriterij neuspjeha, budući da programi
// na taj izlaz redovito pišu i upozorenja koja ne znače pogrešku.

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class PistonRunResult {
  /// Izlazni status programa; null ako je proces prekinut signalom.
  final int? exitCode;

  /// Naziv signala kojim je proces prekinut (npr. SIGKILL), inače null.
  final String? signal;

  /// Standardni ispis programa.
  final String stdout;

  /// Dijagnostika: poruke o pogreškama i upozorenja interpretera.
  final String stderr;

  /// false ako poslužitelj za izvršavanje nije bio dostupan.
  final bool available;

  PistonRunResult({
    required this.exitCode,
    required this.signal,
    required this.stdout,
    required this.stderr,
    this.available = true,
  });

  /// Program je uspješno izvršen ako je završio sam od sebe, s izlaznim
  /// statusom 0. Prekid signalom (npr. zbog isteka vremena ili prekoračenja
  /// memorije) i svaki status različit od nule smatraju se neuspjehom.
  bool get success => available && exitCode == 0 && (signal == null || signal!.isEmpty);

  /// true ako je izvršavanje prekinuto zbog prekoračenja postavljenih
  /// ograničenja (vrijeme, memorija, veličina ispisa).
  bool get prekinutoOgranicenjem => signal != null && signal!.isNotEmpty;

  /// Poruka prikladna za prikaz korisniku kada izvršavanje nije uspjelo.
  String get dijagnostika {
    if (!available) return stderr;
    if (prekinutoOgranicenjem) {
      return stderr.isNotEmpty
          ? stderr
          : 'Izvršavanje je prekinuto ($signal), najvjerojatnije zbog '
              'prekoračenja dopuštenog vremena ili memorije.';
    }
    return stderr;
  }

  factory PistonRunResult.nedostupan(String poruka) => PistonRunResult(
        exitCode: null, signal: null, stdout: '', stderr: poruka, available: false,
      );
}

class PistonService {
  static const String _funkcija = 'izvrsi-kod';

  static Future<PistonRunResult> runPython(String code) async {
    if (code.trim().isEmpty) {
      return PistonRunResult(
        exitCode: 1, signal: null, stdout: '',
        stderr: 'Nema koda za pokretanje.',
      );
    }

    try {
      final odgovor = await Supabase.instance.client.functions
          .invoke(_funkcija, body: {'kod': code})
          .timeout(const Duration(seconds: 30));

      final podaci = odgovor.data;

      if (odgovor.status != 200 || podaci is! Map) {
        final poruka = (podaci is Map && podaci['greska'] != null)
            ? podaci['greska'].toString()
            : 'status ${odgovor.status}';
        return PistonRunResult.nedostupan(
            'Poslužitelj za izvršavanje koda nije odgovorio ispravno ($poruka).');
      }

      // Provjera tipova polja: odgovor se ne prihvaća ako struktura
      // ne odgovara očekivanoj, čak i kada je HTTP status uspješan.
      final stdout = podaci['stdout'];
      final stderr = podaci['stderr'];
      if (stdout is! String || stderr is! String) {
        return PistonRunResult.nedostupan(
            'Poslužitelj za izvršavanje koda vratio je neočekivan oblik odgovora.');
      }
      final exitCode = podaci['code'] is int ? podaci['code'] as int : null;
      final signal = podaci['signal'] is String ? podaci['signal'] as String : null;

      return PistonRunResult(
        exitCode: exitCode,
        signal: signal,
        stdout: stdout.trimRight(),
        stderr: stderr.trimRight(),
      );
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        hint: Hint.withMap({'mjesto': 'PistonService.runPython'}),
      );
      return PistonRunResult.nedostupan(
          'Poslužitelj za izvršavanje koda trenutno nije dostupan.');
    }
  }
}