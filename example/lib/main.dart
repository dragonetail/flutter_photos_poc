import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:xinyanyun_flutter/xinyanyun_flutter.dart';
import './asset_path_list_page.dart';
import './asset_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await XinyanyunFlutter.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });

    bool hasPermission = await XinyanyunFlutter.requestPermissions;
    print(hasPermission);

    List<DeviceAssetPath> deviceAssetPathes =
        await XinyanyunFlutter.deviceAssetPathes;
    print(deviceAssetPathes);

    for (var assetPath in deviceAssetPathes) {
      List<DeviceAsset> deviceAssets =
          await XinyanyunFlutter.getDeviceAssets(assetPath.id);
      print(deviceAssets);

      if (deviceAssets.isNotEmpty) {
        DeviceAsset asset = deviceAssets.first;
        if (asset != null) {
          Future<ByteData> assetData =
              XinyanyunFlutter.requestThumbnail(asset.id, 100, 100);
          assetData.whenComplete(() {
            print("OK");
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => AssetPathListPage(),
        AssetPathListPage.route: (context) => AssetPathListPage(),
        AssetListPage.route: (context) => AssetListPage(),
      },
    );
  }
}
