import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_popup/internet_popup.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../globals/custom_dialog.dart';
import '../../globals/enums.dart';

class AssetDownloadService {
  final BuildContext context;
  int count = 0;
  WidgetRef? ref;
  AssetDownloadService(this.context, {this.ref});
  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.isGranted) {
        return true;
      } else {
        var result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      }
      return false;
    }
    return false;
  }

  Future<String> getBasePath() async {
    bool permission = await _requestPermission();
    if (permission != true) {
      // openAppSettings();
      Alerts(context: context).customDialog(
          type: AlertType.warning,
          message: 'Permission not Given',
          description: 'Please give storage permission for the app to function',
          onTap1: () {
            Navigator.pop(context);
            // openAppSettings();
          });
    }

    // Directory? baseDir = await getExternalStorageDirectory();
    // print(baseDir.pa)
    Directory baseDir = await getApplicationDocumentsDirectory();
    String path = ('${baseDir.path}/v2');
    // String path = ('/v2');
    return path;
  }

  Future<String> getDownloadBasePath() async {
    bool permission = await _requestPermission();
    if (permission != true) {
      // openAppSettings();
      Alerts(context: context).customDialog(
          type: AlertType.warning,
          message: 'Permission not Given',
          description: 'Please give storage permission for the app to function',
          onTap1: () {
            Navigator.pop(context);
            // openAppSettings();
          });
    }

    Directory? baseDir = await getExternalStorageDirectory();
    String path = ('${baseDir!.path}/v2');
    if(!Directory(path).existsSync()){
      await Directory(path).create();
    }
    // String path = ('/v2');
    return path;
  }

  delete({List? list, required String folder}) async {
    print('toDelete $folder');
    String path = await getBasePath();
    Directory directory;
    if (list == null) {
      directory = Directory("$path/$folder");
      bool b = await directory.exists();
      if (b == true) {
        directory.deleteSync(recursive: true);
      }
    } else {
      directory = Directory("$path/$folder");
      if (list.isNotEmpty) {
        for (var i in list) {
          await File('${directory.path}/${basename(i)}').delete();
        }
      }
    }
  }



  Future<bool> downloadFileWithHttp({required String url, required String path, required String fileName}) async {
    bool success = false;
    try {
      String fileUrl = url;
      String pathString = "$path/$fileName";

      File pathFile = File(pathString);
      if (!(await pathFile.exists())) {
        try {
          Dio dio = Dio();
          Response response = await dio.get(
            fileUrl,
            options: Options(
                responseType: ResponseType.bytes,
                followRedirects: false,
                validateStatus: (status) {
                  return status! < 500;
                }),
          );
          print(response.statusCode);
          print(response.data);
          var raf = pathFile.openSync(mode: FileMode.write);
          raf.writeFromSync(response.data);
          await raf.close();
        } catch (e, s) {
          print("start file download catch block $e $s");
        }
      }
    } catch (e) {
      print("inside downloadFileWithHttp assetDownloadService catch block $e");
    }

    return success;
  }

}
