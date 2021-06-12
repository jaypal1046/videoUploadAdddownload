import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:provider/provider.dart';
import 'package:video_uploader/Widget/Widget.dart';
import 'package:video_uploader/database/database.dart';
import 'package:video_uploader/provider/provider.dart';
class OurVideoEditpage extends StatefulWidget {
  File selectedVideo;
  String uid;
  int totolbyte;
  String totalSize;
  String fullName;
  String profilePhoto;
  VideoData info;
  String steamCheck;
  OurVideoEditpage(
      {this.selectedVideo,
        this.uid,
        this.totolbyte,
        this.totalSize,
        this.fullName,
        this.profilePhoto,
        this.info,
        this.steamCheck});

  @override
  _OurVideoEditpageState createState() => _OurVideoEditpageState();
}

//todo:: i have to add video detail editing page the i have to connect on click invent for upload video;
class _OurVideoEditpageState extends State<OurVideoEditpage> {
  OurProvider _currentState;
  TextEditingController _channelNameControll     = TextEditingController();
  TextEditingController _categoryControll= TextEditingController();


  String url;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentState = Provider.of<OurProvider>(context, listen: false);
    getdata();
  }
  getdata()async{
    await _currentState.getUserDetail();

    url = _currentState.getUser.profilePhoto;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("video Editing page"),
      ),
      body: OurContener(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _channelNameControll,
                decoration: InputDecoration(hintText: 'please Enter the title video'),
              ),
              SizedBox(height: 20,),
              TextFormField(controller: _categoryControll,
                decoration: InputDecoration(hintText: 'please specify the category of video'),

              ),

              RaisedButton(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 60,
                  ),
                  child: Text(
                    'Update Video detail',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                onPressed: () async {


                     if(_categoryControll.text==null||_channelNameControll.text==null){
                       if(_channelNameControll.text==null){
                         Scaffold.of(context).showSnackBar(
                             SnackBar(content:Text("Enter the title of the video")
                               ,duration:  Duration(seconds: 2),
                             ));
                       }else {
                         Scaffold.of(context).showSnackBar(
                             SnackBar(content: Text(
                                 "please specify the category of video Ex. child, education ot fun")
                               , duration: Duration(seconds: 2),
                             ));
                       }
                    } else {
                      // uploadVideo(File video, String uid, int totolbyte, String totalSize, String fullname,String photourl, VideoData info, String steamCheck)
                      print(_categoryControll.text);
                      print(_channelNameControll.text);
                       String returnString = await OurDatabase().uploadVideo(
                          widget.selectedVideo,
                          _currentState.getUser.uid,
                          widget.totolbyte,
                          widget.totalSize,
                          widget.fullName,
                          widget.profilePhoto,
                          widget.info,
                          widget.steamCheck,
                          _channelNameControll.text,
                          _categoryControll.text);

                  // await OurDatabase().createChannel(_Channel_Name_Controll.text, _currentState.getCurrentUser.uid, _currentState.getCurrentUser.fullName,url);
                  if (returnString != null) {
                    Navigator.pop(context);
                  }
                    }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
