
import 'package:flutter_social_app/api/repository/auth_repository.dart';
import 'package:flutter_social_app/api/repository/post_repository.dart';
import 'package:flutter_social_app/api/services/auth_service.dart';
import 'package:flutter_social_app/api/services/post_service.dart';
import 'package:flutter_social_app/viewmodels/drawer_navigation_viewmodel.dart';
import 'package:flutter_social_app/viewmodels/friends_posts_viewmodel.dart';
import 'package:flutter_social_app/viewmodels/global_posts_viewmodel.dart';
import 'package:flutter_social_app/viewmodels/login_view_model.dart';
import 'package:get_it/get_it.dart';

GetIt locator=GetIt.instance;

void setUpLocator(){
  //api service
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => PostService());

  //repository
  locator.registerLazySingleton(() => AuthRepository());
  locator.registerLazySingleton(() => PostRepository());

  //view model
  locator.registerLazySingleton(() => LoginViewModel());
  locator.registerLazySingleton(() => DrawerNavigationViewModel());
  locator.registerLazySingleton(() => GlobalPostViewModel());
  locator.registerLazySingleton(() => FriendsPostsViewModel());
}