import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photos/models/image_model.dart';
import 'package:photos/screens/gallery/controller/gallery_controller.dart';
import 'package:photos/services/asset/asset_service.dart';
import 'package:sizer/sizer.dart';

import '../../../globals/enums.dart';
import '../../../provider/global_provider.dart';

class GalleryUI extends ConsumerStatefulWidget {
  final GalleryType type;
  const GalleryUI({required this.type, Key? key}) : super(key: key);

  @override
  ConsumerState<GalleryUI> createState() => _GalleryUIState();
}

class _GalleryUIState extends ConsumerState<GalleryUI> {
  late ScrollController scrollController;
  late GalleryController galleryController;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    galleryController = GalleryController(context: context, ref: ref);
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        bool isTop = scrollController.position.pixels == 0;
        if (!isTop) {

          ref.read(getImageListProvider(widget.type).notifier).getImageList();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    if(scrollController.hasListeners){
      scrollController.removeListener(() { });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.type == GalleryType.gallery?
            "Photo Gallery"
              :
              "Bookmark Gallery"
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 2.h, left: 3.w, right: 3.w),
        child: Column(
          children: [
            Text(
                "Tap on photo to see more",
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 1.h,),
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  AsyncValue<List<ImageModel>> asyncImageList = ref.watch(getImageListProvider(widget.type));
                  return asyncImageList.when(
                      data: (imageList){
                        if(imageList.isEmpty){
                          return const Center(
                            child: Text("Nothing to show"),
                          );
                        }
                        return  GridView.builder(
                          padding: EdgeInsets.only(bottom: 2.h),
                            controller: scrollController,
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 1,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2),
                            itemCount: imageList.length,
                            itemBuilder: (BuildContext ctx, index) {
                              return getImage(imageList[index]);
                            });
                      }, 
                      error: (error, _)=> const Center(child: Text("Something went wrong"),),
                      loading: (){
                        return   Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Please Wait"),
                              SizedBox(width: 2.w,),
                              const CircularProgressIndicator(),
                            ],
                          ),
                        );
                      }
                  );
                   
                }
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget getImage(ImageModel imageModel){
    return  InkWell(
      onTap: (){
        galleryController.onImagePressed(imageModel);
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(5.sp)),
        child: Stack(
          children: [
            Container(
                width: 100.w,
                height: 100.h,
                child: AssetService(context).superImage("${imageModel.id}${imageModel.extension}", url: imageModel.src.medium)
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                color: Colors.grey.withOpacity(0.4),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 2.w),
                    child: Consumer(
                      builder: (context, ref,_) {
                        bool? bookmarked = ref.watch(imageIfBookmarkedProvider(imageModel.id));
                        bookmarked??=imageModel.bookmarked;
                        return Icon(
                          bookmarked?Icons.star:Icons.star_border,
                          color: Colors.amber,
                        );
                      }
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
