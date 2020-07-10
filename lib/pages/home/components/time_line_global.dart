import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/pages/home/listitem/post_list_item.dart';
import 'package:flutter_social_app/viewmodels/global_posts_viewmodel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TimeLineGlobal extends StatefulWidget {
  @override
  _TimeLineGlobalState createState() => _TimeLineGlobalState();
}

class _TimeLineGlobalState extends State<TimeLineGlobal> {
  Completer<void> refreshCompleter;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshCompleter=Completer<void>();
  }

  GlobalPostViewModel _postViewModel;
  @override
  Widget build(BuildContext context) {
    refreshCompleter.complete();
    refreshCompleter=Completer();

    _postViewModel = Provider.of<GlobalPostViewModel>(context);
    var itemCount = 1;
    if (_postViewModel.timeLineModel != null &&
        _postViewModel.timeLineModel.posts != null) {
      itemCount = _postViewModel.timeLineModel.posts.length;
    }
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: RefreshIndicator(
        onRefresh: ()async{
          await Provider.of<GlobalPostViewModel>(context,listen: false).refreshPostList();
          print('OnRefresh:');
          return refreshCompleter.future;
        },
        child: ListView.builder(
            key: new PageStorageKey('myListView'),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return Consumer(
                builder: (context, GlobalPostViewModel postViewModel, child) {
                  if (postViewModel.globalPostState == GlobalPostState.Idle) {
                    return Container(
                        padding: EdgeInsets.all(16),
                        width: double.infinity,
                        child: Center(child: CircularProgressIndicator()));
                  } else if (postViewModel.globalPostState ==
                      GlobalPostState.Loading) {
                    return Container(
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (postViewModel.globalPostState ==
                      GlobalPostState.Loaded) {
                    if (_postViewModel.timeLineModel.posts != null) {
                      return PostListItem(
                        post: _postViewModel.timeLineModel.posts[index],
                      );
                    }
                  } else if (postViewModel.globalPostState ==
                      GlobalPostState.Error) {
                    return Container(
                      child: Column(
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
                  } else if (postViewModel.globalPostState ==
                      GlobalPostState.PostListEnd) {
                    return Column(
                      children: <Widget>[
                        Text(
                          "Gönderilerin sonuna ulaştınız.",
                          style: GoogleFonts.montserrat(
                              fontSize: 24, color: Colors.red),
                        ),
                      ],
                    );
                  }

                  return CircularProgressIndicator();
                },
              );
            }),
      ),
    );
  }
}
