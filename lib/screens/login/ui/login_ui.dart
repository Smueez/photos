import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photos/main.dart';
import 'package:photos/screens/gallery/ui/gallery_ui.dart';
import 'package:photos/screens/gallery/ui/home_ui.dart';
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
          child: ElevatedButton(
            onPressed: ()async{
              if(await Permission.storage.isGranted){

                navigatorKey.currentState?.pushNamedAndRemoveUntil(HomeUi.routeName, (route) => false);
              }
              else if(await Permission.storage.isDenied){
                await Permission.storage.request();
              }

            },
            child: Text("login"),
          ),
        ),
      ),
    );
  }
}
