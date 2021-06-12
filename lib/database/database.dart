import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:video_uploader/model/user.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class OurDatabase{
  firebase_storage.Reference _storageReference;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference myVideoColl =
  FirebaseFirestore.instance.collection("Videocoll");
  static const _chars = 'abcdefghijklmnopqrstuvwxyz';
  Random _rnd = Random();
  String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  Future<String> createUser(OurUser user) async {
    String retVal = "error";
    try {

      //await FirebaseFirestore.instance.collection("User").doc(user.uid);
      CollectionReference users=FirebaseFirestore.instance.collection("User");
      users.doc(user.uid).set({
        "uid": user.uid,
        "fullName": user.fullName,
        "phoneNumber": user.phoneNumber,
        "profilePhoto": user.profilePhoto,
      }).then((value) => print("User Added")).catchError((error)=>print("Failed to add new user:$error"));
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }
  Future<String> updateDetail(String uid, String phoneNumber,
      String url, String fullName) async {
    String retval = "error";
    try {
      CollectionReference users=FirebaseFirestore.instance.collection("User");
      await users.doc(uid).update({
        "fullName": fullName,
        "phoneNumber": phoneNumber,

        "profilePhoto": url
      });
      retval = "success";
    } catch (e) {
      retval = "error";

    }
    return retval;
  }
  Future<OurUser> getUserdetail() async {
    User currentUser = _auth.currentUser;
    print("${currentUser.uid} cheking uid is null or not");
    CollectionReference snapshot=await FirebaseFirestore.instance.collection("User");
    DocumentSnapshot collectionsn= await snapshot.doc(currentUser.uid).get();
    print(collectionsn.data()["uid"]);
    /* DocumentSnapshot documentSnapshot =
    await users.doc(currentUser.uid).get();*/
    return OurUser.fromMap(collectionsn.data());


  }

 Future<String> getUserDetailById()async {
  String  retval="error";
  try{
    String uid=_auth.currentUser.uid;
    CollectionReference snapshot=await FirebaseFirestore.instance.collection("User");
    DocumentSnapshot collectionsn= await snapshot.doc(uid).get();
    if(collectionsn.data() != null){
      retval="success";
    }
  }catch(e){
    print(e);
  }
    return retval;


  }
  Future<OurUser> getUserDetailId(String uid)async {
    OurUser  retval=OurUser();
    try{

      CollectionReference snapshot=await FirebaseFirestore.instance.collection("User");
      DocumentSnapshot collectionsn= await snapshot.doc(uid).get();
      if(collectionsn.data() != null){
        retval.uid=collectionsn.data()["uid"];
        retval.fullName=collectionsn.data()["fullName"];
        retval.phoneNumber=collectionsn.data()["phoneNumber"];
        retval.profilePhoto=collectionsn.data()["profilePhoto"];
      }
    }catch(e){
      print(e);
    }
    return retval;

  }
  String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }
  Future<String> uploadVideotodatabase(
      video, String uid, int total, String totalSize, VideoData info) async {
    try {
      _storageReference = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      firebase_storage.SettableMetadata metadata =
      firebase_storage.SettableMetadata(
        customMetadata: <String, String>{
          "title": "${info.title}",
          "author": "${info.author}",
          "data": "${info.date}",
          "filesize": "${totalSize}",
          "duration": "${info.duration}",
        },
      );
      UploadTask _storageUploadTask =
      _storageReference.putFile(video, metadata);
      var url = await (await _storageUploadTask.whenComplete(
              () => print("${_storageUploadTask.snapshot.state}")))
          .ref
          .getDownloadURL();
      print("$url url checking that it generating or not");
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> uploadVideo(
      File video,
      String uid,
      int totolbyte,
      String totalSize,
      String fullname,
      String photourl,
      VideoData info,
      String steamCheck,

      String videotital,String categoty) async {
    try {
      int like=0;
      int dislike=0;
      int view=0;
      String url =
      await uploadVideotodatabase(video, uid, totolbyte, totalSize, info);

      String videosId = getRandomString(18);
      await myVideoColl.doc().set({
        "fullName": fullname,
        "videoTital": videotital,
        "videoId": videosId,
        "url": url,
        "totalSize": totalSize,
        "like":like,
        "dislike":dislike,
        "uploaderUid":uid,
        "uploadedDate":Timestamp.now(),
        "view":view,
        "catergary":categoty,
      });

      print(url);
      return url;
    } catch (e) {
      return null;
    }
  }

  Future<String> updateUserImage(image) async {
    String url = await uploadImagetodatabase(image);
    return url;
  }
  Future<String> uploadImagetodatabase(image) async {
    try {
      _storageReference = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      UploadTask _storageUploadTask = _storageReference.putFile(image);
      var url = await (await _storageUploadTask.whenComplete(() => null))
          .ref
          .getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }
}