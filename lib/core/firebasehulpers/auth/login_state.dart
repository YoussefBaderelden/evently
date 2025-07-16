import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ui/screans/bottum_navigation/button_navigation_bar.dart';
import '../../../ui/screans/login_screan/login_screan.dart';
import '../../providers/app_provider.dart';
import '../store/firestore_hulpers.dart';

class AuthWrapper extends StatefulWidget {
  static const routeName = '/auth-wrapper';
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;

          return FutureBuilder(
            future: getUserfromFirestore(user.uid),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }

              if (userSnapshot.hasData) {
                final userDM = userSnapshot.data!;

                Future.microtask(() {
                  final appProvider =
                  Provider.of<AppProvider>(context, listen: false);
                  appProvider.updateUser(userDM);
                  Navigator.pushReplacementNamed(
                      context, ButtonNavigationBar.routeName);
                });

                return const Scaffold(body: SizedBox());
              }

              return LoginScrean(); // fallback
            },
          );
        } else {
          return LoginScrean();
        }
      },
    );
  }
}


