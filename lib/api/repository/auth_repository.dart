import 'dart:io';

import 'package:flutter_social_app/injection/locator.dart';
import 'package:flutter_social_app/models/account.dart';
import 'package:flutter_social_app/models/auth_response_model.dart';
import 'package:flutter_social_app/models/user_register_model.dart';
import 'package:flutter_social_app/utils/app_constants.dart';
import 'package:hive/hive.dart';

import '../services/auth_service.dart';

class AuthRepository{
  AuthService _authService;

  AuthRepository(){
    _authService=locator.get<AuthService>();
  }
  Future<AuthResponseModel> registerUser(UserRegisterModel userModel) async{
    try{
      var authResponseModel=
          await _authService.registerUser(userModel);
      if(authResponseModel!=null){
        return authResponseModel;
      }
    }catch(exception){
      print("AuthRepository->registerUser:"+exception);
    }
    return null;
  }
  Future<AuthResponseModel> loginAccount(String email,String password)async{
    try{
      var authResponseModel=await _authService.loginUser(email, password);
      if(authResponseModel!=null){
        if(authResponseModel.status){
          await Hive.box(AppConstant.SETTINGS_BOX)
              .put(AppConstant.TOKEN,authResponseModel.token);
        }
        return authResponseModel;
      }
    }catch(exception){
      print("AuthRepository->loginAccount:"+exception);
    }
    return null;
  }
  Future<Account> getAccount(String token)async{
    try{
      var account=await _authService.getAccount(token);
      if(account!=null){
        return account;
      }
    }catch(exception){
      print("AuthRepository->getAccount:"+exception.toString());
    }
    return null;
  }
  Future<Account> changePhoto(String token,File image)async{
    try{
      var account=await _authService.changeProfileImage(token, image);
      if(account!=null){
        return account;
      }
    }catch(exception){
      print("AuthRepository->changePhoto:"+exception.toString());
    }
    return null;
  }
  Future<Account> addFriend(String token,String id)async{
    try{
      var account=await _authService.addFriend(token, id);
      if(account!=null){
        return account;
      }
    }catch(exception){
      print("AuthRepository->addFriend:"+exception.toString());
    }
    return null;
  }
  Future<Account> deleteFriend(String token,String id)async{
    try{
      var account=await _authService.deleteFriend(token, id);
      if(account!=null){
        return account;
      }
    }catch(exception){
      print("AuthRepository->deleteFriend:"+exception.toString());
    }
    return null;
  }
}