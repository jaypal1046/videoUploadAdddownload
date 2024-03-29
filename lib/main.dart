import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_uploader/login/login.dart';
import 'package:video_uploader/provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:video_uploader/root/Ourroot.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_)=>OurProvider(),
      child:MaterialApp(
        home: OurRoot(),
      ),
    );
  }
}


