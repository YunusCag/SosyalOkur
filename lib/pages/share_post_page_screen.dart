import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/viewmodels/share_post_viewmodel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:provider/provider.dart';


class SharePostPageScreen extends StatefulWidget {
  @override
  _SharePostPageScreenState createState() => _SharePostPageScreenState();
}

class _SharePostPageScreenState extends State<SharePostPageScreen> {
  final _formKey = GlobalKey<FormState>();

  String _title;

  String _description;

  File _image;

  final picker=null;
  SharePostViewModel _viewModel;
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    _viewModel=Provider.of<SharePostViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Share Post",
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: width,
            height: height,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 16,left: 8,right: 8,bottom: 8),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xFFE0E0E0),
                      ),
                      child: TextFormField(
                        autofocus: false,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                        onSaved: (value){
                          _title=value;
                        },
                        validator:(value){
                          if(value.length<2){
                            return 'title must be long then 2 character';
                          }
                          return null;
                        },
                        minLines: 2,
                        maxLines: 5,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              LineAwesomeIcons.bold,
                              size: 32,
                            ),
                            hintText:'title' ,
                            border: InputBorder.none
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: InkWell(
                        onTap: ()async{
                           _pickImageFromGallery(ImgSource.Both);
                        },
                        child: Container(
                          width: double.infinity,
                          height: height*0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFFE0E0E0),
                          ),
                          child: _image==null?Center(
                            child: Icon(
                              LineAwesomeIcons.image,
                              size: 96,
                            ),
                          ):Image.file(
                              _image,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 32,left: 8,right: 8,bottom: 16),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xFFE0E0E0),
                      ),
                      child: TextFormField(
                        autofocus: false,
                        style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                        ),
                        onSaved: (value){
                          _description=value;
                        },
                        validator:(value){
                          if(value.length<20){
                            return 'title must be long then 20 character';
                          }
                          return null;
                        },
                        minLines: 5,
                        maxLines: 10,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              LineAwesomeIcons.text_width,
                              size: 32,
                            ),
                            hintText:'description' ,
                            border: InputBorder.none
                        ),
                      ),
                    ),
                    Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: MaterialButton(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        color: Colors.purple,
                        onPressed: _sharePost,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "SHARE",
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Consumer<SharePostViewModel>(
                              builder: (context,SharePostViewModel viewModel,child){
                                if(viewModel.sharePostState==SharePostState.Loading){
                                  return Container(
                                    child: Loading(
                                      indicator: BallPulseIndicator(),
                                      size: 50,
                                      color: Colors.pink,
                                    ),
                                  );
                                }
                                return Container();
                              },
                            )
                          ],
                        ),
                      ),
                    )


                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pickImageFromGallery(ImgSource imageSource)async{
    var image=await ImagePickerGC.pickImage(
        context: context,
        source: imageSource,
      cameraIcon: Icon(
        LineAwesomeIcons.file_image_o,
        color: Colors.purple,
      )
    );
    setState(() {
      _image=image;
    });
  }

  void _sharePost()async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      await _viewModel.sharePost(_title, _description, _image);
      if(_viewModel.sharePostState==SharePostState.Loaded){
        Navigator.of(context).pop(true);
        _viewModel.refresh();
      }

    }
  }
}

class PostDonePanel extends StatelessWidget {
  const PostDonePanel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Icon(
          Icons.done,
          size: 64,
          color: Colors.green,
        ),
      ),
    );
  }
}
