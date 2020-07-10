import 'package:flutter/material.dart';
import 'package:flutter_social_app/utils/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
class SettingsPage extends StatefulWidget {

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkTheme;
  @override
  void initState() {
    // TODO: implement initState
    isDarkTheme=Hive.box(AppConstant.SETTINGS_BOX)
        .get(AppConstant.DARK_THEME,defaultValue: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 10,),
                Text(
                  "Karanlık Tema kullan",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      fontSize: 20
                  ),
                ),
                Spacer(),
                Switch(
                  value: isDarkTheme,
                  onChanged: (value){
                    setState(() {
                      isDarkTheme=value;
                      Hive.box(AppConstant.SETTINGS_BOX).put(AppConstant.DARK_THEME, value);
                    });

                  },
                ),
                SizedBox(width: 10,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
