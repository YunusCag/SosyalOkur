import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_social_app/api/repository/auth_repository.dart';
import 'package:flutter_social_app/injection/locator.dart';
import 'package:flutter_social_app/models/account.dart';
import 'package:flutter_social_app/models/auth_response_model.dart';
import 'package:flutter_social_app/utils/app_constants.dart';
import 'package:hive/hive.dart';

enum LoginState{
  Idle,
  LogOff,
  Loading,
  SignedIn,
  Error
}

class LoginViewModel with ChangeNotifier{
  LoginState _loginState;
  AuthResponseModel _responseModel;
  Account _accountModel;
  AuthRepository _repository;
  String _token;


  String get token => _token;

  Account get accountModel => _accountModel;

  LoginState get loginState => _loginState;

  AuthResponseModel get responseModel => _responseModel;

  set loginState(LoginState value) {
    _loginState = value;
    _repository=locator.get<AuthRepository>();
    notifyListeners();
  }

  LoginViewModel(){
    _loginState=LoginState.Idle;
    _repository=locator.get<AuthRepository>();
  }

  void initRememberUser() async {
    _token=await Hive.box(AppConstant.SETTINGS_BOX)
        .get(AppConstant.TOKEN,defaultValue: "error");
    if(token=="error"){
      _loginState=LoginState.LogOff;
      notifyListeners();
    }else{
      //TODO handle first login steps
      await getAccount();

    }

  }
  Future<AuthResponseModel> login(String email,String password)async{
    try{
      _loginState=LoginState.Loading;
      _responseModel=await _repository.loginAccount(email, password);
      if(_responseModel.status){
        _token=_responseModel.token;
        _accountModel=await getAccount();
        _loginState=LoginState.SignedIn;
      }else{
        _loginState=LoginState.Error;
      }
      notifyListeners();
      return _responseModel;
    }catch(exception){
      _loginState=LoginState.Error;
      notifyListeners();
    }
    return null;
  }
  Future<Account> getAccount() async{
    try{
      print('LoginViewModel:$token');
      _loginState=LoginState.Loading;
      _accountModel=await _repository.getAccount(token);
      if(accountModel.status){
        _loginState=LoginState.SignedIn;
      }else{
        _loginState=LoginState.Error;
      }
      notifyListeners();
      return _accountModel;

    }catch(exception){
      _loginState=LoginState.Error;
      notifyListeners();
    }
    return null;
  }
  Future<void> changeProfileImage(File image)async{
    try{
      var model=await _repository.changePhoto(token, image);
      if(model!=null){
        _accountModel=model;
      }
    }catch(exception){

    }
  }
}