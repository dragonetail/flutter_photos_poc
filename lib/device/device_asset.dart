enum AssetType {
  other,
  image,
  video,
}

class DeviceAsset {
  /// android: full path
  /// ios: asset id
  String id;

  AssetType type;

  DateTime creationDate;

  int  pixelWidth;
  int  pixelHeight;

  DeviceAsset({this.id, this.creationDate, this.pixelWidth, this.pixelHeight});


  // /// isCloud
  // Future get isCloud async => PhotoManager._isCloudWithAsset(this);

  /// thumb path
  ///
  /// you can use File(path) to use
  // Future<File> get thumb async => PhotoManager._getThumbWithId(id);

  /// if you need upload file ,then you can use the file
  // Future<File> get file async => PhotoManager._getFullFileWithId(id);

  /// This contains all the EXIF information, but in contrast, `Image` widget may not be able to display pictures.
  ///
  /// Usually, you can use the [file] attribute
  // Future<File> get originFile async =>
  //     PhotoManager._getFullFileWithId(id, isOrigin: true);

  // /// the image's bytes ,
  // Future<Uint8List> get fullData => PhotoManager._getDataWithId(id);

  // /// thumb data , for display
  // Future<Uint8List> get thumbData => PhotoManager._getThumbDataWithId(id);

  // /// get thumb with size
  // Future<Uint8List> thumbDataWithSize(int width, int height) {
  //   return PhotoManager._getThumbDataWithId(id, width: width, height: height);
  // }

  // /// if not video ,duration is null
  // Future<Duration> get videoDuration async {
  //   if (type != AssetType.video) {
  //     return null;
  //   }
  //   return PhotoManager._getDurationWithId(id);
  // }

  // /// nullable, if the manager is null.
  // Future<Size> get size async {
  //   try {
  //     return await PhotoManager._getSizeWithId(id);
  //   } on Exception {
  //     return null;
  //   }
  // }

  // /// If the asset is deleted, return false.
  // Future<bool> get exists => PhotoManager._assetExistsWithId(id);

  @override
  int get hashCode {
    return id.hashCode;
  }

  @override
  bool operator ==(other) {
    if (other is! DeviceAsset) {
      return false;
    }
    return this.id == other.id;
  }

  @override
  String toString() {
    return "AssetEntity{id:$id}";
  }
}
