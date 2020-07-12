import 'package:flutter/material.dart';
import 'package:flutter_social_app/utils/app_constants.dart';
import 'package:flutter_social_app/viewmodels/drawer_navigation_viewmodel.dart';
import 'package:flutter_social_app/viewmodels/friends_posts_viewmodel.dart';
import 'package:flutter_social_app/viewmodels/global_posts_viewmodel.dart';
import 'package:flutter_social_app/viewmodels/login_view_model.dart';
import 'package:flutter_social_app/viewmodels/share_post_viewmodel.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'injection/locator.dart';
import 'pages/home/home_page_screen.dart';
import 'pages/login/login_page_screen.dart';
import 'pages/onboarding/onboarding_page_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter('anket_app');
  await Hive.openBox(AppConstant.SETTINGS_BOX);
  setUpLocator();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<LoginViewModel>(
        create: (context)=>locator.get<LoginViewModel>(),
      ),
      ChangeNotifierProvider<DrawerNavigationViewModel>(
        create: (context)=>locator.get<DrawerNavigationViewModel>(),
      ),
      ChangeNotifierProvider<GlobalPostViewModel>(
        create: (context)=>locator.get<GlobalPostViewModel>(),
      ),
      ChangeNotifierProvider<FriendsPostsViewModel>(
        create: (context)=>locator.get<FriendsPostsViewModel>(),
      ),
      ChangeNotifierProvider<SharePostViewModel>(
        create: (context)=>locator.get<SharePostViewModel>(),
      )
    ],
      child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box(AppConstant.SETTINGS_BOX).listenable(keys:
      [AppConstant.DARK_THEME,AppConstant.FIRST_TIME]
      ),
      builder: (context,box,widget){
        return  MaterialApp(
          debugShowCheckedModeBanner: false,
          darkTheme: ThemeData.dark(),
          title: 'Social App',
          theme: box.get(AppConstant.DARK_THEME,defaultValue: false)?
          ThemeData.dark().copyWith(
            primaryColor: Colors.purple
          ):
          ThemeData.light().copyWith(
            primaryColor: Colors.purple,
          ),
          home: box.get(AppConstant.FIRST_TIME,defaultValue: true)?
          OnBoardingPageScreen():
          AuthPageScreen()
        );
      },
    );
  }
}



class AuthPageScreen extends StatefulWidget {
  @override
  _AuthPageScreenState createState() => _AuthPageScreenState();
}

class _AuthPageScreenState extends State<AuthPageScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LoginViewModel>(context,listen: false).initRememberUser();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context,LoginViewModel viewModel,child){
        print("AuthPageScreen:"+viewModel.loginState.toString());
        if(viewModel.loginState==LoginState.Idle){
          return LoadingPageScreen();
        }else if(viewModel.loginState==LoginState.LogOff){
          return LoginPageScreen();
        }else if(viewModel.loginState==LoginState.Error){
          return LoginPageScreen();
        }else if(viewModel.loginState==LoginState.Loading){
          return LoadingPageScreen();
        }else if(viewModel.loginState==LoginState.SignedIn){
          return HomePageScreen();
        }
        return LoginPageScreen();
      },
    );
  }
}
class LoadingPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}



