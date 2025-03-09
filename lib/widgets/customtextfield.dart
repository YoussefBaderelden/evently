import 'package:evently_app/theme/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  CustomTextField({
    super.key,
    this.imagepath,
    this.showsuffix = false,
    required this.hinttext,
    this.obsecuretext = false,
    this.controller,
    this.validator,
    this.onChanged,
    this.bordercolor,
    this.maxlines = 1,
    this.onSubmitted,
  });

  String? imagepath;
  int? maxlines;
  bool showsuffix;
  String hinttext;
  bool obsecuretext;
  TextEditingController? controller;
  String? Function(String?)? validator;
  void Function(String)? onChanged;
  void Function(String)? onSubmitted;
  Color? bordercolor;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    TextTheme texttheme = Theme.of(context).textTheme;
    return TextFormField(
      style: texttheme.bodyLarge?.copyWith(
        color: widget.bordercolor == null ? AppTheme.gray : widget.bordercolor!,
      ),
      maxLines: widget.maxlines,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      obscureText: widget.obsecuretext,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: widget.bordercolor == null
                ? AppTheme.gray
                : widget.bordercolor!,
            width: 3.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: widget.bordercolor == null
                ? AppTheme.gray
                : widget.bordercolor!,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppTheme.primary,
            width: 1.0,
          ),
        ),
        hintText: widget.hinttext,
        hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: widget.bordercolor == null
                  ? AppTheme.gray
                  : widget.bordercolor!,
            ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(16.0),
          child: widget.imagepath == null
              ? null
              : SvgPicture.asset(
                  widget.imagepath!,
                  colorFilter: ColorFilter.mode(
                    widget.bordercolor == null
                        ? AppTheme.gray
                        : widget.bordercolor!,
                    BlendMode.srcIn,
                  ),
                ),
        ),
        prefixIconConstraints: widget.imagepath == null
            ? BoxConstraints.tight(Size(16, 16))
            : BoxConstraints.tight(Size(55, 55)),
        suffixIcon: widget.showsuffix
            ? IconButton(
                onPressed: () {
                  widget.obsecuretext = !widget.obsecuretext;
                  setState(() {});
                },
                icon: Icon(
                  widget.obsecuretext ? Icons.visibility : Icons.visibility_off,
                ),
              )
            : null,
        suffixIconConstraints: BoxConstraints.tight(Size(55, 55)),
      ),
    );
  }
}
