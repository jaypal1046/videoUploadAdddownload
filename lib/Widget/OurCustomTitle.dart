import 'package:flutter/material.dart';
class OurCustomTitle extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget icon;
  final Widget subtitle;
  final Widget trailing;
  final EdgeInsets margin;
  final bool mini;
  final GestureTapCallback ontap;
  final GestureLongPressCallback longPressCallback;
  OurCustomTitle({
    @required this.leading,
    @required this.title,
    this.icon,
    @required this.subtitle,
    this.trailing,
    this.margin=const EdgeInsets.all(0),
    this.mini=true,
    this.ontap,
    this.longPressCallback,

  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      onLongPress: longPressCallback,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: mini?10:0),
        margin: margin,
        child: Row(
          children: <Widget>[
            leading,
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: mini?10:15),
                padding: EdgeInsets.symmetric(vertical: mini?3:30),
                decoration: BoxDecoration(
                    border:  Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.blue,

                      ),

                    )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(crossAxisAlignment:
                    CrossAxisAlignment.start,
                      children: <Widget>[
                        title,
                        SizedBox(height: 5,),
                        Row(
                          children: <Widget>[
                            icon ?? Container(),

                            subtitle,
                          ],
                        )
                      ],),
                    trailing??Container(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
