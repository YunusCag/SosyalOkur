import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/models/account.dart';
import 'package:flutter_social_app/utils/app_constants.dart';
import 'package:flutter_social_app/viewmodels/login_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Account accountModel;

  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    accountModel=Provider.of<LoginViewModel>(context).accountModel;
    return Stack(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Container(
                height: height*0.4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xFFDA22FF),
                      Color(0xFF9733EE),
                    ],
                  )
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          AppConstant.IMAGE_URL+accountModel.user.profileImage
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        accountModel.user.name,
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "@"+accountModel.user.username,
                        style: GoogleFonts.montserrat(
                            fontSize: 18,
                            color: Colors.white70,
                            fontWeight: FontWeight.w300
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: height*.32,
          width: width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Card(
              elevation: 8,
              child: Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      width: 5,
                    ),
                    ProfileInfoText(
                        title: 'Friends',
                      number: accountModel.user.friends.length,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ProfileInfoText(
                      title: 'Created Post',
                      number: accountModel.user.createdPost.length,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ProfileInfoText(
                      title: 'Rated Post',
                      number: accountModel.user.ratedPost.length,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileInfoText extends StatelessWidget {
  final String title;
  int number=0;

  ProfileInfoText({
    Key key,
    @required this.title,
  this.number,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
            title,
          style: GoogleFonts.montserrat(
            fontSize: 20,
            color: Colors.black38,
            fontWeight: FontWeight.w400
          ),
        ),
        SizedBox(height: 5,),
        Text(
          '$number',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            color: Colors.black54,
            fontWeight: FontWeight.w600
          ),
        ),
      ],
    );
  }
}
