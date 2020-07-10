import 'package:flutter/material.dart';
import 'package:flutter_social_app/pages/home/listitem/post_list_item.dart';
import 'package:flutter_social_app/viewmodels/friends_posts_viewmodel.dart';
import 'package:flutter_social_app/viewmodels/global_posts_viewmodel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TimeLineFriend extends StatefulWidget {
  @override
  _TimeLineFriendState createState() => _TimeLineFriendState();
}

class _TimeLineFriendState extends State<TimeLineFriend> {
  FriendsPostsViewModel _postViewModel;
  @override
  Widget build(BuildContext context) {
    _postViewModel = Provider.of<FriendsPostsViewModel>(context);
    var itemCount = 1;
    if (_postViewModel.timeLineModel != null &&
        _postViewModel.timeLineModel.posts != null) {
      itemCount = _postViewModel.timeLineModel.posts.length;
    }
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: ListView.builder(
          key: new PageStorageKey('myFriendList'),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Consumer(
              builder: (context, FriendsPostsViewModel postViewModel, child) {
                print("FriendPostState:" +
                    postViewModel.friendPostState.toString());
                if (postViewModel.friendPostState == FriendPostState.Idle) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    width: double.infinity,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (postViewModel.friendPostState ==
                    FriendPostState.Loading) {
                  return Container(
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      child: CircularProgressIndicator());
                } else if (postViewModel.friendPostState ==
                    FriendPostState.Loaded) {
                  if (_postViewModel.timeLineModel.posts != null) {
                    return PostListItem(
                      post: _postViewModel.timeLineModel.posts[index],
                    );
                  }
                } else if (postViewModel.friendPostState ==
                    FriendPostState.Error) {
                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Bir şeyler ters gitti",
                          style: GoogleFonts.montserrat(
                              fontSize: 24, color: Colors.red),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CircularProgressIndicator(),
                      ],
                    ),
                  );
                } else if (postViewModel.friendPostState ==
                    FriendPostState.PostListEnd) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Gönderilerin sonuna ulaştınız.",
                          style: GoogleFonts.montserrat(
                              fontSize: 24, color: Colors.red),
                        ),
                      ],
                    ),
                  );
                }

                return CircularProgressIndicator();
              },
            );
          }),
    );
  }
}
