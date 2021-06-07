import 'package:flutter/cupertino.dart';

class UniversalVrialbes{
  static final Color blueColor=Color(0xff2b9ed4);
  static final Color blackColor=Color(0xff19191b);
  static final Color grayColor=Color(0xff8f8f8f);
  static final Color userCircleBkackground=Color(0xff2b2b33);
  static final Color onlinDotiColor=Color(0xff46dc64);
  static final Color lightblueColor=Color(0xff0077d7);
  static final Color separtorColor=Color(0xff272c35);

  static final Color gradientColorStart=Color(0xff00b6f3);
  static final Color gradientColorend=Color(0xff0184dc);

  static final Color senderColor=Color(0xff2b343b);

  static final Color reciverColor=Color(0xff1e2225);

  static final Gradient fabGradint=LinearGradient(
      colors: [gradientColorStart,gradientColorend],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight
  );
}