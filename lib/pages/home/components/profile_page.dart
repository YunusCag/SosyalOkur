import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Text(
          "ProfilePage",
          textAlign: TextAlign.center,
          style: GoogleFonts.lobster(
              fontSize: 32
          ),
        ),
      ),
    );
  }
}
