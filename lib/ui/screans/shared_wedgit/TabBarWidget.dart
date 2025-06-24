import 'package:event_planning_app/core/models/categoryDm.dart';
import 'package:event_planning_app/ui/screans/shared_wedgit/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_local_provider.dart';
import '../../../core/providers/theme_provider.dart';

class Tabbarwidget extends StatefulWidget {
  final TabController tabController;
  final bool inhome;
  final List<Categorydm> category;

  final Function(Categorydm) categoryClicked;

  const Tabbarwidget(
      {super.key,
      required this.tabController,
      required this.inhome,
      required this.categoryClicked,
      required this.category});

  @override
  State<Tabbarwidget> createState() => _TabbarwidgetState();
}

class _TabbarwidgetState extends State<Tabbarwidget> {
  late ThemeProvider themeProvider;
  late AppLocaleProvider appLocaleProvider;
  late AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocaleProvider = Provider.of<AppLocaleProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;
    return TabBar(
      onTap: (value) {
        widget.tabController.index = value;
        widget.categoryClicked(widget.category[value]);
        setState(() {});
      },
      controller: widget.tabController,
      indicatorPadding: EdgeInsets.zero,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      indicatorColor: Colors.transparent,
      dividerColor: Colors.transparent,
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      tabs: widget.category
          .map((category) => TabBarTabsWidget(
                inHome: widget.inhome,
                tabName: category.name,
                tabController: widget.tabController,
                index: widget.category.indexOf(category),
                icon: category.icon,
              ))
          .toList(),
    );
  }
}


