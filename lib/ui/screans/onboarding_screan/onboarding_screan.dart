import 'package:event_planning_app/core/themes/app_colors.dart';
import 'package:event_planning_app/ui/screans/login_screan/login_screan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/App_assets/image_assets.dart';
import '../../../core/providers/theme_provider.dart';

class OnboardingScrean extends StatefulWidget {
  static const routeName = '/onboarding';

  OnboardingScrean({super.key});

  @override
  State<OnboardingScrean> createState() => _OnboardingScreanState();
}

class _OnboardingScreanState extends State<OnboardingScrean>
    with TickerProviderStateMixin {
  late ThemeProvider themeProvider;
  late PageController pageController;
  late TabController tabController;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              children: [
                _buildPage(
                  context,
                  themeProvider,
                  ImageAssets.on1,
                  ImageAssets.on1,
                  "Find Events That Inspire You",
                  "Dive into a world of events crafted to fit your\nunique interests. Whether you're into live\nmusic, art workshops, professional networking,\nor simplydiscovering new experiences, we\nhavesomething for everyone. Our curated\nrecommendations will help you explore,\nconnect, and make the most of every\nopportunity around you.",
                ),
                _buildPage(
                  context,
                  themeProvider,
                  ImageAssets.on2light,
                  ImageAssets.on2dark,
                  "Find Events That Inspire You",
                  "Take the hassle out of organizing events with\nour all-in-one planning tools. From setting up\ninvites and managing RSVPs to scheduling\nreminders and coordinating details, we’ve got\nyou covered. Plan with ease and focus on what\nmatters – creating an unforgettable experience\nfor you and your guests.",
                ),
                _buildPage(
                  context,
                  themeProvider,
                  ImageAssets.on3light,
                  ImageAssets.on3dark,
                  "Find Events That Inspire You",
                  "Make every event memorable by sharing the\nexperience with others. Our platform lets you\ninvite friends, keep everyone in the loop, and\ncelebrate moments together. Capture and\nshare the excitement with your network, so\nyou can relive the highlights and cherish the\nmemories.",
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  currentPageIndex != 0
                      ? InkWell(
                    onTap: () {
                      pageController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                    child: Image.asset(
                      ImageAssets.back,
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                  )
                      :  SizedBox(width:MediaQuery.of(context).size.width * 0.11),
                  SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    effect: const WormEffect(
                      activeDotColor: AppColors.primaryPurple,
                      dotHeight: 16,
                      dotWidth: 16,
                      type: WormType.thinUnderground,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (currentPageIndex == 2) {
                        Navigator.pushReplacementNamed(
                            context, LoginScrean.routName);
                      } else {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      }
                    },
                    child: Image.asset(
                      ImageAssets.next,
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(
      BuildContext context,
      ThemeProvider themeProvider,
      String imagePathLight,
      String imagePathDark,
      String title,
      String body,
      ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              ImageAssets.horizontalLogo,
              width: MediaQuery.of(context).size.width * 0.3,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Center(
            child: Image.asset(
              themeProvider.isDark() ? imagePathDark : imagePathLight,
              width: MediaQuery.of(context).size.width * 0.7,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Text(
            title,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryPurple,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Text(
            body,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: themeProvider.isDark() ? Colors.white : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
