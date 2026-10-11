import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/supabase_service.dart';
import 'auth_screens.dart';
import 'reset_password_screen.dart';

// Globalni navigatorKey omogućuje navigaciju IZVAN build() metode - koristan
// ako se link za reset lozinke otvori DOK je app već pokrenut (rjeđi slučaj).
final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  // VAŽNO: spremamo originalnu adresu OVDJE, PRIJE usePathUrlStrategy() poziva.
  // Taj poziv zna odmah "počistiti"/promijeniti adresu (npr. ukloniti dio iza
  // #), pa ako token iz email linka provjerimo NAKON toga, može već biti
  // izgubljen.
  final pocetnaAdresa = Uri.base;

  // Flutter web inače sam koristi dio adrese iza "#" za svoju navigaciju
  // kroz ekrane, što se SUKOBLJAVA s Supabase-ovim tokenom za reset lozinke
  // (koji se šalje upravo u tom dijelu adrese). Ova linija to isključuje -
  // Flutter prelazi na "obične" adrese (npr. /home umjesto /#/home), a dio
  // iza "#" ostaje slobodan isključivo za Supabase.
  usePathUrlStrategy();

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://29bac32f23100e95be019efb8dd810fa@o4512085250342912.ingest.de.sentry.io/4512085261746256';
      options.tracesSampleRate = 1.0;
      options.environment = 'development';
    },
    appRunner: () async {
      WidgetsFlutterBinding.ensureInitialized();
      await initSupabase();

      // Ako je korisnik upravo kliknuo link za reset lozinke iz emaila,
      // adresa će (uz implicit flow) sadržavati "#access_token=...&type=recovery"
      // iza znaka #. Supabase je taj token već obradio i uspostavio privremenu
      // "recovery" sesiju TIJEKOM initSupabase() poziva iznad - ovdje samo
      // provjeravamo URL da odlučimo koji ekran prikazati prvi, umjesto da se
      // oslanjamo na stream koji zna propustiti događaj ako se pretplatimo
      // prekasno.
      final jePovratakIzEmailLinka =
          pocetnaAdresa.queryParameters.containsKey('code') ||
              pocetnaAdresa.fragment.contains('type=recovery');

      // NAPOMENA: namjerno NE slušamo supabase.auth.onAuthStateChange za
      // AuthChangeEvent.passwordRecovery ovdje. Kad se link otvori u novom
      // tabu, Supabase u pozadini "javi" i STAROM, već otvorenom tabu da se
      // dogodila promjena - što zna uzrokovati da SVAKI put nasumično jedan
      // od ta dva taba (stari ili novi) "pobijedi" i prikaže ekran za reset.
      // Provjera direktno preko URL-a (gore) je pouzdana i dovoljna - SAMO
      // tab koji se stvarno učita s linkom u adresi prikazuje reset ekran,
      // stari tab ostaje potpuno netaknut.

      runApp(MyApp(pocetniEkranJeResetLozinke: jePovratakIzEmailLinka));
    },
  );
}

class MyApp extends StatelessWidget {
  final bool pocetniEkranJeResetLozinke;

  const MyApp({super.key, this.pocetniEkranJeResetLozinke = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Bloomly',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [SentryNavigatorObserver()],
      theme: ThemeData(
        primaryColor: const Color(0xFF378ADD),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF378ADD)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF378ADD),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      home: pocetniEkranJeResetLozinke
          ? const ResetPasswordScreen()
          : const LoginScreen(),
    );
  }
}