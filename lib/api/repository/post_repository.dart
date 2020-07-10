import 'package:flutter_social_app/api/services/post_service.dart';
import 'package:flutter_social_app/injection/locator.dart';
import 'package:flutter_social_app/models/post_response_model.dart';
import 'package:flutter_social_app/models/time_line_model.dart';

class PostRepository{
  PostService _postService;

  PostRepository(){
    _postService=locator.get<PostService>();
  }

  Future<TimeLineModel> getPosts(String token,int page,{int pagination=10,bool onlyFriend=false})async{
    try{
      var timeLineModel=await _postService.getPosts(
        token,
        page: page,
        pagination: pagination,
        onlyFriend: onlyFriend
      );
      if(timeLineModel!=null){
        return timeLineModel;
      }
    }catch(exception){
      print("PostRepository->getPosts:"+exception);
    }
    return null;
  }
  Future<PostResponseModel> ratePost(String token,double rate,String postId) async{
    try{
      var postResponseModel=await _postService.ratePost(token, rate, postId);
      if(postResponseModel!=null){
        return postResponseModel;
      }
    }catch(exception){
      print("PostRepository->ratePost:"+exception);
    }
    return null;
  }
  Future<PostResponseModel> likePost(String token,String postId) async{
    try{
      var postResponseModel=await _postService.likePost(token, postId);
      if(postResponseModel!=null){
        return postResponseModel;
      }
    }catch(exception){
      print("PostRepository->ratePost:"+exception);
    }
    return null;
  }
  Future<PostResponseModel> unlikePost(String token,String postId) async{
    try{
      var postResponseModel=await _postService.unlikePost(token, postId);
      if(postResponseModel!=null){
        return postResponseModel;
      }
    }catch(exception){
      print("PostRepository->ratePost:"+exception);
    }
    return null;
  }
}