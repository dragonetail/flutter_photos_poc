
class DeviceAssetPath {
  /// android: content provider database _id column
  /// ios: collection localIdentifier
  String id;

  /// android: path name
  /// ios: photos collection name
  String name;

  bool _hasVideo;

  /// hasVideo
  set hasVideo(bool value) => _hasVideo = value;

  /// hasVideo
  bool get hasVideo => onlyVideo == true || _hasVideo == true;

  /// only have video
  bool onlyVideo = false;

  /// only have image
  bool onlyImage = false;

  /// contains all asset
  bool isAll = false;

  DeviceAssetPath({this.id, this.name, bool hasVideo}) : _hasVideo = hasVideo;

  // /// the image entity list
  // Future<List<AssetEntity>> get assetList => PhotoManager._getAssetList(this);

  // static var _all = AssetPathEntity()
  //   ..id = "allall--dfnsfkdfj2454AJJnfdkl"
  //   ..name = "Recent"
  //   ..isAll = true
  //   ..hasVideo = true;

  // static var _allVideo = AssetPathEntity()
  //   ..id = "videovideo--87yuhijn3cvx"
  //   ..name = "Recent"
  //   ..isAll = true
  //   ..onlyVideo = true;

  // static var _allImage = AssetPathEntity()
  //   ..id = "imageimage--89hdsinvosd"
  //   ..onlyImage = true
  //   ..isAll = true
  //   ..name = "Recent";

  // /// all asset path
  // static AssetPathEntity get all => _all;

  @override
  bool operator ==(other) {
    if (other is! DeviceAssetPath) {
      return false;
    }
    return this.id == other.id;
  }

  @override
  int get hashCode {
    return this.id.hashCode;
  }

  @override
  String toString() {
    return "AssetPathEntity{id:$id}";
  }
}
