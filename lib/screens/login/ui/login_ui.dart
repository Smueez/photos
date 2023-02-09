import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photos/main.dart';
import 'package:photos/screens/gallery/ui/gallery_ui.dart';
import 'package:photos/screens/gallery/ui/home_ui.dart';
import 'package:sizer/sizer.dart';
class LoginUI extends StatefulWidget {
  const LoginUI({Key? key}) : super(key: key);

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: InkWell(
            onTap: ()async{
              if(await Permission.storage.isGranted){

                navigatorKey.currentState?.pushNamedAndRemoveUntil(HomeUi.routeName, (route) => false);
              }
              else if(await Permission.storage.isDenied){
                await Permission.storage.request();
              }

            },
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.sp),
                  border: Border.all(color: Colors.redAccent)
                ),
                padding: EdgeInsets.all(10.sp),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/google.png",width: 10.w,),
                    SizedBox(width: 2.w,),
                    const Text("Log in with google"),
                  ],
                )
            ),
          ),
        ),
      ),
    );
  }
}
