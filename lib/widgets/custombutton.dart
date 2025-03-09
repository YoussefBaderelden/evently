import 'package:evently_app/theme/apptheme.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.screendim,
    required this.text,
    required this.onpressed,
  });

  final Size screendim;
  final String text;
  final void Function()? onpressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpressed,
      child: Container(
        height: screendim.height * 0.08,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppTheme.primary,
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.white,
                ),
          ),
        ),
      ),
    );
  }
}
