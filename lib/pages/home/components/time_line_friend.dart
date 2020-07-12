import 'dart:async';

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
  Completer<void> refreshCompleter;
  ScrollController _scrollController=new ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshCompleter=Completer<void>();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent){
        Provider.of<FriendsPostsViewModel>(context,listen: false).getPostPage();
      }
    });
  }
  var itemCount=0;
  @override
  Widget build(BuildContext context) {
    _postViewModel = Provider.of<FriendsPostsViewModel>(context);
    if (_postViewModel.timeLineModel != null &&
        _postViewModel.timeLineModel.posts != null) {
      if(_postViewModel.friendPostState==FriendPostState.Loaded){
        itemCount = _postViewModel.timeLineModel.posts.length;
      }
    }
    refreshCompleter.complete();
    refreshCompleter=Completer();

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: RefreshIndicator(
        onRefresh: ()async{
           Provider.of<FriendsPostsViewModel>(context,listen: false).refreshPostList();
          return refreshCompleter.future;
        },
        child: ListView.builder(
          key: new PageStorageKey('friendListView'),
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return FriendConsumerPost(index: index,);
          },itemCount: itemCount,),
      ),
    );
  }
}
