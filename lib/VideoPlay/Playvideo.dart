import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_uploader/Util/catch_Image.dart';
import 'package:video_uploader/provider/provider.dart';
class PlayVideoByLink extends StatefulWidget {
  String video;
  Map<String, dynamic> doclists;
  PlayVideoByLink ({this.video,this.doclists});
  @override
  _OurVideoState createState() => _OurVideoState();
}

class _OurVideoState extends State<PlayVideoByLink> {
  final formKey=GlobalKey<FormState>();
  final TextEditingController _commentController=TextEditingController();
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  OurProvider _provider;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List fileData=[];
  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    // File select=File(widget.video.path);
    _controller = VideoPlayerController.network(
        widget.video
    );

    _provider=Provider.of<OurProvider>(context,listen: false);
    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video'),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body:Column(
        children: [
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the VideoPlayerController has finished initialization, use
                // the data it provides to limit the aspect ratio of the video.
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  // Use the VideoPlayer widget to display the video.
                  child: VideoPlayer(_controller),
                );
              } else {
                // If the VideoPlayerController is still initializing, show a
                // loading spinner.
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection("User").snapshots(),
              builder: (context,snapshot){
                if(snapshot.data==null){
                  return Container(
                    height: 0.1,
                  );
                }
                else{
                  var docLists = snapshot.data.docs;
                  var view=widget.doclists["view"];
                  if(widget.doclists["view"]==null){
                    view=0;
                  }
                  var like=widget.doclists["like"];
                  if(widget.doclists["like"]==null){
                    like=0;
                  }
                  var dislike=widget.doclists["dislike"];
                  if(widget.doclists["view"]==null){
                    dislike=0;
                  }
                  return Expanded(
                      child: ListView.builder(
                          padding: EdgeInsets.all(10),
                          itemCount: docLists.length,
                          itemBuilder: (context,inde){

                            if(docLists[inde].id==widget.doclists["uploaderUid"]){
                              return Column(
                                children: [
                                  Text("${widget.doclists["videoTital"]}",style: TextStyle(fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      SizedBox(width:20,),
                                      Row(children: [
                                        Icon(Icons.thumb_up_alt,size:30,color: Colors.black,),
                                        SizedBox(width: 5,),
                                      ],),
                                      SizedBox(width:90,),
                                      Row(children: [
                                        Icon(Icons.thumb_down_alt,size:30,color: Colors.black,),
                                        SizedBox(width: 5,),

                                      ],),
                                      SizedBox(width:90,),
                                      Row(children: [
                                        Icon(Icons.share,size:30,color: Colors.black,),
                                        SizedBox(width: 5,),

                                      ],),
                                    ],
                                  ),

                                  Row(
                                    children: [

                                      SizedBox(width: 20,),
                                      Column(
                                        children: [
                                          Text("${like} like"),

                                          //Text("${docList[index].data()["uploadedDate"]}",style: TextStyle(fontWeight: FontWeight.bold),),

                                        ],
                                      ),
                                      SizedBox(width: 80,),
                                      Column(
                                        children: [
                                          Text("${dislike} dislike"),

                                        ],
                                      ),
                                      SizedBox(width: 80,),
                                      Column(
                                        children: [
                                         Text(" share"),
                                        ],
                                      ),

                                    ],
                                  ),
SizedBox(height: 20,),
                                  Row(
                                    children: [

                                      SizedBox(width: 20,),
                                      Column(
                                        children: [
                                            Text("0 days ago"),
                                        ],
                                      ),
                                      SizedBox(width: 50,),
                                      Column(
                                        children: [

                                          Text("0 days"),
                                          //Text("${docList[index].data()["uploadedDate"]}",style: TextStyle(fontWeight: FontWeight.bold),),

                                        ],
                                      ),
                                      SizedBox(width: 80,),
                                      Column(
                                        children: [

                                          Text("${widget.doclists["catergary"]}"),
                                        ],
                                      ),



                                    ],
                                  ),

                                  Row(
                                    children: [
                                      OurCachedImage(
                                        docLists[inde].data()["profilePhoto"],
                                        isRound: true,
                                        radius: 50,
                                      ),
                                      SizedBox(width: 20,),
                                      Column(
                                        children: [
                                          Text("${docLists[inde].data()["fullName"]}"),
                                        ],
                                      ),
                                    ],
                                  )

                                ],

                              );
                            }else{

                              return Container(
                                height: 0.1,
                              );
                            }
                          }
                      )
                  );
                }
              }
          )

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it.
              _controller.play();
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}