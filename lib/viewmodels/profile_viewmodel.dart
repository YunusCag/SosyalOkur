import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_social_app/api/repository/auth_repository.dart';
import 'package:flutter_social_app/injection/locator.dart';
import 'package:flutter_social_app/models/account.dart';
import 'package:flutter_social_app/utils/app_constants.dart';
import 'package:hive/hive.dart';

enum ProfileState{
  Idle,
  Loading,
  Loaded,
  Error
}
class ProfileViewModel with ChangeNotifier{
  String _token;
  ProfileState _profileState;
  Account _accountModel;
  AuthRepository _repository;

  ProfileViewModel(){
    profileState=ProfileState.Idle;
    _repository=locator.get<AuthRepository>();
  }

  void initRememberUser() async {
    _token= await Hive.box(AppConstant.SETTINGS_BOX)
        .get(AppConstant.TOKEN,defaultValue: "error");
    if(token=="error"){
      profileState=ProfileState.Error;
      notifyListeners();
    }else{
      await getAccount();
    }

  }

  String get token => _token;

  set token(String value) {
    _token = value;
    notifyListeners();
  }


  ProfileState get profileState => _profileState;

  set profileState(ProfileState value) {
    _profileState = value;
    notifyListeners();
  }


  Account get accountModel => _accountModel;

  set accountModel(Account value) {
    _accountModel = value;
    notifyListeners();
  }

  Future<Account> getAccount() async{
    try{
      print('LoginViewModel:$token');
      profileState=ProfileState.Loading;
      _accountModel=await _repository.getAccount(token);
      if(accountModel.status){
        profileState=ProfileState.Loaded;
      }else{
        profileState=ProfileState.Error;
      }
      notifyListeners();
      return _accountModel;

    }catch(exception){
      profileState=ProfileState.Error;
      notifyListeners();
    }
    return null;
  }
  Future<void> changeProfileImage(File image)async{
    try{
      profileState=ProfileState.Loading;
      var model=await _repository.changePhoto(token, image);
      if(model!=null){
        _accountModel=model;
        profileState=ProfileState.Loaded;
        notifyListeners();
      }
    }catch(exception){
      profileState=ProfileState.Error;
      notifyListeners();
    }
  }
  Future<void> addFriends(String id)async{
    try{
      profileState=ProfileState.Loading;
      var model=await _repository.addFriend(token, id);
      if(model!=null){
        _accountModel=model;
        profileState=ProfileState.Loaded;
        notifyListeners();
      }
    }catch(exception){
      profileState=ProfileState.Error;
      notifyListeners();
    }
  }
  Future<void> deleteFriends(String id)async{
    try{
      profileState=ProfileState.Loading;
      var model=await _repository.deleteFriend(token, id);
      if(model!=null){
        _accountModel=model;
        profileState=ProfileState.Loaded;
        notifyListeners();
      }
    }catch(exception){
      profileState=ProfileState.Error;
      notifyListeners();
    }
  }
}