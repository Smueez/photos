import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:photos/globals/enums.dart';
import 'package:photos/models/image_model.dart';

import '../models/returned_data_model.dart';
import 'links.dart';

class ImageApiClass {
  Future<ReturnedDataModel<List>> getImageListApiCall(int page, int perPage)async{
    ReturnedDataModel<List> returnedDataModel = ReturnedDataModel(status: ReturnedStatus.error);
    try{
      Response res = await get(
          Uri.parse('${Links.pexelApi}page=$page&per_page=$perPage'),
          headers: {
            "Content-Type": "application/json",
          });
      if(res.statusCode == 200){
        Map jsonData = jsonDecode(res.body);
        if(jsonData.containsKey("photos")){
          if(jsonData["photos"].isNotEmpty){
            returnedDataModel.status = ReturnedStatus.success;
            returnedDataModel.data = jsonData["photos"]??[];
          }
        }
      }
    }
    catch(e,s){
      log("inside ImageApiClass error $e $s");
    }
    return returnedDataModel;
  }
}
