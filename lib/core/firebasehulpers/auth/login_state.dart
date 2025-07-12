import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ui/screans/bottum_navigation/button_navigation_bar.dart';
import '../../../ui/screans/login_screan/login_screan.dart';
import '../../providers/app_provider.dart';
import '../store/firestore_hulpers.dart';

class AuthWrapper extends StatefulWidget {
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
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Provider.of<AppProvider>(context, listen: false)
                      .updateUser(userSnapshot.data!);
                });

                return const ButtonNavigationBar();
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
