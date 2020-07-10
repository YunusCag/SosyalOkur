class Account {
  bool status;
  User user;
  String message;

  Account({this.status, this.user,this.message});

  Account.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  String sId;
  String name;
  String username;
  String profileImage;
  String email;
  List<Friends> friends;
  List<CreatedPost> createdPost;
  List<RatedPost> ratedPost;

  User(
      {this.sId,
        this.name,
        this.username,
        this.email,
        this.friends,
        this.createdPost,
        this.ratedPost});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    username = json['username'];
    profileImage = json['profileImage'];
    email = json['email'];
    if (json['friends'] != null) {
      friends = new List<Friends>();
      json['friends'].forEach((v) {
        friends.add(new Friends.fromJson(v));
      });
    }
    if (json['createdPost'] != null) {
      createdPost = new List<CreatedPost>();
      json['createdPost'].forEach((v) {
        createdPost.add(new CreatedPost.fromJson(v));
      });
    }
    if (json['ratedPost'] != null) {
      ratedPost = new List<RatedPost>();
      json['ratedPost'].forEach((v) {
        ratedPost.add(new RatedPost.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    if (this.friends != null) {
      data['friends'] = this.friends.map((v) => v.toJson()).toList();
    }
    if (this.createdPost != null) {
      data['createdPost'] = this.createdPost.map((v) => v.toJson()).toList();
    }
    if (this.ratedPost != null) {
      data['ratedPost'] = this.ratedPost.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Friends {
  String sId;

  Friends({this.sId});

  Friends.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    return data;
  }
}

class RatedPost {
  String sId;
  String postId;
  var rateNumber;

  RatedPost({this.sId, this.postId, this.rateNumber});

  RatedPost.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    postId = json['postId'];
    rateNumber = json['rateNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['postId'] = this.postId;
    data['rateNumber'] = this.rateNumber;
    return data;
  }
}
class CreatedPost {
  String sId;

  CreatedPost({this.sId});

  CreatedPost.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    return data;
  }
}