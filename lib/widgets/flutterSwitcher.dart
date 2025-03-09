import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:evently_app/theme/apptheme.dart';
import 'package:flutter/material.dart';

class ToggleSwitcher extends StatefulWidget {
  ToggleSwitcher({
    super.key,
    required this.checked,
    required this.selectedwidget,
    required this.unselectedwidget,
    this.selectedwidgetshown,
    this.unselectedwidgetshown,
  });
  bool checked;
  Widget selectedwidget;
  Widget unselectedwidget;
  Widget? selectedwidgetshown;
  Widget? unselectedwidgetshown;

  @override
  State<ToggleSwitcher> createState() => _ToggleSwitcherState();
}

class _ToggleSwitcherState extends State<ToggleSwitcher> {
  @override
  Widget build(BuildContext context) {
    var screendim = MediaQuery.sizeOf(context);
    return AnimatedToggleSwitch<bool>.dual(
      current: widget.checked,
      first: false,
      second: true,
      spacing: 12,
      indicatorSize: Size(30, 30),
      style: ToggleStyle(
          borderColor: AppTheme.primary,
          borderRadius: BorderRadius.circular(60)),
      borderWidth: 1.5,
      height: screendim.height * 0.038,
      onChanged: (b) => setState(() => widget.checked = b),
      styleBuilder: (b) => ToggleStyle(
        indicatorColor: AppTheme.primary,
        indicatorBorderRadius: BorderRadius.circular(60),
      ),
      iconBuilder: (value) => value
          ? widget.selectedwidgetshown ?? widget.selectedwidget
          : widget.unselectedwidget,
      textBuilder: (value) => value
          ? widget.unselectedwidgetshown ?? widget.unselectedwidget
          : widget.selectedwidget,
    );
  }
}
