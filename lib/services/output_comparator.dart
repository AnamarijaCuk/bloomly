// lib/services/output_comparator.dart
//
// Deterministička provjera točnosti rješenja: uspoređuje STVARNI ispis
// korisnikova koda (dobiven od Pistona) s OČEKIVANIM ispisom zadatka.
// Ova usporedba, a ne AI model, određuje je li zadatak riješen točno.

import 'piston_service.dart';

enum IshodProvjere {
  /// Program se izvršio i ispis se podudara s očekivanim.
  tocno,

  /// Program se izvršio, ali ispis se ne podudara s očekivanim.
  netocanIspis,

  /// Izvršavanje je prekinuto pogreškom u programu.
  greskaIzvrsavanja,

  /// Izvršavanje je prekinuto zbog prekoračenja postavljenih ograničenja
  /// (vrijeme, memorija, veličina ispisa).
  prekoracenoOgranicenje,

  /// Provjera nije provedena: poslužitelj nije dostupan ili zadatak
  /// nema definiran očekivani ispis. Rješenje se NE smatra točnim.
  nijeProvjereno,
}

class ProvjeraRjesenja {
  final IshodProvjere ishod;
  final String stvarniIspis;
  final String porukaPogreske;
  final String ocekivaniIspis;

  /// Prolaz dodjeljuje isključivo deterministička usporedba.
  bool get prolaz => ishod == IshodProvjere.tocno;

  ProvjeraRjesenja({
    required this.ishod,
    required this.stvarniIspis,
    required this.porukaPogreske,
    required this.ocekivaniIspis,
  });
}

class OutputComparator {
  /// Normalizira ispis prije usporedbe: ujednačava prijelome redaka,
  /// uklanja razmake na kraju svakog retka te prazne retke na krajevima.
  static String normaliziraj(String ispis) {
    final redci = ispis
        .replaceAll('\r\n', '\n')
        .split('\n')
        .map((redak) => redak.trimRight())
        .toList();

    while (redci.isNotEmpty && redci.last.isEmpty) {
      redci.removeLast();
    }
    while (redci.isNotEmpty && redci.first.isEmpty) {
      redci.removeAt(0);
    }
    return redci.join('\n');
  }

  static ProvjeraRjesenja provjeri({
    required PistonRunResult rezultat,
    required String ocekivaniIspis,
  }) {
    // 1. Poslužitelj nije bio dostupan — provjera se ne provodi.
    if (!rezultat.available) {
      return ProvjeraRjesenja(
        ishod: IshodProvjere.nijeProvjereno,
        stvarniIspis: '',
        porukaPogreske: rezultat.dijagnostika,
        ocekivaniIspis: ocekivaniIspis,
      );
    }

    // 2. Izvršavanje prekinuto signalom — prekoračeno ograničenje,
    //    što se razlikuje od pogreške u samom programu.
    if (rezultat.prekinutoOgranicenjem) {
      return ProvjeraRjesenja(
        ishod: IshodProvjere.prekoracenoOgranicenje,
        stvarniIspis: rezultat.stdout,
        porukaPogreske: rezultat.dijagnostika,
        ocekivaniIspis: ocekivaniIspis,
      );
    }

    // 3. Program je završio s izlaznim statusom različitim od nule.
    if (!rezultat.success) {
      return ProvjeraRjesenja(
        ishod: IshodProvjere.greskaIzvrsavanja,
        stvarniIspis: rezultat.stdout,
        porukaPogreske: rezultat.stderr,
        ocekivaniIspis: ocekivaniIspis,
      );
    }

    // 4. Zadatak nema definiran očekivani ispis — usporedba nije moguća.
    if (normaliziraj(ocekivaniIspis).isEmpty) {
      return ProvjeraRjesenja(
        ishod: IshodProvjere.nijeProvjereno,
        stvarniIspis: rezultat.stdout,
        porukaPogreske: '',
        ocekivaniIspis: ocekivaniIspis,
      );
    }

    // 5. Deterministička usporedba ispisa.
    final podudara =
        normaliziraj(rezultat.stdout) == normaliziraj(ocekivaniIspis);

    return ProvjeraRjesenja(
      ishod: podudara ? IshodProvjere.tocno : IshodProvjere.netocanIspis,
      stvarniIspis: rezultat.stdout,
      // Program je uspješno završio, no eventualna upozorenja na stderr-u
      // zadržavaju se kao dijagnostika, bez utjecaja na ishod provjere.
      porukaPogreske: rezultat.stderr,
      ocekivaniIspis: ocekivaniIspis,
    );
  }
}