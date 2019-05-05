import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:xinyanyun_flutter/xinyanyun_flutter.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import './thumbnail_image_item.dart';
import './selected_provider.dart';

class AssetListPage extends StatefulWidget {
  static const route = '/assetList';

  @override
  State<StatefulWidget> createState() {
    return _AssetListState();
  }
}

class _AssetListState extends State<AssetListPage> with SelectedProvider {
  List<DeviceGroupedAssets> _gourpedAssets = List<DeviceGroupedAssets>();
  ScrollController _scrollController = ScrollController();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();
  }

  bool loaded = false;
  void _loadAssetes(BuildContext context) async {
    if (loaded) {
      return;
    }
    loaded = true;

    final String assetPathId = ModalRoute.of(context).settings.arguments;
    _gourpedAssets = await XinyanyunFlutter.getDeviceAssets(assetPathId);

    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadAssetes(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Photo Asset'),
      // ),
      // body: _buildAssetList(),
      body: Builder(builder: (BuildContext context) {
        return CustomScrollView(
          slivers: _buildSlivers(context),
        );
      }),
    );
  }

  // Widget _buildAssetList() {
  //   var gridView = GridView.builder(
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 4,
  //       childAspectRatio: 1,
  //       crossAxisSpacing: 0.5,
  //       mainAxisSpacing: 0.5,
  //     ),
  //     itemBuilder: _buildItem,
  //     itemCount: _gourpedAssets.length,
  //     controller: _scrollController,
  //   );
  //   return GestureDetector(
  //     onScaleStart: (ScaleStartDetails details) {
  //       print("onScaleStart: $details");
  //     },
  //     onScaleUpdate: (ScaleUpdateDetails details) {
  //       print(
  //           "onScaleUpdate: $details ${details.focalPoint.dx} ${_scrollController.offset}");
  //       // details.focalPoint.dx
  //     },
  //     onScaleEnd: (ScaleEndDetails details) {
  //       print("onScaleEnd: $details");
  //     },
  //     child: gridView,
  //   );
  // }

  List<Widget> _buildSlivers(BuildContext context) {
    List<Widget> slivers = List<Widget>();
     slivers.add(SliverAppBar(
      backgroundColor: Colors.blue.withOpacity(0.5),
      title: Text('Photo Asset'),
      floating: true,
      pinned: false,
    ));
    slivers.addAll(_buildGrids(context));
    return slivers;
  }

  List<Widget> _buildGrids(BuildContext context) {
    return List.generate(_gourpedAssets.length, (section) {
      return SliverStickyHeader(
        header: _buildHeader(section),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, crossAxisSpacing: 2.0, mainAxisSpacing: 2.0),
          delegate: SliverChildBuilderDelegate(
            (context, row) => GestureDetector(
                  onScaleStart: (ScaleStartDetails details) {
                    print("onScaleStart: $details");
                  },
                  onScaleUpdate: (ScaleUpdateDetails details) {
                    print(
                        "onScaleUpdate: $details ${details.focalPoint.dx} ${_scrollController.offset}");
                    // details.focalPoint.dx
                  },
                  onScaleEnd: (ScaleEndDetails details) {
                    print("onScaleEnd: $details");
                  },
                  child: _buildItem(context, section, row),
                ),
            childCount: _gourpedAssets[section].assets.length,
          ),
        ),
      );
    });
  }

  Widget _buildHeader(int section) {
    return Container(
      height: 48.0,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.centerLeft,
      child: Text(
        _gourpedAssets[section].groupTitle,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int section, int row) {
    var assets = _gourpedAssets[section].assets;
    DeviceAsset asset = assets[row];
    print("requestThumbnail: $row, ${asset.id}");

    return RepaintBoundary(
      child: GridTile(
        child: Card(
          margin: EdgeInsets.all(0.0),
          child: GestureDetector(
            onTap: () => _onItemClick(asset, section, row),
            child: Stack(
              children: <Widget>[
                ThumbnailImageItem(
                  asset: asset,
                ),
                _buildMask(containsEntity(asset)),
                _buildSelected(asset),
              ],
            ),
          ),
        ),
        footer: Container(
          color: Colors.white.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Grid tile $section:$row',
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  _buildMask(bool showMask) {
    return IgnorePointer(
      child: AnimatedContainer(
        color: showMask ? Colors.black.withOpacity(0.5) : Colors.transparent,
        duration: Duration(milliseconds: 300),
      ),
    );
  }

  Widget _buildSelected(DeviceAsset asset) {
    var currentSelected = containsEntity(asset);
    return Positioned(
      right: 0.0,
      width: 36.0,
      height: 36.0,
      child: GestureDetector(
        onTap: () {
          changeCheck(!currentSelected, asset);
        },
        behavior: HitTestBehavior.translucent,
        child: _buildText(asset),
      ),
    );
  }

  Widget _buildText(DeviceAsset asset) {
    var isSelected = containsEntity(asset);
    Widget child;
    BoxDecoration decoration;
    if (isSelected) {
      child = Text(
        (indexOfSelected(asset) + 1).toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12.0,
          // color: options.textColor,
          color: Colors.black87,
        ),
      );
      // decoration = BoxDecoration(color: themeColor);
      decoration = BoxDecoration(color: Colors.green);
    } else {
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(1.0),
        border: Border.all(
          //  color: themeColor,
          color: Colors.green,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: decoration,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  void changeCheck(bool value, DeviceAsset asset) {
    if (value) {
      addSelectEntity(asset);
    } else {
      removeSelectEntity(asset);
    }
    setState(() {});
  }

  void _onItemClick(DeviceAsset asset, int section, int row) {
    // var result = PhotoPreviewResult();
    // isPushed = true;
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (ctx) {
    //       return ConfigProvider(
    //         provider: ConfigProvider.of(context).provider,
    //         options: options,
    //         child: PhotoPreviewPage(
    //           selectedProvider: this,
    //           list: List.of(list),
    //           initIndex: index,
    //           changeProviderOnCheckChange: true,
    //           result: result,
    //         ),
    //       );
    //     },
    //   ),
    // ).then((v) {
    //   if (handlePreviewResult(v)) {
    //     Navigator.pop(context, v);
    //     return;
    //   }
    //   isPushed = false;
    //   setState(() {});
    // });
  }

  @override
  bool isUpperLimit() {
    // var result = selectedCount == options.maxSelected;
    // if (result) _showTip(i18nProvider.getMaxTipText(options));
    // return result;
    return false;
  }

  @override
  void sure() {
    //widget.onClose?.call(selectedList);
  }
}
