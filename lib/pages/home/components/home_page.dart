import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/pages/home/components/time_line_friend.dart';
import 'package:flutter_social_app/pages/home/components/time_line_global.dart';
import 'package:flutter_social_app/pages/onboarding/components/page_view_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TabBar(
            indicatorColor: Colors.purple,
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  LineAwesomeIcons.globe,
                  color: Colors.black,
                  size: 32,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.supervisor_account,
                  color: Colors.black,
                  size: 32,
                ),
              )
            ],
          ),
          Expanded(
            child: TabBarView(
              children: <Widget>[
                TimeLineGlobal(),
                TimeLineFriend(),
              ],
            ),
          )
        ],
      )),
    );
  }
}
