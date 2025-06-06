import 'package:flutter/material.dart';

import '../../../core/themes/app_colors.dart';

class TabBarTabsWidget extends StatelessWidget {
  final String tabName;
  final TabController tabController;
  final int index;
  final IconData icon;
  final bool inHome;

  const TabBarTabsWidget(
      {super.key,
      required this.tabName,
      required this.tabController,
      required this.index,
      required this.icon,
      required this.inHome});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(46),
          color: tabController.index == index
              ? inHome
                  ?  AppColors.bgwhite
                  : AppColors.primaryPurple
              : inHome
                  ? Colors.transparent
                  :  AppColors.bgwhite,
          border: Border.all(color: AppColors.primaryPurple, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: tabController.index == index
                  ? inHome
                      ? AppColors.primaryPurple
                      : AppColors.bgwhite
                  : inHome
                      ?  AppColors.bgwhite
                      : AppColors.primaryPurple,
            ),
            const SizedBox(width: 6),
            Text(
              tabName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: tabController.index == index
                    ? inHome
                        ? AppColors.primaryPurple
                        :  AppColors.bgwhite
                    : inHome
                        ?  AppColors.bgwhite
                        : AppColors.primaryPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
