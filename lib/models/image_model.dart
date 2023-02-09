class ImageModel {
  late int id;
  int? width;
  int? height;
  String? url;
  String? photographer;
  String? photographerUrl;
  int? photographerId;
  String? avgColor;
  late Src src;
  String? alt;
  bool bookmarked = false;
  String extension = ".JPEG";

  ImageModel(
      {required this.id,
        this.width,
        this.height,
        this.url,
        this.photographer,
        this.photographerUrl,
        this.photographerId,
        this.avgColor,
        required this.src,
        required this.bookmarked,
        this.alt});

  ImageModel.fromJson(json) {
    id = json['id'];
    width = json['width'];
    height = json['height'];
    url = json['url'];
    photographer = json['photographer'];
    photographerUrl = json['photographer_url'];
    photographerId = json['photographer_id'];
    avgColor = json['avg_color'];
    src =  Src.fromJson(json['src']);
    alt = json['alt'];
    extension = getExtension(src.original);
  }

  String getExtension(String url){
    List<String> splittedUrlList = url.split(".");
    return '.${splittedUrlList[splittedUrlList.length - 1]}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['width'] = width;
    data['height'] = height;
    data['url'] = url;
    data['photographer'] = photographer;
    data['photographer_url'] = photographerUrl;
    data['photographer_id'] = photographerId;
    data['avg_color'] = avgColor;
    data['src'] = src.toJson();
    data['alt'] = alt;
    return data;
  }
}

class Src {
  late String original;
  late String large2x;
  late String large;
  late String medium;
  late String small;
  late String portrait;
  late String landscape;
  late String tiny;

  Src(
      {required this.original,
       required this.large2x,
       required this.large,
       required this.medium,
       required this.small,
       required this.portrait,
       required this.landscape,
       required this.tiny});

  Src.fromJson(Map<String, dynamic> json) {
    original = json['original'];
    large2x = json['large2x'];
    large = json['large'];
    medium = json['medium'];
    small = json['small'];
    portrait = json['portrait'];
    landscape = json['landscape'];
    tiny = json['tiny'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['original'] = this.original;
    data['large2x'] = this.large2x;
    data['large'] = this.large;
    data['medium'] = this.medium;
    data['small'] = this.small;
    data['portrait'] = this.portrait;
    data['landscape'] = this.landscape;
    data['tiny'] = this.tiny;
    return data;
  }
}
