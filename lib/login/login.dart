import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_uploader/database/database.dart';
import 'package:video_uploader/home/home.dart';
import 'package:video_uploader/home/ournew.dart';
import 'package:video_uploader/model/user.dart';
import 'package:video_uploader/root/Ourroot.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _otpController = TextEditingController();

  final _unfocusedColor = Colors.grey[600];
  final _usernameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _usernameFocusNode.addListener(() {
      setState(() {
        // Redraw so that the username label reflects the focus state
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[

                SizedBox(height: 16.0),
                Padding(
                  padding: EdgeInsets.only(left: 30,top: 30,right: 30),
                  child: Image.asset("assets/Logo.png",height: 50,width: 50,),
                ),
                Text(
                  'VIDEO UPLOAD',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
            SizedBox(height: 120.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(
                    color: _usernameFocusNode.hasFocus
                        ? Theme.of(context).colorScheme.secondary
                        : _unfocusedColor),
              ),
              focusNode: _usernameFocusNode,
            ),
            SizedBox(height: 12.0),

           Padding(padding: EdgeInsets.only(left: 100
           ,
             right: 100
           )
           ,
           child:  ButtonTheme(
             minWidth: 1,
             height: 40,
             child: FlatButton(onPressed: () {
               final phone = _usernameController.text.trim();
               Navigator.push(context, MaterialPageRoute(builder: (context)=>OTPScreen(phone:phone)));

             },
               child: Text("Next"),
               textColor: Colors.black,
               color: Colors.blue,
             ),
           ),
           )


          ],
        ),
      ),
    );
  }
}