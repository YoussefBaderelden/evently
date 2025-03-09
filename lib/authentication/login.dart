import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_app/models/usermodel.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/services/firebaseServices.dart';
import 'package:evently_app/theme/apptheme.dart';
import 'package:evently_app/widgets/custombutton.dart';
import 'package:evently_app/widgets/customtextfield.dart';
import 'package:evently_app/widgets/flutterSwitcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool language = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    var screendim = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isloading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.primary,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    Image.asset('assets/image/Logo.png'),
                    SizedBox(
                      height: 24,
                    ),
                    CustomTextField(
                      validator: (value) {
                        if (value == null || value.length < 5) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      controller: emailController,
                      onChanged: (value) => emailController.text = value,
                      hinttext: 'Email',
                      imagepath: 'assets/SVG/email.svg',
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    CustomTextField(
                      validator: (value) {
                        if (value == null || value.length < 5) {
                          return 'password can\'t be less than 8 charachters';
                        }
                        return null;
                      },
                      controller: passwordController,
                      onChanged: (value) => passwordController.text = value,
                      hinttext: 'Password',
                      imagepath: 'assets/SVG/lock.svg',
                      showsuffix: true,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('forget');
                        },
                        child: Text(
                          'Forget Password?',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.primary,
                                  ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    CustomButton(
                      onpressed:
                          // Navigator.of(context).pushNamed('home');
                          // LocalStorageServices.setbool(
                          //     LocalStorageKeys.loginpagekey, true);
                          login,
                      screendim: screendim,
                      text: 'Login',
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyLarge,
                        children: [
                          TextSpan(
                            text: 'Don\'t Have Account?',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          TextSpan(
                            text: 'Create Account',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppTheme.primary,
                                ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pushNamed('register');
                              },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: AppTheme.primary,
                            indent: 20,
                            endIndent: 15,
                          ),
                        ),
                        Text(
                          'Or',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppTheme.primary,
                                  ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: AppTheme.primary,
                            indent: 15,
                            endIndent: 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    InkWell(
                      onTap: signInWithGoogle,
                      child: Container(
                        height: screendim.height * 0.08,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.primary,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/SVG/super g.svg'),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Login With Google',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: AppTheme.primary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    ToggleSwitcher(
                      checked: language,
                      unselectedwidget: Image.asset(
                        'assets/image/LR.png',
                        fit: BoxFit.cover,
                      ),
                      selectedwidget: Image.asset(
                        'assets/image/EG.png',
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  void login() {
    if (formkey.currentState!.validate()) {
      FireBaseServices.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ).then((user) {
        Provider.of<UserProvider>(context, listen: false)
            .updateCurrentUser(user);
        Navigator.of(context).pushReplacementNamed('home');
      }).catchError(
        (error) => print(passwordController.text),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      isloading = true;
    });
    try {
      await GoogleSignIn().signOut();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        DocumentSnapshot<UserModel> userDoc =
            await FireBaseServices.getUserCollection()
                .doc(userCredential.user!.uid)
                .get();

        UserModel user;
        if (!userDoc.exists) {
          user = UserModel(
            id: userCredential.user!.uid,
            name: userCredential.user!.displayName ?? 'No Name',
            email: userCredential.user!.email ?? 'No Email',
            favourits: [],
          );

          await FireBaseServices.getUserCollection().doc(user.id).set(user);
        } else {
          // If the user exists, fetch the user data
          user = userDoc.data()!;
        }

        // Update the user provider and navigate to the home screen
        Provider.of<UserProvider>(context, listen: false)
            .updateCurrentUser(user);
        Navigator.of(context).pushReplacementNamed('home');
      }
    } catch (e) {
      print("Error during Google Sign-In: $e");
      // Optionally, show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Google: $e')),
      );
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }
}
