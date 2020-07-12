import 'package:flutter/material.dart';
import 'package:flutter_social_app/api/repository/post_repository.dart';
import 'package:flutter_social_app/injection/locator.dart';
import 'package:flutter_social_app/models/post_response_model.dart';
import 'package:flutter_social_app/models/time_line_model.dart';
import 'package:flutter_social_app/utils/app_constants.dart';
import 'package:hive/hive.dart';

enum GlobalPostState{
  Idle,
  Loading,
  Loaded,
  Error,
  PostListEnd,
}
class GlobalPostViewModel with ChangeNotifier{
  GlobalPostState _globalPostState;
  PostRepository _postRepository;
  TimeLineModel _timeLineModel;
  String _token;
  int _page=1;
  final int _pagination=10;
  bool _onlyFriend=false;
  bool _hasItem=true;





  GlobalPostState get globalPostState => _globalPostState;
  TimeLineModel get timeLineModel => _timeLineModel;


  set globalPostState(GlobalPostState value) {
    _globalPostState = value;
    notifyListeners();
  }

  GlobalPostViewModel(){
    _postRepository=locator.get<PostRepository>();
    _globalPostState=GlobalPostState.Idle;

  }

  void initPostList() async{
    _timeLineModel=null;
    _hasItem=true;
    _token=await Hive.box(AppConstant.SETTINGS_BOX)
        .get(AppConstant.TOKEN,defaultValue: "error");
    try{
      if(_token!='error'){
        _globalPostState=GlobalPostState.Loading;
        _timeLineModel=await _postRepository.getPosts(
            _token,
            _page,
            pagination: _pagination,
          onlyFriend: _onlyFriend
        );
        if(_timeLineModel.status){
          _globalPostState=GlobalPostState.Loaded;
        }else{
          _globalPostState=GlobalPostState.Error;
        }
        notifyListeners();
      }
    }catch(exception){
      print("GlobalPostViewModel->initPostList:"+exception.toString());
      _globalPostState=GlobalPostState.Error;
      notifyListeners();
    }

  }
  void refreshPostList() async{
    _hasItem=true;
    _timeLineModel=null;
    _page=1;
    _token=await Hive.box(AppConstant.SETTINGS_BOX)
        .get(AppConstant.TOKEN,defaultValue: "error");
    try{
      if(_token!='error'){
        _globalPostState=GlobalPostState.Loading;
        _timeLineModel=await _postRepository.getPosts(
            _token,
            _page,
            pagination: _pagination,
            onlyFriend: _onlyFriend
        );
        if(_timeLineModel.status){
          _globalPostState=GlobalPostState.Loaded;
        }else{
          _globalPostState=GlobalPostState.Error;
        }
        notifyListeners();
      }
    }catch(exception){
      print("GlobalPostViewModel->initPostList:"+exception.toString());
      _globalPostState=GlobalPostState.Error;
      notifyListeners();
    }

  }
  void getPostPage() async{
    try{
      if(_token!='error'&&_hasItem){
        _page++;
        _globalPostState=GlobalPostState.Loading;
        var response=await _postRepository.getPosts(
            _token,
            _page,
            pagination: _pagination,
            onlyFriend: _onlyFriend
        );
        if(response!=null&&response.status){
          if(response.posts!=null&&response.posts.length>0){
            _timeLineModel.posts.addAll(response.posts);
            _globalPostState=GlobalPostState.Loaded;
          }else{
            _hasItem=false;
            _globalPostState=GlobalPostState.PostListEnd;

          }
        }else{
          _globalPostState=GlobalPostState.Error;
        }
        notifyListeners();
      }else{
        print('EndOfList:');
      }
    }catch(exception){
      print("GlobalPostViewModel->initPostList:"+exception.toString());
      _globalPostState=GlobalPostState.Error;
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