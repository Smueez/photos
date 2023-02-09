import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photos/models/image_model.dart';
import 'package:photos/provider/notifier/image_list_notifier.dart';

import '../globals/enums.dart';

final getImageListProvider = StateNotifierProvider.autoDispose.family<ImageListNotifier, AsyncValue<List<ImageModel>>,GalleryType >((ref, type) => ImageListNotifier(ref: ref, type:  type));

final imageIfBookmarkedProvider = StateProvider.autoDispose.family<bool?, int>((ref, id) => null);