import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_uploader/database/database.dart';
import 'package:video_uploader/model/user.dart';

class OurProvider extends ChangeNotifier{
  OurUser _user;
  OurDatabase database=OurDatabase();
  FirebaseAuth _auth = FirebaseAuth.instance;
  OurUser get getUser=>_user;
  Future<void> getUserDetail()async{
    OurUser user=await database.getUserdetail();
    if(user==null){
      getUserDetail();
    }else{
      _user=user;
    }

  notifyListeners();
  }
  Future<String> getUserDetailById()async{
    String retuenString="error";
    String retval=await database.getUserDetailById();
    if(retval=="success"){
      retuenString="success";
    }
    return retuenString;
  }
  Future<String> signOut() async {
    String retval = "error";
    try {
      await _auth.signOut();
      _user = OurUser();
      retval = "success";
    } catch (e) {
      print(e);
    }
    return retval;
  }
}