import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  CustomButton({super.key, required this.title, this.onTap});
  String title;
  VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xff5642D6),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.aBeeZee(
              textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
