import 'package:flutter/material.dart';

class AuthResponseModel{
  final String token;
  final bool status;
  final String message;
  AuthResponseModel._({
    @required this.token,
    this.status=false,
    @required this.message
});

  factory AuthResponseModel.fromJson(Map<String,dynamic> json){
    return AuthResponseModel._(
      token: json['token'],
      status: json['status'],
      message: json['message']??''
    );
  }
}