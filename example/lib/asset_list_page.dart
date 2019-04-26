import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:xinyanyun_flutter/xinyanyun_flutter.dart';

class AssetListPage extends StatefulWidget {
  static const route = '/assetList';

  @override
  State<StatefulWidget> createState() {
    return new _AssetListState();
  }
}

class _AssetListState extends State<AssetListPage> {
  List<DeviceAsset> _deviceAssetes = List<DeviceAsset>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();
  }

  void _loadAssetes(BuildContext context) async {
    final String assetPathId = ModalRoute.of(context).settings.arguments;
    _deviceAssetes = await XinyanyunFlutter.getDeviceAssets(assetPathId);

    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadAssetes(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Asset'),
      ),
      body: _buildAssetList(),
    );
  }

  Widget _buildAssetList() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        crossAxisSpacing: 0.5,
        mainAxisSpacing: 0.5,
      ),
      itemBuilder: (context, index) => _buildItem(_deviceAssetes[index]),
      itemCount: _deviceAssetes.length,
    );
  }

  Widget _buildItem(DeviceAsset asset) {
    Future<ByteData> assetData =
        XinyanyunFlutter.requestThumbnail(asset.id, 200, 200);

    return FutureBuilder<ByteData>(
        // initialData: null,
        future: assetData,
        builder: (contect, snapshot) {
          if (snapshot.data != null) {
            return Image.memory(
              snapshot.data.buffer.asUint8List(),
              fit: BoxFit.cover,
              gaplessPlayback: true,
            );
          } else {
            return Container();
          }
        });
  }
}
