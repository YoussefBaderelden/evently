import 'package:evently_app/theme/apptheme.dart';
import 'package:evently_app/widgets/custombutton.dart';
import 'package:evently_app/widgets/flutterSwitcher.dart';
import 'package:flutter/material.dart';

class GetReadyScreen extends StatefulWidget {
  const GetReadyScreen({super.key});

  @override
  State<GetReadyScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<GetReadyScreen> {
  bool language = false;

  bool theme = false;
  int value = 0;

  @override
  Widget build(BuildContext context) {
    var screendim = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset('assets/image/Group 4.png'),
            Image.asset('assets/image/being-creative.png'),
            Text(
              'Personalize Your Experience',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.primary,
                  ),
            ),
            Text(
              'Choose your preferred theme and language to get started with a comfortable, tailored experience that suits your style.',
              style: Theme.of(context).textTheme.bodyLarge,
              softWrap: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Language',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: AppTheme.primary),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Theme',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: AppTheme.primary),
                ),
                ToggleSwitcher(
                  checked: language,
                  unselectedwidget: Icon(
                    Icons.wb_sunny_outlined,
                    color: AppTheme.white,
                  ),
                  selectedwidget: Icon(
                    Icons.nightlight,
                    color: AppTheme.primary,
                  ),
                  unselectedwidgetshown: Icon(
                    Icons.wb_sunny_outlined,
                    color: AppTheme.primary,
                  ),
                  selectedwidgetshown: Icon(
                    Icons.nightlight,
                    color: AppTheme.white,
                  ),
                ),
              ],
            ),
            CustomButton(
              onpressed: () =>
                  Navigator.of(context).pushReplacementNamed('onboarding'),
              screendim: screendim,
              text: 'Let\'s Start',
            )
          ],
        ),
      ),
    );
  }
}
