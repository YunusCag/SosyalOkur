
import 'dart:convert';

import 'package:flutter_social_app/models/post_response_model.dart';
import 'package:flutter_social_app/models/time_line_model.dart';
import 'package:flutter_social_app/utils/app_constants.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class PostService{

  Future<TimeLineModel> getPosts(String token,{int page=1,pagination=10,bool onlyFriend=false})async{

    try{
      if(token!='error'){
        var postsUrl=AppConstant.BASE_URL;
        postsUrl+="/posts/?page=$page&pagination=$pagination&onlyFriend=$onlyFriend";
        Map<String,String> headers={'Authorization':token};
        var response=await http.get(postsUrl,headers: headers);
        return TimeLineModel.fromJson(jsonDecode(response.body));
      }
    }catch(exception){
      print('PostService->getPosts:'+exception.toString());
    }

    return null;
  }
  Future<PostResponseModel> ratePost(String token,double rate,String postId) async{
    try{
      if(token!='error'){
        var postRateUrl=AppConstant.BASE_URL+'/posts/ratePost/$postId';
        Map<String,String> headers={'Authorization':token,'Content-Type': 'application/json'};
        var body = jsonEncode({'rateNumber': rate});
        var response=await http.post(postRateUrl,headers: headers,body:body );
        if(response.statusCode==200){
          return PostResponseModel.fromJson(jsonDecode(response.body));
        }
      }
    }catch(exception){
      print('PostService->ratePost:'+exception.toString());
    }
    return null;
  }
  Future<PostResponseModel> likePost(String token,String postId) async{
    try{
      if(token!='error'){
        var postRateUrl=AppConstant.BASE_URL+'/posts/likePost/$postId';
        Map<String,String> headers={'Authorization':token};

        var response=await http.post(postRateUrl,headers: headers);
        if(response.statusCode==200){
          return PostResponseModel.fromJson(jsonDecode(response.body));
        }
      }
    }catch(exception){
      print('PostService->ratePost:'+exception.toString());
    }
    return null;
  }
  Future<PostResponseModel> unlikePost(String token,String postId) async{
    try{
      if(token!='error'){
        var postRateUrl=AppConstant.BASE_URL+'/posts/unlikePost/$postId';
        Map<String,String> headers={'Authorization':token};
        var response=await http.post(postRateUrl,headers: headers);
        if(response.statusCode==200){
          return PostResponseModel.fromJson(jsonDecode(response.body));
        }
      }
    }catch(exception){
      print('PostService->ratePost:'+exception.toString());
    }
    return null;
  }


}