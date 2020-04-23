class Wallpaper {
  String photographer;
  String photographerUrl;
  int photographerId;
  Src src;

  Wallpaper(
      {this.photographer, this.photographerUrl, this.photographerId, this.src});

  Wallpaper.fromJson(Map<String, dynamic> json) {
    photographer = json['photographer'];
    photographerUrl = json['photographer_url'];
    photographerId = json['photographer_id'];
    src = json['src'] != null ? new Src.fromJson(json['src']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photographer'] = this.photographer;
    data['photographer_url'] = this.photographerUrl;
    data['photographer_id'] = this.photographerId;
    if (this.src != null) {
      data['src'] = this.src.toJson();
    }
    return data;
  }
}

class Src {
  String original;
  String small;
  String large;
  String portrait;
  String landscape;

  Src({this.original, this.small, this.large, this.portrait, this.landscape});

  Src.fromJson(Map<String, dynamic> json) {
    original = json['original'];
    small = json['small'];
    large = json['large'];
    portrait = json['portrait'];
    landscape = json['landscape'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['original'] = this.original;
    data['small'] = this.small;
    data['large'] = this.large;
    data['portrait'] = this.portrait;
    data['landscape'] = this.landscape;
    return data;
  }
}
