import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/viewmodels/login_view_model.dart';
import 'file:///D:/Projeler/FlutterProjects/flutter_anket/lib/api/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
class LoginPage extends StatefulWidget {

  final PageController pageController;

  LoginPage({
    this.pageController
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;

  AuthService _authService;
  String _errorMessage='';
  LoginViewModel _viewModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authService=new AuthService();
  }
  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;

    _viewModel=Provider.of<LoginViewModel>(context);
    return Container(
      width: width,
      height: height,
      child: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: height*0.1,
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/icon.jpg'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.symmetric(vertical: 4,horizontal: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(8),
                        right: Radius.circular(8),
                      ),
                      color: Color(0xFFE0E0E0)
                  ),
                  child: TextFormField(
                    initialValue: _email,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      _email = value;
                    },
                    decoration: const InputDecoration(
                      focusColor: Colors.white,
                      hintText: 'email',
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.email,
                        size: 32,
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.symmetric(vertical: 4,horizontal: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(8),
                        right: Radius.circular(8),
                      ),
                      color: Color(0xFFE0E0E0)
                  ),
                  child: TextFormField(
                    autofocus: false,
                    initialValue: _password,
                    onSaved: (value) {
                      _password = value;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: "password",
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          size: 32,
                        )),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    ),
                    elevation: 5,
                    minWidth: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 32,vertical: 5),
                    color: Colors.green,
                    onPressed: _login,
                    child: Text(
                      "Giriş Yap",
                      style: GoogleFonts.lobster(fontSize: 24),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  child: TyperAnimatedTextKit(
                    text: [
                      "Giriş yapmak için hesabınızın olması gerekiyor?",
                      "Hesabınız mı yok?",
                      "Kayıt ol",
                    ],
                    textAlign: TextAlign.center,
                    textStyle: GoogleFonts.lobster(
                        fontSize: 20,
                      color: Colors.black54
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    _errorMessage,
                    style: GoogleFonts.montserrat(
                      color: Colors.red,
                      fontSize: 20
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: InkWell(
              onTap: _showRegisterPage,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)
                  )
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.all(16),
                child:Text(
                  "Kayıt ol",
                  style: GoogleFonts.lobster(fontSize: 24),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  void _login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      var authResponseModel=await _viewModel.login(_email, _password);
      if(!authResponseModel.status){
        setState(() {
          _errorMessage=authResponseModel.message;
        });
      }
    }
  }



  void _showRegisterPage() {
    widget.pageController.nextPage(duration: Duration(milliseconds: 800), curve: Curves.easeIn);
  }
}
