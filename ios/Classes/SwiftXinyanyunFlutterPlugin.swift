import Flutter
import UIKit
import Photos

public class SwiftXinyanyunFlutterPlugin: NSObject, FlutterPlugin {
  var messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger;
    super.init();
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "xinyanyun_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftXinyanyunFlutterPlugin(messenger: registrar.messenger())
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
      break
    case "requestPermissions":
      PhotosHelper.requestPermissions(result)
      break
    case "getDeviceAssetPathes":
      PhotosHelper.getDeviceAssetPathes(result)
      break;
    case "getDeviceAssets":
      let assetPathId: String = call.arguments as! String
      PhotosHelper.getDeviceAssets(assetPathId, result)
      break;
    case "requestThumbnail":
      let arguments = call.arguments as! Dictionary<String, AnyObject>
      let assetId = arguments["assetId"] as! String
      let width = arguments["width"] as! Int
      let height = arguments["height"] as! Int
      let quality = arguments["quality"] as! Int

      PhotosHelper.requestThumbnail(assetId, width, height, quality, result, messenger)
      break;
    case "requestOriginal":
      let arguments = call.arguments as! Dictionary<String, AnyObject>
      let assetId = arguments["assetId"] as! String
      let quality = arguments["quality"] as! Int

      PhotosHelper.requestOriginal(assetId, quality, result, messenger)
      break;
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
