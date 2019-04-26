import 'package:flutter/material.dart';
import 'package:xinyanyun_flutter/xinyanyun_flutter.dart';
import './asset_list_page.dart';

class AssetPathListPage extends StatefulWidget {
  static const route = '/assetPathList';

  @override
  State<StatefulWidget> createState() {
    return new _AssetPathListState();
  }
}

class _AssetPathListState extends State<AssetPathListPage> {
  List<DeviceAssetPath> _deviceAssetPathes = List<DeviceAssetPath>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();
    _loadAssetPathes();
  }

  void _loadAssetPathes() async {
    _deviceAssetPathes = await XinyanyunFlutter.deviceAssetPathes;

    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Asset Path'),
      ),
      body: _buildAssetPathList(),
    );
  }

  Widget _buildAssetPathList() {
    return new ListView.builder(
      itemCount: _deviceAssetPathes.length * 2,
      padding: const EdgeInsets.all(10.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();
        final index = i ~/ 2;
        return _buildRow(_deviceAssetPathes[index]);
      },
    );
  }

  Widget _buildRow(DeviceAssetPath path) {
    return new ListTile(
        title: new Text(path.name, style: _biggerFont),
        subtitle: new Text(path.id),
        onTap: () {
          Navigator.pushNamed(context, AssetListPage.route, arguments: path.id);
        });
  }
}
