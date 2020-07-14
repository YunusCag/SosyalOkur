import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/pages/home/listitem/post_list_item.dart';
import 'package:flutter_social_app/viewmodels/global_posts_viewmodel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:provider/provider.dart';

class TimeLineGlobal extends StatefulWidget {
  @override
  _TimeLineGlobalState createState() => _TimeLineGlobalState();
}

class _TimeLineGlobalState extends State<TimeLineGlobal> {
  Completer<void> refreshCompleter;
  ScrollController _scrollController=new ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshCompleter=Completer<void>();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent){
        Provider.of<GlobalPostViewModel>(context,listen: false).getPostPage();
      }
    });
  }
  var _pageStorageKey=new PageStorageKey('globalPosts');
  GlobalPostViewModel _postViewModel;
  var itemCount = 0;
  @override
  Widget build(BuildContext context) {
    refreshCompleter.complete();
    refreshCompleter=Completer();

    _postViewModel = Provider.of<GlobalPostViewModel>(context);

    if (_postViewModel.timeLineModel != null &&
        _postViewModel.timeLineModel.posts != null) {
      if(_postViewModel.globalPostState==GlobalPostState.Loaded
      ||_postViewModel.globalPostState==GlobalPostState.PostListEnd){
        itemCount = _postViewModel.timeLineModel.posts.length;
      }

    }
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: RefreshIndicator(
        onRefresh: ()async{
          await Provider.of<GlobalPostViewModel>(context,listen: false).refreshPostList();
          return refreshCompleter.future;
        },
        child: ListView.builder(
          key:  _pageStorageKey,
          controller: _scrollController,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return GlobalConsumerPost(index: index,);
            },itemCount: itemCount,),
      ),
    );
  }
}
