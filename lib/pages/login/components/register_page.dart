import 'package:flutter/material.dart';
import 'package:flutter_social_app/models/user_register_model.dart';
import 'file:///D:/Projeler/FlutterProjects/flutter_anket/lib/api/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
class RegisterPage extends StatefulWidget {
  final PageController pageController;

  RegisterPage({
    this.pageController
  });

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey=GlobalKey<FormState>();

  String _name;
  String _username;
  String _email;
  String _password;
  AuthService _authService;
  String _errorMessage='';

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
    return Container(
      width: width,
      height: height,

      color: Colors.orange.withOpacity(.8),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 16,bottom: 16),
              alignment: Alignment.center,
              child: Text(
                "Kayıt Ol",
                style: GoogleFonts.lobster(fontSize: 32),
              ),
            ),
            SizedBox(
              height: 64,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.symmetric(vertical: 4,horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(8),
                  right: Radius.circular(8),
                ),
                color: Color(0xFFF5F5F5)
              ),
              child: TextFormField(
                initialValue: _name,
                validator: (value){
                  if(value.length<=3){
                    return 'name must be long than 3 characters';
                  }
                  return null;
                },
                onSaved: (value){
                  _name=value;
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.account_box,
                    size: 32,
                  ),
                  hintText: 'name',
                ),
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
                  color: Color(0xFFF5F5F5)
              ),
              child: TextFormField(
                initialValue: _username,
                validator: (value){
                  if(value.length<=3){
                    return 'username must be long than 3 characters';
                  }
                  return null;
                },
                onSaved: (value){
                  _username=value;
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.account_circle,
                      size: 32,
                    ),
                    hintText: 'username',
                    border: InputBorder.none
                ),
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
                  color: Color(0xFFF5F5F5)
              ),
              child: TextFormField(
                initialValue: _email,
                keyboardType: TextInputType.emailAddress,
                validator: (value){
                  var isvalid=RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value);
                  if(!isvalid){
                    return 'please enter valid email';
                  }
                  return null;
                },
                onSaved: (value){
                  _email=value;
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      size: 32,
                    ),
                    hintText: 'email',
                    border: InputBorder.none
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(8),
                    right: Radius.circular(8),
                  ),
                  color: Color(0xFFF5F5F5)
              ),
              child: TextFormField(
                obscureText: true,
                initialValue: _password,
                validator: (value){
                  if(value.length<=5){
                    return 'password must be long than 5 characters';
                  }
                  return null;
                },
                onSaved: (value){
                  _password=value;
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      size: 32,
                    ),
                    hintText: 'password',
                    border: InputBorder.none
                ),
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
                color: Colors.purple,
                onPressed: _register,
                child: Text(
                  "Kayıt Ol",
                  style: GoogleFonts.lobster(fontSize: 24),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    color: Colors.red,
                    fontSize: 20
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _register() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      var userModel=UserRegisterModel(
        name: _name,
        username: _username,
        email: _email,
        password: _password
      );
      var authResponseModel=await _authService.registerUser(userModel);
      if(authResponseModel!=null){
        if(authResponseModel.status){
          _showLoginPage();
        }else{
          setState(() {
            _errorMessage=authResponseModel.message;
          });
        }

      }
    }
  }

  void _showLoginPage() {
    widget.pageController.previousPage(duration: Duration(milliseconds: 800), curve: Curves.easeIn);
  }
}
