import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_uploader/database/database.dart';
import 'package:video_uploader/home/home.dart';
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

  void loginUser(String phone, BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 120),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();
          UserCredential authResult =
          await _auth.signInWithCredential(credential);

          OurUser _ourUser = OurUser();

          User user = authResult.user;
          _ourUser.uid = user.uid;
          _ourUser.phoneNumber = user.phoneNumber;
          String _returnString = await OurDatabase().createUser(_ourUser);
          print("$_returnString jaypal");
          if (_returnString == "success") {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => OurRoot()));
          } else {
            print("error");
          }
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Give the code"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _otpController,
                      )
                    ],
                  ),
                  actions: [
                    FlatButton(
                      onPressed: () async {
                        final code = _otpController.text.trim();
                        OurUser _ourUser = OurUser();
                        AuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: code);
                        UserCredential authResult =
                        await _auth.signInWithCredential(credential);
                        User user = authResult.user;
                        _ourUser.uid = user.uid;
                        _ourUser.phoneNumber = user.phoneNumber;
                        String _returnString =
                        await OurDatabase().createUser(_ourUser);
                        print("$_returnString jaypal");
                        if (_returnString == "success") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  OurRoot()
                              ));
                        } else {
                          print("error");
                        }
                      },
                      child: Text("Confirm"),
                      textColor: Colors.black,
                      color: Colors.white,
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
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
            ButtonBar(
              children: <Widget>[
                ElevatedButton(
                  child: Text('NEXT'),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(8.0),
                    shape: MaterialStateProperty.all(
                      BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      ),
                    ),
                  ),
                  onPressed: () {
                    final phone = _usernameController.text.trim();
                    loginUser(phone, context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}