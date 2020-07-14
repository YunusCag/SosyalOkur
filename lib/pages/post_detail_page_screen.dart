import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_social_app/models/time_line_model.dart';
import 'package:flutter_social_app/utils/app_constants.dart';
import 'package:flutter_social_app/viewmodels/global_posts_viewmodel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

class PostDetailPageScreen extends StatefulWidget {
  Post post;


  PostDetailPageScreen({
    @required this.post
  });

  @override
  _PostDetailPageScreenState createState() => _PostDetailPageScreenState();
}

class _PostDetailPageScreenState extends State<PostDetailPageScreen> {
  final DateFormat formatter = DateFormat('dd MMMM yyyy');

  final DateTime dateNow = DateTime.now();

  int difference;

  var _rating=0.0;

  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    bool isImageExists = widget.post.profileImage != null;
    DateTime dateTime = DateTime.parse(widget.post.createdAt);
    difference = dateNow.difference(dateTime).inDays;

    _rating=widget.post.rateAverage.toDouble();
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: height*0.4,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
                background: buildPostImage(),
              title: Text(
                widget.post.title.trim(),
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 5,
                    ),
                    isImageExists
                        ? ClipOval(
                      child: Image.network(
                        AppConstant.IMAGE_URL + widget.post.profileImage ?? '',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    )
                        : ClipOval(
                      child: Image.asset(
                        'assets/images/icon.jpg',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.post.name,
                          style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "@" + widget.post.username,
                          style: GoogleFonts.montserrat(
                              fontSize: 14, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    Spacer(),
                    buildPostDate(),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    widget.post.title,
                    style: GoogleFonts.montserrat(
                        fontSize: 26,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    widget.post.description,
                    //textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 20
                    ),
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.purple,
                  child:  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _buildRateBar(),
                        SizedBox(
                          width: 5,
                        ),
                        _buildRateButton(),
                        SizedBox(
                          width: 5,
                        ),
                        _buildLikeButton(),
                      ],
                    ),
                  ),
                )
              ]
            ),
          ),
        ],
      )
    );
  }

  Image buildPostImage() {
    if(widget.post!=null&&widget.post.postImage!=null){
      return Image.network(
        AppConstant.IMAGE_URL+widget.post.postImage,
        fit: BoxFit.fill,
      );
    }
    return Image.network(
      AppConstant.IMAGE_URL+widget.post.profileImage,
      fit: BoxFit.fill,
    );
  }
  Widget buildPostDate() {
    String dateText = '';
    if (difference == 0) {
      dateText = 'today';
    } else if (difference == 1) {
      dateText = 'yesterday';
    } else if (difference > 1) {
      dateText = difference.toString() + " days ago";
    }

    return Text(
      dateText,
      style:
      GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.normal),
    );
  }
  Widget _buildRateBar() {
    int ratedCount=widget.post.ratedCount;
    return Container(
      padding: EdgeInsets.only(
          left: 5,
          right: 5
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RatingBar(
            initialRating: _rating,
            minRating: 0,
            itemSize: 40,
            unratedColor: Colors.grey.withOpacity(.5),
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context,_)=>Icon(
              Icons.star,
              color: Colors.amber,
            ),
          ),
          Text(
            "($ratedCount)",
            style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w400
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRateButton() {
    if(!widget.post.isRated){

      return FlatButton(
        onPressed:  _showRatingDialog,
        child: Text(
          "Değerlendir.",
          style: GoogleFonts.montserrat(
              fontSize: 20,
              color: Colors.blue[900],
            fontWeight: FontWeight.bold
          ),
        ),
      );
    }
    return Text(
      "Değerlendirildi. (${widget.post.userRateNum})",
      style: GoogleFonts.montserrat(
          fontSize: 20
      ),
    );
  }

  void _showRatingDialog() {
    double rateNum=0;
    showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            title: Text(
              "Gönderiyi değerlendir.",
              style: GoogleFonts.montserrat(),
            ),
            content: RatingBar(
              tapOnlyMode: true,
              initialRating: rateNum,
              minRating: 0,
              itemSize: 40,
              onRatingUpdate: (value){
                setState(() {
                  rateNum=value;
                });
              },
              unratedColor: Colors.grey.withOpacity(.5),
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context,_)=>Icon(
                Icons.star,
                color: Colors.amber,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: ()async{
                  Navigator.of(context).pop();
                  var postModel=await Provider.of<GlobalPostViewModel>(context,listen: false).ratePos(rateNum, widget.post.id);
                  if(postModel!=null&&postModel.status){
                    setState(() {
                      widget.post=postModel.post;
                    });
                  }
                },
                child: Text(
                  "Kaydet",
                  style: GoogleFonts.montserrat(
                      color: Colors.red
                  ),
                ),
              )
            ],
          );
        }
    );
  }

  Widget _buildLikeButton() {
    bool isLiked=widget.post.isLiked;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        LikeButton(
          isLiked: isLiked,
          onTap: (bool isLike)async{
            var postModel;
            if(!isLike){
              postModel=await Provider.of<GlobalPostViewModel>(context,listen: false).likePost(widget.post.id);
            }else{
              postModel=await Provider.of<GlobalPostViewModel>(context,listen: false).unlikePost(widget.post.id);
            }
            if(postModel!=null&&postModel.status){
              setState(() {
                widget.post=postModel.post;
              });
              return !isLike;
            }
            return isLike;

          },

        ),
        SizedBox(width: 4,),
        Text(
          " (${widget.post.likedCount})",
          style: GoogleFonts.montserrat(
              fontSize: 14
          ),
        )
      ],
    );
  }
}
