import 'package:evently_app/authentication/forgetpassword.dart';
import 'package:evently_app/authentication/login.dart';
import 'package:evently_app/authentication/rigesterscreen.dart';
import 'package:evently_app/providers/event_provider.dart';
import 'package:evently_app/providers/map_provider.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/screens/chooseLocationScreen.dart';
import 'package:evently_app/screens/create_event.dart';
import 'package:evently_app/screens/editEvent.dart';
import 'package:evently_app/screens/event_details.dart';

import 'package:evently_app/screens/getready.dart';
import 'package:evently_app/screens/homescreen.dart';
import 'package:evently_app/screens/onBoarding.dart';
import 'package:evently_app/services/shared_keys.dart';
import 'package:evently_app/theme/apptheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:evently_app/services/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalStorageServices.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => UserProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => MapProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => EventsProvider(),
      ),
    ],
    child: Evently_App(),
  ));
}

// ignore: camel_case_types
class Evently_App extends StatelessWidget {
  const Evently_App({super.key});
  @override
  Widget build(BuildContext context) {
    bool runforthefirsttime = LocalStorageServices.getbool(
          LocalStorageKeys.runforthefirsttime,
        ) ??
        false;
    bool loginpagekey = LocalStorageServices.getbool(
          LocalStorageKeys.loginpagekey,
        ) ??
        false;
    return MaterialApp(
      home: runforthefirsttime
          ? loginpagekey
              ? HomeScreen()
              : LoginScreen()
          : GetReadyScreen(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lighttheme,
      routes: {
        'getready': (context) => GetReadyScreen(),
        'onboarding': (context) => OnBoarding(),
        'login': (context) => LoginScreen(),
        'register': (context) => RigesterScreen(),
        'forget': (context) => ForgetPassword(),
        'home': (context) => HomeScreen(),
        'event': (context) => CreateEvent(),
        'editevent': (context) => EditEvent(),
        'details': (context) => EventDetails(),
        'chooselocation': (context) => ChooseLocation(),
      },
      initialRoute: 'login',
    );
  }
}
