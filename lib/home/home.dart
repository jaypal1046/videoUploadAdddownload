import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_uploader/Util/Customtheme.dart';
import 'package:video_uploader/Util/imagePicker.dart';
import 'package:video_uploader/VideoPlay/Playvideo.dart';
import 'package:video_uploader/VideoPlay/ourVideoEditPage.dart';
import 'package:video_uploader/Widget/OurCustomTitle.dart';
import 'package:video_uploader/Widget/Widget.dart';
import 'package:video_uploader/home/ournew.dart';
import 'package:video_uploader/login/login.dart';
import 'package:video_uploader/profile/profile.dart';
import 'package:video_uploader/provider/provider.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {

    super.initState();
  }
  addMediaModel(context) {
    showModalBottomSheet(
        context: context,
        elevation: 0,
        builder: (context) {
          return Column(
            children: <Widget>[
              SizedBox(
                height: 80,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                      width: 60,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: FlatButton(
                          onPressed: () => Navigator.maybePop(context),
                          child: Icon(Icons.close),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: OurContener(
                              child: Text(
                                "Content and tools",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )))
                  ],
                ),
              ),
              Flexible(
                  child: ListView(
                    children: <Widget>[
                      OurContener(
                        child: ModelTitle(
                          title: "Camera",
                          subtitle: "Share video",
                          icon: Icons.image,
                          onTap: () =>pickImage(ImageSource.camera, context),

                        ),
                      ),
                      OurContener(
                        child: ModelTitle(
                          title: "gallery",
                          subtitle: "Share video",
                          icon: Icons.image,
                          onTap: () => pickImage(ImageSource.gallery, context),

                        ),
                      ),
                    ],
                  ))
            ],
          );
        });
  }

  String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  pickImage( ImageSource source, BuildContext context) async {

    File selectedVideo = await ImagePick.pickVideo(source);
    final videoInfo = FlutterVideoInfo();

    String videoFilePath = selectedVideo.path;
    var info = await videoInfo.getVideoInfo(videoFilePath);
    if (selectedVideo != null) {
      int totolbyte = selectedVideo.lengthSync();
      String totalSize = formatBytes(totolbyte, 2);
      OurProvider state = Provider.of<OurProvider>(context, listen: false);
      await state.getUserDetail();
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>

                OurVideoEditpage(
                  selectedVideo: selectedVideo,
                  uid: state.getUser.uid,
                  totolbyte: totolbyte,
                  totalSize: totalSize,
                  fullName: state.getUser.fullName,
                  profilePhoto: state.getUser.profilePhoto,
                  info: info,
                ),


          ));

      Navigator.pop(context);

    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    OurProvider _currentUse =
    Provider.of<OurProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: ()async{
            OurProvider _currentState =
            Provider.of<OurProvider>(context, listen: false);

            String _returnString = await _currentState.signOut();
            if (_returnString == "success") {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
            }

          },

          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(pi),
            child: Icon(Icons.logout, size: 25,),
          ),
        ),


        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>
                  OurProfileSetting(),),
              );
            },

            child: Icon(Icons.person_rounded),
          ),
          Icon(Icons.notifications),
        ],
      ),
      body: Column(
        children: [

          videoList(context),
          RaisedButton(
            onPressed: () =>addMediaModel(context),

            child: Icon(Icons.add),

          ),
        ],
      ),
    );
  }
  Widget videoList(BuildContext context)
  {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection("Videocoll").snapshots(),

        builder: (context,snapshot){
            if(snapshot.data==null){
                return Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),

                  ),
                );
            }else{
            var docList = snapshot.data.docs;

                 return Expanded(child: ListView.builder(
                        padding: EdgeInsets.all(10),
                        itemCount: docList.length,
                        itemBuilder: (context, index) {
                        if(docList[index].id!=null){
                        return Container(

                        child: docList[index].data()!=null?Column(
                        children: <Widget>[

                        Padding(
                        padding: EdgeInsets.only(top: 20,left:20,right:20,),
                        child: SizedBox(
                        height: 150,
                        child: OurList(url:docList[index].data()["url"]),

                        ),

                        ),


                          Text(docList[index].data()["videoTital"]),


                          ],
                          ):CircularProgressIndicator(),
                          );
                          }else{
                          return Container(
                          child: CircularProgressIndicator(),
                          );
                          }


                },
                ));
                    }
                  }
                );

            }
}

class OurList extends  StatefulWidget {
  String url;
  OurList({this.url});
  @override
  _OurListState createState() => _OurListState();
}

class _OurListState extends State<OurList> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});  //when your thumbnail will show.
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 300,
      width: double.infinity,
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>PlayVideoByLink(video: widget.url,)));
        },

        child: VideoPlayer(_controller),
      ),


    );
  }
}

class ModelTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;
  const ModelTitle(
      {@required this.title,
        @required this.subtitle,
        @required this.icon,
        this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: OurCustomTitle(
        mini: false,
        ontap: onTap,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVrialbes.reciverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVrialbes.grayColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: UniversalVrialbes.blackColor,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

