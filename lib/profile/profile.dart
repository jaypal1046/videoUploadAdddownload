import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_uploader/Widget/Widget.dart';
import 'package:video_uploader/database/database.dart';
import 'package:video_uploader/login/login.dart';
import 'package:video_uploader/profile/OurEditPage.dart';
import 'package:video_uploader/profile/ourContrains.dart';
import 'package:video_uploader/provider/provider.dart';
class OurProfileSetting extends StatefulWidget {
OurProvider provider;
OurProfileSetting({this.provider});
  @override
  _OurProfileSettingState createState() => _OurProfileSettingState();
}

class _OurProfileSettingState extends State<OurProfileSetting> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  OurDatabase database;
  OurProvider _currentUse;
  String fullName;
  String number;
  String link;


  @override
  void initState() {
    super.initState();
    database = OurDatabase();
   if(mounted){
    setState(() {

      _currentUse= Provider.of<OurProvider>(context,listen: false);
      _currentUse.getUserDetail();
    });
   }



  }


  void choisesAction(String choises) {
    if (choises == OurConstrain.profile) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) =>
              OurProfileSetting(
              provider:  _currentUse
              ),

          ));
    }
    if (choises == OurConstrain.Editprofile) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => OurEditProfile(),

          ));
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 5),
          ),
          PopupMenuButton<String>(
            onSelected: choisesAction,
            itemBuilder: (BuildContext context) {
              return OurConstrain.choices.map((String choices) {
                return PopupMenuItem<String>(
                  value: choices,
                  child: Text(choices),
                );
              }).toList();
            },
          )
        ],
      ),
      body:profile(_currentUse),




    );
  }
  //profile(_currentUse)


  Widget profile( _curntUse) {


    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0),
        child: OurContener(
          child: _currentUse.getUser!=null? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  backgroundImage: NetworkImage("${_currentUse.getUser.profilePhoto==null?"https://drive.google.com/u/0/uc?id=1Hya7qyPsb7PF8WI_lRm5fB761d9z1_tm&export=download":_currentUse.getUser.profilePhoto}"),
                  backgroundColor: Colors.grey,
                  radius: 45,
                ),
              ),
              Divider(
                color: Colors.black87,
                height: 60.0,
              ),
              Text(
                "FULLNAME",
                style: TextStyle(
                  color: Colors.black87,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                "${_currentUse.getUser.fullName}",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                "PHONE NUMBER",
                style: TextStyle(
                  color: Colors.black87,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                "${ _currentUse.getUser.phoneNumber}",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: 30.0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: RaisedButton(
                  child: Text('SignOut'),
                  onPressed: () => _signOut(context),
                  color: Theme.of(context).canvasColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(
                      color: Theme.of(context).secondaryHeaderColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ):CircularProgressIndicator(),
        ),
      ),
    );
  }

  void _signOut(BuildContext context) async {
    OurProvider _currentState =
    Provider.of<OurProvider>(context, listen: false);

    String _returnString = await _currentState.signOut();
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
    }
  }
}
