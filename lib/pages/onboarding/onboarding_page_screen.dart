import 'package:flutter/material.dart';
import 'package:flutter_social_app/viewmodels/color_provider.dart';
import 'package:provider/provider.dart';

import 'onboarding.dart';
class OnBoardingPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ColorProvider>(
      create: (context)=>ColorProvider(),
      child: Scaffold(
        body: OnBoarding(),
      ),
    );
  }
}
