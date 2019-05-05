import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:xinyanyun_flutter/xinyanyun_flutter.dart';

class ThumbnailImageItem extends StatelessWidget {
  static ImageLruCache<String> thumbnailCache = ImageLruCache<String>(500);

  final DeviceAsset asset;

  const ThumbnailImageItem({
    Key key,
    this.asset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String assetId = asset.id;
    Uint8List data = thumbnailCache.getData(assetId);
    if (data != null) {
      return _buildImageItem(context, data);
    }

    Future<ByteData> assetData =
        XinyanyunFlutter.requestThumbnail(asset.id, 200, 200);
    return FutureBuilder<ByteData>(
      future: assetData,
      builder: (BuildContext context, AsyncSnapshot<ByteData> snapshot) {
        var futureData = snapshot.data;
        if (snapshot.connectionState == ConnectionState.done &&
            futureData != null) {
          print(
              "requestThumbnail' result: $assetId, ${futureData.lengthInBytes}");
          Uint8List data = futureData.buffer.asUint8List();
          thumbnailCache.setData(assetId, data);
          return _buildImageItem(context, data);
        }
        return Center(
          child: Container(
            width: 30.0,
            height: 30.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.green),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageItem(BuildContext context, Uint8List data) {
    var image = Image.memory(
      data,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
    return image;
    // // FutureBuilder()
    // var badge = FutureBuilder<Duration>(
    //   future: entity.videoDuration,
    //   builder: (ctx, snapshot) {
    //     if (snapshot.hasData && snapshot != null) {
    //       var buildBadge =
    //           badgeDelegate?.buildBadge(context, entity.type, snapshot.data);
    //       if (buildBadge == null) {
    //         return Container();
    //       } else {
    //         return buildBadge;
    //       }
    //     } else {
    //       return Container();
    //     }
    //   },
    // );

    // return Stack(
    //   children: <Widget>[
    //     image,
    //     IgnorePointer(
    //       child: badge,
    //     ),
    //   ],
    // );
  }
}
