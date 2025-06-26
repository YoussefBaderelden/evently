import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/App_assets/image_assets.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/themes/app_colors.dart';
import '../setup_screan.dart';

class SplashScrean extends StatefulWidget {
  static const String routeName = '/splash';

  const SplashScrean({super.key});

  @override
  State<SplashScrean> createState() => _SplashScreanState();
}

class _SplashScreanState extends State<SplashScrean> {
  late ThemeProvider themeProvider;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, SetupScrean.routName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDark()
          ? AppColors.bgDarkDarkPurple
          : AppColors.bgwhite,
      body: Center(
        child: Image(
          image: const AssetImage(ImageAssets.verticalLogo),
          width: MediaQuery.of(context).size.width * 0.3,
        ),
      ),
    );
  }
}

