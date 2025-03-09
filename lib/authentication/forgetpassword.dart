import 'package:evently_app/widgets/custombutton.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    var screendim = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Forget Password',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Column(
          children: [
            Image.asset('assets/image/change-setting.png'),
            SizedBox(
              height: 24,
            ),
            CustomButton(
              screendim: screendim,
              text: 'Reset Password',
              onpressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
