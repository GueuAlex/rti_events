import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rti_events/screens/scan_screen/scan_screen.dart';

import 'config/palette.dart';
import 'screens/scan_history/scan_history.dart';
import 'screens/splash_screen/splash_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    const ProviderScope(
      child: RtiEvents(),
    ),
  );
}

class RtiEvents extends StatelessWidget {
  const RtiEvents({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
      ],
      locale: const Locale('eu', 'FR'),
      title: 'RTI.Events',
      theme: ThemeData(
        useMaterial3: true, //
        //scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Palette.primaryColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
      ),
      builder: EasyLoading.init(),
      initialRoute: SplashSceen.routeName,
      routes: {
        '/': (ctxt) => const ScannerScreen(),
        SplashSceen.routeName: (ctxt) => const SplashSceen(),
        ScanHistory.routeName: (ctxt) => const ScanHistory(),
      },
    );
  }
}
