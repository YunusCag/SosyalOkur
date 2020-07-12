
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_social_app/api/repository/post_repository.dart';
import 'package:flutter_social_app/injection/locator.dart';
import 'package:flutter_social_app/models/post_response_model.dart';
import 'package:flutter_social_app/utils/app_constants.dart';
import 'package:hive/hive.dart';
enum SharePostState{
  Idle,
  Loading,
  Loaded,
  Error
}
class SharePostViewModel with ChangeNotifier{
  SharePostState _sharePostState;
  PostRepository _postRepository;
  PostResponseModel _postResponseModel;
  String _token;


  SharePostState get sharePostState => _sharePostState;
  PostResponseModel get postResponseModel => _postResponseModel;


  set sharePostState(SharePostState value) {
    _sharePostState = value;
    notifyListeners();
  }

  SharePostViewModel(){
    _sharePostState=SharePostState.Idle;
    _postRepository=locator.get<PostRepository>();
    _token=Hive.box(AppConstant.SETTINGS_BOX).get(AppConstant.TOKEN,defaultValue: 'error');
  }

  void sharePost(String title,String description,File image)async{
    try{
      _sharePostState=SharePostState.Loading;
      _postResponseModel=await _postRepository.sharePost(_token, title, description, image);
      if(_postResponseModel!=null&&_postResponseModel.status){
        _sharePostState=SharePostState.Loaded;
      }else{
        _sharePostState=SharePostState.Error;
      }
      notifyListeners();
    }catch(exception){
      print('SharePostViewModel->sharePost:'+exception.toString());
    }
  }
  void refresh(){
    _sharePostState=SharePostState.Idle;
    _postResponseModel=null;
    notifyListeners();
  }



}