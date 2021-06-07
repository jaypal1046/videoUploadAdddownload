import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_uploader/home/home.dart';
import 'package:video_uploader/login/login.dart';
import 'package:video_uploader/provider/provider.dart';
import 'package:video_uploader/splace/OurSlace.dart';
enum AuthState{
  unknown,
  notLoggedIn,
  isLoggedIn,
}
class OurRoot extends StatefulWidget {
  @override
  _OurRootState createState() => _OurRootState();
}

class _OurRootState extends State<OurRoot> {
  AuthState _authState=AuthState.unknown;


  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    //getState,checkState,set AuthSate base on state
    OurProvider _currentUse=Provider.of<OurProvider>(context,listen: false);
    String retuenString=await _currentUse.getUserDetailById();
    if(retuenString=="success"){
     setState(() {
       _authState=AuthState.isLoggedIn;
     });

    }else{
      setState(() {
        _authState = AuthState.notLoggedIn;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    Widget retVal;

    switch(_authState){
      case AuthState.unknown:
        retVal=OurSplace();
        break;
      case AuthState.notLoggedIn:
        retVal=LoginPage();
        break;
      case AuthState.isLoggedIn:

        retVal= HomePage();
        break;

      //retVal=ChangeNotifierProvider(create: (context)=>CurrentGroupState(), child: HomeScreen(),);

      default:
    }
    return retVal;
  }
}