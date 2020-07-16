import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/models/account.dart';
import 'package:flutter_social_app/utils/app_constants.dart';
import 'package:flutter_social_app/viewmodels/friends_posts_viewmodel.dart';
import 'package:flutter_social_app/viewmodels/global_posts_viewmodel.dart';
import 'package:flutter_social_app/viewmodels/login_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Account accountModel;
  LoginViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    _viewModel=Provider.of<LoginViewModel>(context);
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    accountModel=_viewModel.accountModel;
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
                      FlatButton(
                        onPressed: ()async{
                          await _pickImageFromGallery(ImgSource.Both);
                        },
                        color: Colors.white,
                        child: Text(
                          'Change Profile image',
                          style: GoogleFonts.montserrat(
                            fontSize: 18
                          ),
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
              ),
            ],
          ),
        ),
        Positioned(
          top: height*.35,
          width: width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    elevation: 8,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  SizedBox(height: 20,),
                  Text(
                    'Friends:',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.montserrat(
                      fontSize: 20
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    height: height*0.35,
                    child: ListView.builder(
                        itemBuilder: (context,index){
                          return FriendListTile(
                            userFriend: accountModel.friends[index],
                          );
                        },itemCount: accountModel.friends.length,),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  void _pickImageFromGallery(ImgSource imageSource)async{
    var image=await ImagePickerGC.pickImage(
        context: context,
        source: imageSource,
        cameraIcon: Icon(
          LineAwesomeIcons.file_image_o,
          color: Colors.purple,
        )
    );
    if(image!=null){
      await _viewModel.changeProfileImage(image);
      Provider.of<GlobalPostViewModel>(context,listen: false).refreshPostList();
      Provider.of<FriendsPostsViewModel>(context,listen: false).refreshPostList();
      setState(() {

      });
    }
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
    return Container(
      child: Column(
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
      ),
    );
  }
}
class FriendListTile extends StatelessWidget {

  final UserFriend userFriend;

  FriendListTile({
    @required this.userFriend
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 5,
          ),
          ClipOval(
            child: Image.network(
              AppConstant.IMAGE_URL + userFriend.profileImage ?? '',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userFriend.name,
                style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "@" + userFriend.username,
                style: GoogleFonts.montserrat(
                    fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ],
          ),
          Spacer(),
          FlatButton(
            onPressed: (){

            },
            child: Text(
              'remove',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red
              ),
            ),
          )
        ],
      ),
    );
  }
}
