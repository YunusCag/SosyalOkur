import 'time_line_model.dart';

class PostResponseModel {
  bool status;
  Post post;
  String message;

  PostResponseModel({this.status, this.post, this.message});

  PostResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    post = json['post'] != null ? new Post.fromJson(json['post']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.post != null) {
      data['post'] = this.post.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}
