import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TabItem extends StatelessWidget {
  TabItem({
    super.key,
    required this.isSelected,
    required this.selectedcolor,
    required this.unselectedcolor,
    required this.text,
    required this.icon,
  });

  bool isSelected;
  Color selectedcolor;
  Color unselectedcolor;
  String text;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? selectedcolor : unselectedcolor,
        borderRadius: BorderRadius.circular(46),
        border: Border.all(
          color: selectedcolor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: isSelected ? unselectedcolor : selectedcolor),
          SizedBox(width: 12),
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isSelected ? unselectedcolor : selectedcolor,
                ),
          ),
        ],
      ),
    );
  }
}
