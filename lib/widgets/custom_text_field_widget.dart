import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

class CustomTextFieldWidget extends StatelessWidget {
  const CustomTextFieldWidget(
      {super.key,
      this.labelText,
      this.hintText,
      required this.controller,
      this.suffixIcon,
      this.prefixIcon,
      required this.obscureText,
      this.maxLines,
      required this.filled,
      required this.keyboardType,
      this.errorText,
      this.maxLength,
      this.onChanged,
      this.enableInteractiveSelection,
      this.willContainPrefix,
      required this.readOnly,
      this.validator,
      this.onTap,
      this.maxLengthEnforcement,
       this.autoValidateMode,
      this.suffix,
      this.suffixIconColor});
  final String? labelText;
  final String? hintText;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Color? suffixIconColor;
  final bool obscureText;
  final int? maxLines;
  final bool filled;
  final TextInputType keyboardType;
  final String? errorText;
  final int? maxLength;
  final void Function(String)? onChanged;
  final bool? enableInteractiveSelection;
  final bool? willContainPrefix;
  final bool readOnly;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final AutovalidateMode? autoValidateMode;
  final MaxLengthEnforcement? maxLengthEnforcement;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 3.w),
          child: Text(
            labelText!,
            style: GoogleFonts.lato(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
        TextFormField(
          autovalidateMode: autoValidateMode,
          readOnly: readOnly,
          onTap: onTap,
          autofocus: true,
          enableSuggestions: true,
          keyboardType: keyboardType,
          obscureText: obscureText,
          controller: controller,
          cursorColor: Theme.of(context).colorScheme.primary,
          enableInteractiveSelection: enableInteractiveSelection,
          style: GoogleFonts.lato(
              color: Theme.of(context).colorScheme.primary, fontSize: 14),

          inputFormatters: [],
          maxLength: maxLength,
          decoration: InputDecoration(
            filled: filled,
            // fillColor: Colors.black12,
            fillColor: Theme.of(context).canvasColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xffE0E0E0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: brandOne, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xffE0E0E0),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            hintText: hintText,
            errorStyle: GoogleFonts.lato(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            hintStyle: GoogleFonts.lato(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            errorText: errorText,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            suffix: suffix,
            suffixIconColor: suffixIconColor,
            
            contentPadding: EdgeInsets.all(14.sp),
          ),
          maxLines: 1,

          validator: validator,
          //  onChanged: onChanged,
        ),
      ],
    );
  }
}
