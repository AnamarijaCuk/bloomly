import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://tnpedjwayexwgeuautgw.supabase.co';
const supabaseAnonKey = 'sb_publishable_5i-e-9J--xXUIEGLb3g_8g_F7v_8kf9';

Future<void> initSupabase() async {
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
    // Implicit flow umjesto zadanog PKCE flow-a: token za reset lozinke
    // stiže IZRAVNO u linku (u dijelu adrese iza #), pa ne treba lokalno
    // spremljeni "tajni kod za provjeru" koji zna nedostajati kad se link
    // otvori u drugom pregledniku/tabu/profilu nego onaj koji je zatražio
    // reset. Malo je manje strogo sigurnosno, ali za razvoj/diplomski rad
    // (i lokalno testiranje) je posve u redu i puno pouzdanije.
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.implicit,
    ),
  );
}

final supabase = Supabase.instance.client;