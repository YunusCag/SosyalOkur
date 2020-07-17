import 'dart:convert';
import 'dart:io';


import 'package:dio/dio.dart';
import 'package:flutter_social_app/models/account.dart';
import 'package:flutter_social_app/models/auth_response_model.dart';
import 'package:flutter_social_app/models/user_register_model.dart';
import 'package:flutter_social_app/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
class AuthService {
  Future<AuthResponseModel> registerUser(UserRegisterModel userModel) async {
    var registerUrl = AppConstant.BASE_URL + "/users/addUser";
    Map<String, String> headers = {'Content-Type': 'application/json'};

    try {
      var response = await http.post(registerUrl,
          headers: headers, body: jsonEncode(userModel.toJson()));
      if (response.statusCode == 200) {
        return  AuthResponseModel.fromJson(jsonDecode(response.body));
      } else if(response.statusCode==400){
        return  AuthResponseModel.fromJson(jsonDecode(response.body));
      }
    } catch (exception) {
      print("AuthService->registerUser:"+exception);
    }
    return null;
  }

  Future<AuthResponseModel> loginUser(String email, String password) async {
    var loginUrl = AppConstant.BASE_URL + "/users/login";
    Map<String, String> headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({'email': email, 'password': password});
    try {
      var response = await http.post(loginUrl, headers: headers, body: body);

      if (response != null && response.statusCode == 200) {

        return AuthResponseModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {

        return AuthResponseModel.fromJson(
            jsonDecode(response.body)
        );
      }
    } catch (exception) {
      print("AuthService->loginUser:"+exception);
    }
    return null;
  }
  Future<Account> getAccount(String token) async{
    var currentUrl=AppConstant.BASE_URL+"/users/current";
    Map<String,String> headers={'Authorization':token};
    try{
      var response=await http.get(currentUrl,headers: headers);
      if(response.body!=null){
        return Account.fromJson(jsonDecode(response.body));
      }else{
        return null;
      }
    }catch(exception){
      print("AuthService->getAccount:"+exception.toString());
    }
    return null;
  }
  Future<Account> changeProfileImage(String token,File image)async{
    try{
      if(token!='error'&&image!=null){
        var profileImageUrl=AppConstant.BASE_URL+'/users/setProfileImage';
        Map<String,String> headers={
          'Authorization':token,
          'Content-Type': 'application/x-www-form-urlencoded'
        };
        String fileName = image.path.split('/').last;
        final ext = extension(image.path).replaceAll('.', '');
        FormData body=new FormData.fromMap({
          'profileImage':await MultipartFile.fromFile(
              image.path,
              filename: fileName+'.'+ext,
              contentType: MediaType('image',ext)
          )
        });
        var response=await Dio().post(profileImageUrl,options: Options(
            headers: headers
        ),data:body );
        if(response.statusCode==200){
          Map<String,dynamic> map=Map<String,dynamic>.from(response.data);
          return Account.fromJson(map);
        }
      }
    }catch(exception){
      print("AuthService->changeProfileImage:"+exception.toString());
    }
    return null;
  }
  Future<Account> addFriend(String token,String id)async{
    try{
      if(token!='error'&&id!=null){
        var friendUrl=AppConstant.BASE_URL+"/users/addFriend/$id";
        Map<String,String> headers={'Authorization':token};
        var response=await http.post(friendUrl,headers: headers);
        if(response.statusCode==200){
          return Account.fromJson(jsonDecode(response.body));
        }
      }
    }catch(exception){
      print("AuthService->addFriend:"+exception.toString());
    }
    return null;
  }
  Future<Account> deleteFriend(String token,String id)async{
    try{
      if(token!='error'&&id!=null){
        var friendUrl=AppConstant.BASE_URL+"/users/deleteFriend/$id";
        Map<String,String> headers={'Authorization':token};
        var response=await http.post(friendUrl,headers: headers);
        if(response.statusCode==200){
          return Account.fromJson(jsonDecode(response.body));
        }
      }
    }catch(exception){
      print("AuthService->deleteFriend:"+exception.toString());
    }
    return null;
  }

}
