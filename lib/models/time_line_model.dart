class TimeLineModel {
  bool status;
  int page;
  int pagination;
  bool onlyFriend;
  int length;
  List<Post> posts;

  TimeLineModel(
      {this.status,
        this.page,
        this.pagination,
        this.onlyFriend,
        this.length,
        this.posts});

  TimeLineModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    page = json['page'];
    pagination = json['pagination'];
    onlyFriend = json['onlyFriend'];
    length = json['length'];
    if (json['posts'] != null) {
      posts = new List<Post>();
      json['posts'].forEach((v) {
        posts.add(new Post.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['page'] = this.page;
    data['pagination'] = this.pagination;
    data['onlyFriend'] = this.onlyFriend;
    data['length'] = this.length;
    if (this.posts != null) {
      data['posts'] = this.posts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Post {
  String sId;
  String userId;
  String name;
  String username;
  String title;
  String description;
  String profileImage;
  String postImage;
  String createdAt;
  var rateAverage;
  int ratedCount;
  int likedCount;
  String id;
  bool isRated;
  var userRateNum;
  bool isLiked;

  Post(
      {this.sId,
        this.userId,
        this.name,
        this.username,
        this.title,
        this.description,
        this.createdAt,
        this.rateAverage,
        this.ratedCount,
        this.likedCount,
        this.id});

  Post.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    name = json['name'];
    username = json['username'];
    profileImage = json['profileImage'];
    postImage=json['postImage'];
    title = json['title'];
    description = json['description'];

    createdAt = json['createdAt'];
    rateAverage = json['rateAverage'];
    ratedCount = json['ratedCount'];
    likedCount = json['likedCount'];
    isRated = json['isRated'];
    userRateNum = json['userRateNum'];
    isLiked=json['isLiked'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['postImage']=this.postImage;
    return data;
  }
}
