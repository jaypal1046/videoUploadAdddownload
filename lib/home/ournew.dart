import 'package:flutter/material.dart';
class Ournew extends StatefulWidget {
  String uid;
  String phoneNumber;
  Ournew({this.uid,this.phoneNumber});
  @override
  _OurnewState createState() => _OurnewState();
}

class _OurnewState extends State<Ournew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("cking provider"),
      ),
      body: Container(
        child: Text("${widget.uid},${widget.phoneNumber}"),
      ),
    );
  }
}
