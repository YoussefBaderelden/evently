import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/services/firebaseServices.dart';
import 'package:evently_app/theme/apptheme.dart';
import 'package:evently_app/widgets/custombutton.dart';
import 'package:evently_app/widgets/customtextfield.dart';
import 'package:evently_app/widgets/flutterSwitcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RigesterScreen extends StatefulWidget {
  const RigesterScreen({super.key});

  @override
  State<RigesterScreen> createState() => _RigesterScreenState();
}

class _RigesterScreenState extends State<RigesterScreen> {
  bool language = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordemailController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var screendim = MediaQuery.sizeOf(context);

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Rigester',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Form(
        key: formkey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/image/Logo.png'),
                SizedBox(
                  height: 24,
                ),
                CustomTextField(
                    validator: (value) {
                      if (value == null || value.length < 3) {
                        return 'name can\'t be less than 3 charachters';
                      }
                      return null;
                    },
                    controller: nameController,
                    onChanged: (value) => nameController.text = value,
                    imagepath: 'assets/SVG/profile.svg',
                    hinttext: 'Name'),
                SizedBox(
                  height: 16,
                ),
                CustomTextField(
                  validator: (value) {
                    if (value == null || value.length < 5) {
                      return 'Invalid Email';
                    }
                    return null;
                  },
                  controller: emailController,
                  onChanged: (value) => emailController.text = value,
                  imagepath: 'assets/SVG/email.svg',
                  hinttext: 'Email',
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
                  imagepath: 'assets/SVG/lock.svg',
                  showsuffix: true,
                  hinttext: 'Password',
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
                    controller: repasswordemailController,
                    onChanged: (value) =>
                        repasswordemailController.text = value,
                    imagepath: 'assets/SVG/lock.svg',
                    showsuffix: true,
                    hinttext: 'Re Password '),
                SizedBox(
                  height: 16,
                ),
                CustomButton(
                  screendim: screendim,
                  text: 'Create Account',
                  onpressed: register,
                ),
                SizedBox(
                  height: 16,
                ),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyLarge,
                    children: [
                      TextSpan(
                        text: 'Already Have Account?',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextSpan(
                        text: 'Login',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.primary,
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context);
                          },
                      ),
                    ],
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void register() {
    if (formkey.currentState!.validate()) {
      FireBaseServices.register(
        name: nameController.text.trim(),
        password: passwordController.text.trim(),
        email: emailController.text.trim(),
      ).then((user) {
        Provider.of<UserProvider>(context, listen: false)
            .updateCurrentUser(user);
        Navigator.of(context).pushReplacementNamed('home');
      }).catchError(
        (error) => print('something went error'),
      );
    }
  }
}
