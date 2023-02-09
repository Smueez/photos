import 'dart:convert';
import 'dart:developer';

import 'package:photos/api/image_api.dart';
import 'package:photos/globals/enums.dart';
import 'package:photos/models/returned_data_model.dart';
import 'package:photos/services/shared_storage_services.dart';

import '../globals/global_variables.dart';
import '../models/image_model.dart';

class ImageService {

  Future<List> getBookmarkImageList()async{
    List bookmarkedList = [];
    try{
      String? listStr = await LocalStorageHelper.read(imageKey);
      bookmarkedList = jsonDecode(listStr??"[]");
    }
    catch(e,s){
      print("inside ImageService getBookmarkImageIdList $e $s");
    }
    return bookmarkedList;
  }

  Future<bool> checkIfImageIsBookmarked(ImageModel image)async{
    try{
      List bookmarkList = await getBookmarkImageList();
      for(Map imageMap in bookmarkList){
        if(image.id == imageMap["id"]){
          return true;
        }
      }
    }
    catch(e,s){
      print("inside ImageService getBookmarkImageIdList $e $s");
    }
    return false;
  }

  Future<List<ImageModel>> getImageBookmarkList(int page, int perPage)async{
    List<ImageModel> imageList = [];
    try{
      int start = ((page - 1) * perPage);
      int end = (page * perPage);
      List bookmarkedList = await getBookmarkImageList();
      if((page * perPage) >= bookmarkedList.length && ((page - 1) * perPage) >= bookmarkedList.length){
        return [];
      }
      if((page * perPage) > bookmarkedList.length){
        end =  bookmarkedList.length;
      }
      for(int i = start; i < end; i ++){
        ImageModel imageModel = ImageModel.fromJson(bookmarkedList[i]);
        imageModel.bookmarked = true; //await checkIfImageIsBookmarked(imageModel);
        imageList.add(
            imageModel
        );
      }

    }

    catch(e,s){
      print("inside ImageService getImageList $e $s");
    }
    return imageList;
  }

  Future<List<ImageModel>> getImageList(int page, int perPage)async{
    List<ImageModel> imageList = [];
    try{
      ReturnedDataModel<List> returnedDataModel = await ImageApiClass().getImageListApiCall(page, perPage);
      if(returnedDataModel.status == ReturnedStatus.success){
        // List bookmarkedList = await getBookmarkImageList();
        List jsonList = returnedDataModel.data??[];
        for(Map imageMap in jsonList){
          ImageModel imageModel = ImageModel.fromJson(imageMap);
          imageModel.bookmarked = await checkIfImageIsBookmarked(imageModel);
          imageList.add(
              imageModel
          );
        }

      }

    }

    catch(e,s){
      print("inside ImageService getImageList $e $s");
    }
    return imageList;
  }
  saveBookmarks(List bookmarkList)async{
    try{
      String listStr = jsonEncode(bookmarkList);
      await LocalStorageHelper.save(imageKey, listStr);
    }
    catch(e,s){
      print("inside ImageService saveBookmarks $e $s");
    }
  }
}