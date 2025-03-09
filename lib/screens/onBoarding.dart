import 'package:evently_app/models/onboardingmodel.dart';
import 'package:evently_app/services/shared_keys.dart';
import 'package:evently_app/services/shared_preferences.dart';
import 'package:evently_app/theme/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  List<Onboardingmodel> onboardingmodel = Onboardingmodel.onboarding;

  PageController controller = PageController();

  int rightnowindex = 0;

  void goNext() {
    if (rightnowindex < onboardingmodel.length - 1) {
      rightnowindex++;
      controller.animateToPage(
        rightnowindex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousBoard() {
    if (rightnowindex > 0) {
      rightnowindex--;
      controller.animateToPage(
        rightnowindex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller,
                onPageChanged: (index) {
                  setState(
                    () {
                      rightnowindex = index;
                    },
                  );
                },
                scrollDirection: Axis.horizontal,
                itemCount: onboardingmodel.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset('assets/image/Group 4.png'),
                      SizedBox(
                        height: 16.0,
                      ),
                      Image.asset(onboardingmodel[index].image),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        onboardingmodel[index].title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.primary,
                            ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        onboardingmodel[index].text,
                        style: Theme.of(context).textTheme.bodyLarge,
                        softWrap: true,
                      ),
                    ],
                  );
                },
              ),
            ),
            rightnowindex == 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(
                        flex: 3,
                      ),
                      AnimatedSmoothIndicator(
                        activeIndex: rightnowindex,
                        count: onboardingmodel.length,
                        effect: ExpandingDotsEffect(
                          activeDotColor: AppTheme.primary,
                          dotColor: AppTheme.black,
                          dotHeight: 7,
                          dotWidth: 7,
                        ),
                      ),
                      Spacer(
                        flex: 2,
                      ),
                      IconButton(
                        onPressed: () {
                          controller.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: IconButton.styleFrom(
                          shape: CircleBorder(
                            side: BorderSide(
                              width: 1,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                        icon: Icon(
                          Icons.arrow_forward,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          controller.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: IconButton.styleFrom(
                          shape: CircleBorder(
                            side: BorderSide(
                              width: 1,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppTheme.primary,
                        ),
                      ),
                      AnimatedSmoothIndicator(
                        activeIndex: rightnowindex,
                        count: onboardingmodel.length,
                        effect: ExpandingDotsEffect(
                          activeDotColor: AppTheme.primary,
                          dotColor: AppTheme.black,
                          dotHeight: 7,
                          dotWidth: 7,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          if (rightnowindex == onboardingmodel.length - 1) {
                            LocalStorageServices.setbool(
                                LocalStorageKeys.runforthefirsttime, true);
                            Navigator.of(context).popAndPushNamed('login');
                          }
                        },
                        style: IconButton.styleFrom(
                          shape: CircleBorder(
                            side: BorderSide(
                              width: 1,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                        icon: Icon(
                          Icons.arrow_forward,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
