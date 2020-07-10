import 'package:flutter/material.dart';
import 'package:flutter_social_app/api/repository/post_repository.dart';
import 'package:flutter_social_app/injection/locator.dart';
import 'package:flutter_social_app/models/post_response_model.dart';
import 'package:flutter_social_app/models/time_line_model.dart';
import 'package:flutter_social_app/utils/app_constants.dart';
import 'package:hive/hive.dart';

enum FriendPostState{
  Idle,
  Loading,
  Loaded,
  Error,
  PostListEnd,
}
class FriendsPostsViewModel with ChangeNotifier{
  FriendPostState _friendPostState;
  PostRepository _postRepository;
  TimeLineModel _timeLineModel;
  String _token;
  int _page=1;
  final int _pagination=10;
  bool _onlyFriend=true;

  FriendPostState get friendPostState => _friendPostState;
  TimeLineModel get timeLineModel => _timeLineModel;


  set friendPostState(FriendPostState value) {
    _friendPostState = value;
    notifyListeners();
  }

  FriendsPostsViewModel(){
    _postRepository=locator.get<PostRepository>();
    _friendPostState=FriendPostState.Idle;

  }

  void initPostList() async{
    _token=await Hive.box(AppConstant.SETTINGS_BOX)
        .get(AppConstant.TOKEN,defaultValue: "error");
    try{
      if(_token!='error'){
        _friendPostState=FriendPostState.Loading;
        _timeLineModel=await _postRepository.getPosts(
            _token,
            _page,
            pagination: _pagination,
            onlyFriend: _onlyFriend
        );
        if(_timeLineModel.status){
          _friendPostState=FriendPostState.Loaded;
        }else{
          _friendPostState=FriendPostState.Error;
        }
        notifyListeners();
      }
    }catch(exception){
      print("GlobalPostViewModel->initPostList:"+exception.toString());
      _friendPostState=FriendPostState.Error;
      notifyListeners();
    }

  }
  void refreshPostList() async{
    _timeLineModel=null;
    _token=await Hive.box(AppConstant.SETTINGS_BOX)
        .get(AppConstant.TOKEN,defaultValue: "error");
    try{
      if(_token!='error'){
        _friendPostState=FriendPostState.Loading;
        _timeLineModel=await _postRepository.getPosts(
            _token,
            _page,
            pagination: _pagination,
            onlyFriend: _onlyFriend
        );
        if(_timeLineModel.status){
          _friendPostState=FriendPostState.Loaded;
        }else{
          _friendPostState=FriendPostState.Error;
        }
        notifyListeners();
      }
    }catch(exception){
      print("GlobalPostViewModel->initPostList:"+exception.toString());
      _friendPostState=FriendPostState.Error;
      notifyListeners();
    }

  }
  void getPostPage() async{
    _timeLineModel=null;
    _token=await Hive.box(AppConstant.SETTINGS_BOX)
        .get(AppConstant.TOKEN,defaultValue: "error");
    _page++;
    try{
      if(_token!='error'){
        _friendPostState=FriendPostState.Loading;
        var response=await _postRepository.getPosts(
            _token,
            _page,
            pagination: _pagination,
            onlyFriend: _onlyFriend
        );
        if(response!=null&&response.status){
          if(response.posts!=null&&response.posts.length>0){
            _timeLineModel.posts.addAll(response.posts);
            _friendPostState=FriendPostState.Loaded;
          }else{
            _friendPostState=FriendPostState.PostListEnd;
          }
        }else{
          _friendPostState=FriendPostState.Error;
        }
        notifyListeners();
      }
    }catch(exception){
      print("FriendsPostsViewModel->initPostList:"+exception);
      _friendPostState=FriendPostState.Error;
      notifyListeners();
    }

  }

  Future<PostResponseModel> ratePos(double rate,String postId){
    try{
      var postModel=_postRepository.ratePost(_token, rate, postId);
      if(postModel!=null){
        return postModel;
      }
    }catch(exception){
      print("GlobalPostViewModel->getPostPage:"+exception);
    }
    return null;
  }
  Future<PostResponseModel> likePost(String postId){
    try{
      var postModel=_postRepository.likePost(_token, postId);
      if(postModel!=null){
        return postModel;
      }
    }catch(exception){
      print("GlobalPostViewModel->getPostPage:"+exception);
    }
    return null;
  }
  Future<PostResponseModel> unlikePost(String postId){
    try{
      var postModel=_postRepository.unlikePost(_token, postId);
      if(postModel!=null){
        return postModel;
      }
    }catch(exception){
      print("GlobalPostViewModel->getPostPage:"+exception);
    }
    return null;
  }

}