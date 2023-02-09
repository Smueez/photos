import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'asset_download_service.dart';

class AssetService {
  final BuildContext context;

  AssetService(this.context);
  String portID = "";
  //create asset Directory
  Future<bool> createAssetDirectory() async {
    try {
      String path = await AssetDownloadService(context).getBasePath();
      Directory assetDirectory = Directory(path);
      bool directoryExists = await assetDirectory.exists();

      if (!directoryExists) {
        await assetDirectory.create(recursive: true);
        return true;
      } else {
        return true;
      }
    } catch (e, s) {
      print("inside createAssetFile catch block $s");
      return false;
    }
  }

  delete()async{
    try{
      String path = ('${await AssetDownloadService(context).getBasePath()}/images');
      Directory assetDirectory = Directory(path);
      bool directoryExists = await assetDirectory.exists();
      if(directoryExists){
        assetDirectory.deleteSync();
      }
    }
    catch(e,s){
      log("delete cache photos $e $s");
    }
  }

  Future<File?> getAsset(String name, {required String imageUrl}) async {
    try {
      File? asset;

      await createAssetDirectory();

      String path = ('${await AssetDownloadService(context).getBasePath()}/images');

      Directory assetDirectory = Directory(path);
      bool directoryExists = await assetDirectory.exists();
      if (!directoryExists) {
        await assetDirectory.create(recursive: true);
      }
      asset = File('${assetDirectory.path}/$name');

      bool fileExists = await asset.exists();
      if (!fileExists) {

        await AssetDownloadService(context).downloadFileWithHttp(url: imageUrl, path: path, fileName: name);
        return await File(asset.path).exists()? File(asset.path) : null;
      } else {
        return File(asset.path);
      }
    } catch (e, s) {
      print("inside getAsset catch block $e");
      print("inside getAsset catch block $s");
      return null;
    }
  }



  Widget superImage(String name, {required String url, double? height, double? width, BoxFit? fit}) {
    return FutureBuilder(
        future: getAsset(name, imageUrl: url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data != null) {
              return Image.file(
                snapshot.data as File,
                height: height,
                width: width,
                fit: fit,
              );
            } else {
              return Image.asset(
                "assets/placeholder-image.png",
                height: height,
                width: width,
              );
            }
          } else {
            return Image.asset(
              "assets/placeholder-image.png",
              height: height,
              width: width,
            );
          }
        });
  }
}
