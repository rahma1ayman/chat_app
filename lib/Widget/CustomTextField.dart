import 'package:flutter/material.dart';

import '../helper/constants.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {super.key,
      required this.title,
      required this.icon,
      this.onChanged,
      this.obsecure = false,
      this.suffixIcon,
      this.onTap,
      this.controller});
  String title;
  IconData icon;
  IconData? suffixIcon;
  Function(String)? onChanged;
  Function(String)? onSubmitted;
  VoidCallback? onTap;
  bool obsecure;
  TextEditingController? controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obsecure,
      validator: (value) {
        if (value!.isEmpty) {
          return 'required';
        }
        return null;
      },
      onChanged: onChanged,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: title,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(primaryColor),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(primaryColor),
          ),
        ),
        icon: Icon(icon),
        iconColor: Color(primaryColor),
        suffixIcon: Icon(suffixIcon),
      ),
    );
  }
}
