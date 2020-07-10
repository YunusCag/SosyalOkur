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

class PostListItem extends StatefulWidget {
   Post post;

  PostListItem({this.post});

  @override
  _PostListItemState createState() => _PostListItemState();
}

class _PostListItemState extends State<PostListItem> {
  final DateFormat formatter = DateFormat('dd MMMM yyyy');

  final DateTime dateNow = DateTime.now();

  bool _readMore=false;

  int difference;
  var _rating=0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    bool isImageExists = widget.post.profileImage != null;
    DateTime dateTime = DateTime.parse(widget.post.createdAt);
    difference = dateNow.difference(dateTime).inDays;
    _rating=widget.post.rateAverage.toDouble();
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      margin: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 5,
              ),
              isImageExists
                  ? ClipOval(
                      child: Image.network(
                        AppConstant.IMAGE_URL + widget.post.profileImage ?? '',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipOval(
                      child: Image.asset(
                        'assets/images/icon.jpg',
                        width: 40,
                        height: 40,
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
          _buildImage(),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildPostTitle(),
                buildPostDescription(),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
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
          SizedBox(
            height: 8,
          ),
          Divider(
            thickness: 1.2,
          ),
        ],
      ),
    );
  }

  Text buildPostDate() {
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
          GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.normal),
    );
  }

  Widget buildPostDescription() {
    if (widget.post.description != null) {
      String postDescription='';
      String readMore='';
      if(_readMore){
        postDescription=widget.post.description;
        readMore='';
      }else if(widget.post.description.length>80){
        postDescription=widget.post.description.substring(0,79)+" ";
        readMore='daha fazla okumak için tıklayınız.';
      }else{
        postDescription=widget.post.description;
        readMore='';
      }

      return InkWell(
        onTap: (){
          setState(() {
            _readMore=!_readMore;
          });
        },
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4, bottom: 4, right: 8),
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: postDescription,
                    style: GoogleFonts.montserrat(
                        fontSize: 16, fontWeight: FontWeight.w400
                    ),
                  ),
                  TextSpan(
                    text: readMore,
                    style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.blue),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Container();
  }

  Widget buildPostTitle() {
    if (widget.post.title != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 4),
        child: Text(
          widget.post.title ?? "",
          style:
              GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      );
    }
    return Container();
  }

  Widget _buildImage() {
    if (widget.post.postImage != null) {
      return Container(
        padding: EdgeInsets.only(top: 8),
        width: double.infinity,
        height: 200,
        child: Image.network(
          AppConstant.IMAGE_URL + widget.post.postImage,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container();
    }
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
            itemSize: 20,
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
          "Değerlendir",
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: Colors.blue
          ),
        ),
      );
    }
    return Text(
      "Değerlendirildi (${widget.post.userRateNum})",
      style: GoogleFonts.montserrat(
          fontSize: 14
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
