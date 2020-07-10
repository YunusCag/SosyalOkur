import 'package:flutter/cupertino.dart';

class UserRegisterModel{
  String name;
  String username;
  String email;
  String password;

  UserRegisterModel({
    @required this.name,
    @required this.username,
    @required this.email,
    @required this.password});

  Map<String,dynamic> toJson()=>{
    'name':name,
    'username':username,
    'email':email,
    'password':password
  };
}