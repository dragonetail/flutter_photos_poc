import 'dart:async';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';
import './device/device_asset_path.dart';
import './device/device_asset.dart';
import './device/device_grouped_assets.dart';

class XinyanyunFlutter {
  static const MethodChannel _channel =
      const MethodChannel('xinyanyun_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// android: WRITE_EXTERNAL_STORAGE  READ_EXTERNAL_STORAGE
  /// ios: photos permission
  static Future<bool> get requestPermissions async {
    var result = await _channel.invokeMethod("requestPermissions");
    return result;
  }

  static Future<List<DeviceAssetPath>> get deviceAssetPathes async {
    final List<dynamic> results =
        await _channel.invokeMethod('getDeviceAssetPathes');

    var assets = List<DeviceAssetPath>();
    for (var item in results) {
      var asset = DeviceAssetPath(
        id: item['id'],
        name: item['name'],
        hasVideo: item['hasVideo'],
      );

      assets.add(asset);
    }
    return assets;
  }

  static Future<List<DeviceGroupedAssets>> getDeviceAssets(
      String assetPathId) async {
    //Intl.defaultLocale = 'zh_CN';
    initializeDateFormatting();

    assert(assetPathId != null);
    final List<dynamic> results =
        await _channel.invokeMethod('getDeviceAssets', assetPathId);

    String preCreation = "-";
    var groupedAssets = List<DeviceGroupedAssets>();
    var assets = List<DeviceAsset>();
    for (var item in results) {
      var creationDate =
          DateTime.fromMillisecondsSinceEpoch(item['creationDate'] ?? 0);
      var asset = DeviceAsset(
        id: item['id'],
        creationDate: creationDate,
        pixelWidth: item['pixelWidth'],
        pixelHeight: item['pixelHeight'],
      );

      var formatter = DateFormat.yMMMMEEEEd();
      String creationDateStr = formatter.format(creationDate);
      if (preCreation == creationDateStr) {
        assets.add(asset);
      } else {
        preCreation = creationDateStr;
        assets = List<DeviceAsset>();
        assets.add(asset);
        groupedAssets.add(
            DeviceGroupedAssets(groupTitle: creationDateStr, assets: assets));
      }
    }
    return groupedAssets;
  }

  static Future<ByteData> requestThumbnail(
      String assetId, int width, int height,
      {int quality = 100}) async {
    assert(assetId != null);
    assert(width != null);
    assert(height != null);
    assert(quality != null);

    if (width < 0) {
      throw new ArgumentError.value(width, 'width cannot be negative');
    }

    if (height < 0) {
      throw new ArgumentError.value(height, 'height cannot be negative');
    }

    if (quality < 0 || quality > 100) {
      throw new ArgumentError.value(
          quality, 'quality should be in range 0-100');
    }

    String _thumbChannel = 'xinyanyun_flutter/image/$assetId.thumb';
    Completer<ByteData> completer = new Completer<ByteData>();
    BinaryMessages.setMessageHandler(_thumbChannel, (ByteData message) {
      completer.complete(message);
      BinaryMessages.setMessageHandler(_thumbChannel, null);
    });

    bool result = await _channel.invokeMethod(
        "requestThumbnail", <String, dynamic>{
      "assetId": assetId,
      "width": width,
      "height": height,
      "quality": quality
    });

    if (result) {
      return completer.future;
    } else {
      BinaryMessages.setMessageHandler(_thumbChannel, null);
      return Future.error("获取图片缩略图失败。");
    }
  }

  static Future<ByteData> requestOriginal(String assetId,
      {int quality = 100}) async {
    assert(assetId != null);
    assert(quality != null);

    if (quality < 0 || quality > 100) {
      throw new ArgumentError.value(
          quality, 'quality should be in range 0-100');
    }

    String _thumbChannel = 'xinyanyun_flutter/image/$assetId.original';
    Completer<ByteData> completer = new Completer<ByteData>();
    BinaryMessages.setMessageHandler(_thumbChannel, (ByteData message) {
      completer.complete(message);
      BinaryMessages.setMessageHandler(_thumbChannel, null);
    });

    bool result =
        await _channel.invokeMethod("requestOriginal", <String, dynamic>{
      "assetId": assetId,
      "quality": quality,
    });

    if (result) {
      return completer.future;
    } else {
      BinaryMessages.setMessageHandler(_thumbChannel, null);
      return Future.error("获取图片缩略图失败。");
    }
  }
}
