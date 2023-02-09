import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photos/models/image_model.dart';
import 'package:photos/services/image_service.dart';

import '../../globals/enums.dart';
import '../global_provider.dart';

class ImageListNotifier extends StateNotifier<AsyncValue<List<ImageModel>>> {
  List<ImageModel> mainImageList = [];
  int page = 0;
  int perPage = 28;
  late Ref ref;
  late GalleryType type;
  ImageService imageService = ImageService();
  ImageListNotifier({required this.ref, required this.type}) : super(const AsyncLoading()) {
    getImageList();
  }

  getImageList()async{

    List<ImageModel> imageList = type == GalleryType.gallery? await imageService.getImageList(page, perPage) : await imageService.getImageBookmarkList(page + 1, perPage);
    page++;
    mainImageList.addAll(imageList);
    state = AsyncData([...mainImageList]);
    // ref.read(imageLoadingShowProvider.state).state = false;
  }
}