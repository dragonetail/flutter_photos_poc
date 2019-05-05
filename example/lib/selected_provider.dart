import 'dart:async';
import 'package:xinyanyun_flutter/xinyanyun_flutter.dart';

abstract class SelectedProvider {
  List<DeviceAsset> selectedList = [];

  int get selectedCount => selectedList.length;

  bool containsEntity(DeviceAsset asset) {
    return selectedList.contains(asset);
  }

  int indexOfSelected(DeviceAsset asset) {
    return selectedList.indexOf(asset);
  }

  bool isUpperLimit();

  bool addSelectEntity(DeviceAsset asset) {
    if (containsEntity(asset)) {
      return false;
    }
    if (isUpperLimit() == true) {
      return false;
    }
    selectedList.add(asset);
    return true;
  }

  bool removeSelectEntity(DeviceAsset entity) {
    return selectedList.remove(entity);
  }

  void compareAndRemoveEntities(List<DeviceAsset> previewSelectedList) {
    var srcList = List.of(selectedList);
    selectedList.clear();
    srcList.forEach((entity) {
      if (previewSelectedList.contains(entity)) {
        selectedList.add(entity);
      }
    });
  }

  void sure();

  Future checkPickImageEntity() async {
    List<DeviceAsset> notExistsList = [];
    for (var asset in selectedList) {
      //TODO
      // var exists = await asset.exists;
      // if (!exists) {
      notExistsList.add(asset);
      //}
    }

    selectedList.removeWhere((e) {
      return notExistsList.contains(e);
    });
  }
}
