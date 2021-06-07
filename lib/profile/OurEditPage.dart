import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_uploader/Util/Customtheme.dart';
import 'package:video_uploader/Util/catch_Image.dart';
import 'package:video_uploader/Util/imagePicker.dart';
import 'package:video_uploader/Widget/OurCustomTitle.dart';
import 'package:video_uploader/Widget/Widget.dart';
import 'package:video_uploader/database/database.dart';
import 'package:video_uploader/provider/provider.dart';

class OurEditProfile extends StatefulWidget {
  @override
  _OurEditProfileState createState() => _OurEditProfileState();
}

class _OurEditProfileState extends State<OurEditProfile> {

  String url;
  OurProvider currentState;
  TextEditingController _fullNameControll;
  TextEditingController _PhoneNumberControll;


  @override
  void initState() {
    // note: implement initState
    super.initState();
    currentState=Provider.of<OurProvider>(context,listen: false);
    _fullNameControll= TextEditingController(text: currentState.getUser.fullName);
    _PhoneNumberControll= TextEditingController(text:  currentState.getUser.phoneNumber);
    url= currentState.getUser.profilePhoto;
  }


  addMediaModel(context){
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,

        builder: (context){
          return Container(
            height: MediaQuery.of(context).copyWith().size.height*0.25,
            child: Column(
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
                            onPressed: ()=>Navigator.maybePop(context),
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
                              )
                          ))
                    ],
                  ),
                ),
                Flexible(
                    child: ListView(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            OurContener(
                                child:  GestureDetector(

                                  onTap: ()=> pickImage(ImageSource.camera),

                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Icon(Icons.camera),
                                  ),
                                )
                            ),
                            OurContener(
                                child: GestureDetector(

                                  onTap: ()=>pickImage(ImageSource.gallery),

                                  child:SizedBox(
                                    height: 40,
                                    width: 40,
                                    child:  Icon(Icons.image),
                                  ),
                                )
                            ),
                          ],
                        )

                      ],
                    )
                )
              ],
            ),
          );
        });
  }
  pickImage(@required ImageSource source) async{
    File selectedImage=await ImagePick.pickImage(source);

    if(selectedImage != null){
      print("jay pal Image $selectedImage");
      url=await OurDatabase().updateUserImage(selectedImage);
      Navigator.pop(context);
    }else{
      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {

    return  Scaffold(

        appBar: AppBar(
            title: OurContener(
              child: Text('Edit Profile',style: TextStyle(color: Colors.black87,fontSize: 20.0,fontWeight: FontWeight.bold
              ),
              ) ,
            )
        ),
        body: OurContener(
            child:SingleChildScrollView(
              child: Column(

                children: <Widget>[
                  GestureDetector(
                    child:Stack(
                      children: <Widget>[

                        OurCachedImage(
                          currentState.getUser.profilePhoto,
                          isRound: true,
                          radius: 80,
                        ),
                        Icon(Icons.camera_enhance)
                      ],
                    ),

                    onTap: ()async{
                      print("jaypal Image");
                      await addMediaModel(context);
                    },
                  ),
                  TextFormField(
                    controller: _fullNameControll,
                    decoration: InputDecoration(),
                  ),
                  TextFormField(
                    controller: _PhoneNumberControll,
                    decoration: InputDecoration(),
                  ),



                  RaisedButton(child: Padding(padding: EdgeInsets.symmetric(horizontal: 60,),
                    child: Text('Update',style: TextStyle(color: Colors.white ,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                    ),
                  ),
                    onPressed: ()async{
                      String returnString=await OurDatabase().updateDetail(currentState.getUser.uid, _PhoneNumberControll.text, url,_fullNameControll.text);
                      if(returnString=="success"){
                        OurProvider provider= Provider.of<OurProvider>(context,listen: false);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            )


        )

    );
  }
}
class ModelTitl extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;
  const ModelTitl({@required this.title,@required this.subtitle,@required this.icon,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15 ),
      child: OurCustomTitle(
        mini: false,
        ontap: onTap,
        leading:Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVrialbes.reciverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(icon,
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
          title,style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontSize: 18,
        ),
        ),
      ),
    );
  }
}