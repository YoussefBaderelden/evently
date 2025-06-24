import 'package:event_planning_app/core/providers/app_local_provider.dart';
import 'package:event_planning_app/core/themes/app_theme.dart';
import 'package:event_planning_app/ui/screans/bottum_navigation/button_navigation_bar.dart';
import 'package:event_planning_app/ui/screans/eventScrean/create_event_screan.dart';
import 'package:event_planning_app/ui/screans/home/home_screan.dart';
import 'package:event_planning_app/ui/screans/login_screan/login_screan.dart';
import 'package:event_planning_app/ui/screans/rigester/sinup_screan.dart';
import 'package:event_planning_app/ui/screans/setup_screan.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //ensure that the engein starts and any logic before the app stars
  await Firebase.initializeApp(
      //DefaultFirebaseOptions.currentPlatform => for cli installation
      options: const FirebaseOptions(
          apiKey: 'AIzaSyB4dgfzsERAY2RX19zjYL3jm7ALuv-5kJo',
          appId: '1:542754527189:android:957de4da76e18b79220f5c',
          messagingSenderId: '',
          projectId: 'evently-app-54820'));
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => AppLocaleProvider(),
    )
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  late ThemeProvider themeProvider;
  late AppLocaleProvider appProvider;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appProvider = Provider.of<AppLocaleProvider>(context);
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(appProvider.AppLocal),
      themeMode: themeProvider.getThemeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      routes: {
        SetupScrean.routName: (_) => SetupScrean(),
        LoginScrean.routName: (_) => LoginScrean(),
        SinupScrean.routName: (_) => SinupScrean(),
        HomeScrean.routeName: (_) => HomeScrean(),
        ButtonNavigationBar.routeName: (_) => const ButtonNavigationBar(),
        CreateEventScrean.routeName: (_) => CreateEventScrean(),
      },
      initialRoute: LoginScrean.routName,
    );
  }
}
