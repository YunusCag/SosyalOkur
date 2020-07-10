import 'package:flutter/material.dart';
enum DrawerNavigationState{
  HomePage,
  ProfilePage,
  SettingsPage,
  About,
  RateUs
}
class DrawerNavigationViewModel with ChangeNotifier{
  DrawerNavigationState _navigationState;
  String _appBarTitle;


  String get appBarTitle => _appBarTitle;

  set appBarTitle(String value) {
    _appBarTitle = value;
    notifyListeners();
  }

  DrawerNavigationState get navigationState => _navigationState;

  set navigationState(DrawerNavigationState value) {
    _navigationState = value;
    notifyListeners();
  }
  DrawerNavigationViewModel(){
    _navigationState=DrawerNavigationState.HomePage;
    _appBarTitle='Home Page';
    notifyListeners();
  }

  void changePage(DrawerNavigationState page){
    _navigationState=page;
    if(_navigationState==DrawerNavigationState.HomePage){
      _appBarTitle="Home Page";
    }else if(_navigationState==DrawerNavigationState.ProfilePage){
      _appBarTitle="Profile Page";
    }else if(_navigationState==DrawerNavigationState.SettingsPage){
      _appBarTitle="Settings Page";
    }else if(_navigationState==DrawerNavigationState.About){
      _appBarTitle="About Page";
    }else if(_navigationState==DrawerNavigationState.RateUs){
      _appBarTitle="RateUs Page";
    }
    notifyListeners();
  }
}