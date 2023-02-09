import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photos/globals/custom_dialog.dart';
import 'package:photos/globals/enums.dart';
import 'package:photos/main.dart';
import 'package:photos/models/image_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../provider/global_provider.dart';
import '../../../services/asset/asset_download_service.dart';
import '../../../services/asset/asset_service.dart';
import '../../../services/image_service.dart';

class GalleryController {
  late BuildContext context;
  late WidgetRef ref;
  late Alerts alerts;
  late AssetService assetService;
  late AssetDownloadService assetDownloadService;
  ImageService imageService = ImageService();
  GalleryController({required this.context, required this.ref}){
    alerts = Alerts(context: context);
    assetService = AssetService(context);
    assetDownloadService = AssetDownloadService(context);
  }

  Future<File?>getImageFile(String name)async{
    File? asset;

    await assetService.createAssetDirectory();

    String path = ('${await assetDownloadService.getBasePath()}/images');

    Directory assetDirectory = Directory(path);
    bool directoryExists = await assetDirectory.exists();
    if (!directoryExists) {
    await assetDirectory.create(recursive: true);
    }
    asset = File('${assetDirectory.path}/$name');
    return asset;
  }

  onImagePressed(ImageModel imageModel)async{

    File? fileImage = await getImageFile("${imageModel.id}${imageModel.extension}");
    if(fileImage == null){
      return;
    }
    if(!await fileImage.exists()){
      return;
    }

    alerts.showModalWithWidget(
      dismissible: true,
        child: Stack(
          children: [
            PhotoView(
              imageProvider: FileImage(fileImage)
            ),
            Positioned(
              top: 0,
                right: 0,
                child: IconButton(
                  onPressed: (){
                    navigatorKey.currentState?.pop();
                  },
                  icon: const Icon(Icons.close, color: Colors.red,),
                )
            ),
            Positioned(
              bottom: 0,
                right: 0,
                left: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: (){
                            doOpenInBrowser(imageModel.photographerUrl);
                          },
                          child: Text(
                            "By ${imageModel.photographer}",
                            style: const TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: (){
                                doBookmark(imageModel);
                              },
                              icon: Consumer(
                                builder: (context,ref,_) {
                                  bool? bookmarked = ref.watch(imageIfBookmarkedProvider(imageModel.id));
                                  bookmarked??=imageModel.bookmarked;
                                  return Icon(bookmarked?Icons.star : Icons.star_border, size: 26.sp,color: Colors.amber,);
                                }
                              )
                          ),
                          IconButton(
                              onPressed: ()async{
                                doDownload(imageModel);
                              },
                              icon: Icon(Icons.download_rounded, size: 26.sp,color: Colors.green,)
                          ),
                          IconButton(
                              onPressed: (){
                                doOpenInBrowser(imageModel.url);
                              },
                              icon: Icon(Icons.open_in_browser, size: 26.sp,color: Colors.yellow,)
                          ),
                          IconButton(
                              onPressed: (){
                                doShare(imageModel);
                              },
                              icon: Icon(Icons.share, size: 26.sp,color: Colors.blue,)
                          ),
                        ],
                      )
                    ],
                  ),
                )
            )
          ],
        )
    );
  }

  doShare(ImageModel imageModel)async{
    File? fileImage = await assetService.getAsset("${imageModel.id}${imageModel.extension}", imageUrl: imageModel.src.large);
    if(fileImage != null){
      Share.shareFiles([fileImage.path]);
    }
  }


  doDownload(ImageModel imageModel)async{
    alerts.floatingLoading();
    String filePath = await assetDownloadService.getDownloadBasePath();
    String fileName = "${imageModel.id}${imageModel.extension}";
    await assetDownloadService.downloadFileWithHttp(url: imageModel.src.medium, path: filePath, fileName: fileName);
    navigatorKey.currentState?.pop();
  }

  doOpenInBrowser(String? url)async{
    if(url != null){
      await launchUrl(Uri.parse(url));
    }
  }

  doBookmark(ImageModel imageModel)async{
    alerts.floatingLoading();
    List bookmarks = await imageService.getBookmarkImageList();
    for(Map imageMap in bookmarks){
      if(imageMap["id"] == imageModel.id){
        imageModel.bookmarked = false;
        bookmarks.remove(imageMap);
        ref.read(imageIfBookmarkedProvider(imageModel.id).state).state = false;
        await imageService.saveBookmarks(bookmarks);
        navigatorKey.currentState?.pop();
        ref.refresh(getImageListProvider(GalleryType.bookmark));
        return;
      }
    }
    imageModel.bookmarked = false;
    bookmarks.add(imageModel.toJson());
    await imageService.saveBookmarks(bookmarks);
    ref.read(imageIfBookmarkedProvider(imageModel.id).state).state = true;
    ref.refresh(getImageListProvider(GalleryType.bookmark));
    navigatorKey.currentState?.pop();
  }

}