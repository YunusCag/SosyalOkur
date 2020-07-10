
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'components/login_page.dart';
import 'components/register_page.dart';

class LoginPageScreen extends StatefulWidget {
  @override
  _LoginPageScreenState createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginPageScreen> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;

  final PageController _pageController=new PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          //physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: <Widget>[
            LoginPage(pageController: _pageController,),
            RegisterPage(
              pageController: _pageController,
            )
          ],
        ),
      ),
    );
  }

}
