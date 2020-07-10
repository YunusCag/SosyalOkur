import 'package:flutter/material.dart';
import 'package:flutter_social_app/data/onboard_page_data.dart';
import 'package:flutter_social_app/utils/app_constants.dart';
import 'package:flutter_social_app/viewmodels/color_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'components/onboarding_page.dart';
import 'components/page_view_indicator.dart';

class OnBoarding extends StatelessWidget {

  final PageController pageController=PageController();
  @override
  Widget build(BuildContext context) {
    ColorProvider colorProvider=Provider.of<ColorProvider>(context);
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        PageView.builder(
          controller: pageController,
            itemBuilder: (context,index){
              return OnBoardingPage(
                pageModel: onboardData[index],
                pageController: pageController,
              );
            },
          itemCount: onboardData.length,
        ),
        Container(
          width: double.infinity,
          height: height*0.1,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Text(
                    "eğlenmeye başla",
                    style: GoogleFonts.notoSans(
                      fontSize: 18
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 32),
                  child: InkWell(
                    onTap: (){
                      Hive.box(AppConstant.SETTINGS_BOX)
                          .put(AppConstant.FIRST_TIME, false);
                    },
                    child: Text(
                      "Skip",
                      style: GoogleFonts.notoSans(
                          fontSize: 18,
                        color: colorProvider.color
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20,left: 30),
            child: PageViewIndicator(
                controller:pageController,
                itemCount:onboardData.length,
                color:colorProvider.color
            ),
          ),
        )
      ],
    );
  }
}
