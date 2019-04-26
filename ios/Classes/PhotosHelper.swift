import UIKit
import Photos
import Flutter

public class PhotosHelper: NSObject {
  static let manager = PHCachingImageManager() //PHImageManager.default()

  public static func requestPermissions(_ result: @escaping FlutterResult) {
    DispatchQueue.global(qos: .userInitiated).async {
      let authorizationStatus = PHPhotoLibrary.authorizationStatus()
      if authorizationStatus == .authorized {
        DispatchQueue.main.async {
          result(true)
        }
      } else {
        //print("Start to requestAuthorization...")
        PHPhotoLibrary.requestAuthorization({ status in
          //print("Result of requestAuthorization: \(status)")
          if status == .authorized {
            DispatchQueue.main.async {
              result(true)
            }
          } else {
            DispatchQueue.main.async {
              result(false)
            }
          }
        })
      }
    }
  }

  public static func getDeviceAssetPathes(_ result: @escaping FlutterResult) {
    DispatchQueue.global(qos: .userInitiated).async {
      //let types: [PHAssetCollectionType] = [.smartAlbum, .album, .moment]
      let types: [PHAssetCollectionType] = [.smartAlbum, .album]

      let fetchResults: [PHFetchResult<PHAssetCollection>] = types.map {
        return PHAssetCollection.fetchAssetCollections(with: $0, subtype: .any, options: nil)
      }

      var collections = [NSDictionary]()
      for fetchResult in fetchResults {
        fetchResult.enumerateObjects({ (collection, _, _) in
          collections.append([
            "id": collection.localIdentifier,
            "name": collection.localizedTitle ?? "-",
            "hasVideo": false,
          ])
        })
      }
      DispatchQueue.main.async {
        result(collections)
      }
    }
  }

  public static func getDeviceAssets(_ assetPathId: String, _ result: @escaping FlutterResult) {
    DispatchQueue.global(qos: .userInitiated).async {
      let fetchResult: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [assetPathId], options: nil)
      guard fetchResult.count == 1 else {
        DispatchQueue.main.async {
          result([NSDictionary]())
        }
        return
      }
      let collection = fetchResult.firstObject!

      var assets = [NSDictionary]()

      let fetchOptions = PHFetchOptions()
      fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
      let itemsFetchResult = PHAsset.fetchAssets(in: collection, options: fetchOptions)
      itemsFetchResult.enumerateObjects({ (asset, _, _) in
        assets.append([
          "id": asset.localIdentifier,
          "creationDate": Int((asset.creationDate?.timeIntervalSince1970 ?? 0) * 1000),
          "pixelWidth": asset.pixelWidth,
          "pixelHeight": asset.pixelHeight,

          //      @available(iOS 11.0, *)
          //      open var playbackStyle: PHAsset.PlaybackStyle { get }
          //      open var mediaType: PHAssetMediaType { get }
          //      open var mediaSubtypes: PHAssetMediaSubtype { get }
          //      open var creationDate: Date? { get }
          //      open var modificationDate: Date? { get }
          //      open var location: CLLocation? { get }
          //      open var duration: TimeInterval { get }
          //      // a hidden asset will be excluded from moment collections, but may still be included in other smart or regular album collections
          //      open var isHidden: Bool { get }
          //      open var isFavorite: Bool { get }
          //      open var burstIdentifier: String? { get }
          //      open var burstSelectionTypes: PHAssetBurstSelectionType { get }
          //      open var representsBurst: Bool { get }
          //      open var sourceType: PHAssetSourceType { get }
        ])
      })
      DispatchQueue.main.async {
        result(assets)
      }
    }
  }

  public static func requestThumbnail(_ assetId: String, _ width: Int, _ height: Int, _ quality: Int, _ result: @escaping FlutterResult, _ messenger: FlutterBinaryMessenger) {
    requestImage(assetId, CGSize(width: width, height: height), quality, "thumb", result, messenger)
  }

  public static func requestOriginal(_ assetId: String, _ quality: Int, _ result: @escaping FlutterResult, _ messenger: FlutterBinaryMessenger) {
    requestImage(assetId, PHImageManagerMaximumSize, quality, "original", result, messenger)
  }

  fileprivate static func requestImage(_ assetId: String, _ targetSize: CGSize, _ quality: Int, _ dataBackChannelSuffix: String, _ result: @escaping FlutterResult, _ messenger: FlutterBinaryMessenger) {
    DispatchQueue.global(qos: .userInitiated).async {
      let options = PHImageRequestOptions()

      options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
      options.isSynchronous = false
      options.isNetworkAccessAllowed = true
      options.resizeMode = .fast

      let fetchResult: PHFetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
      guard fetchResult.count == 1 else {
        DispatchQueue.main.async {
          result(false)
        }
        return
      }

      let asset: PHAsset = fetchResult.firstObject!;

      //TODO
      //manager.cancelImageRequest(<#T##requestID: PHImageRequestID##PHImageRequestID#>)
      
//      manager.requestImageData(for: <#T##PHAsset#>, options: <#T##PHImageRequestOptions?#>, resultHandler: <#T##(Data?, String?, UIImage.Orientation, [AnyHashable : Any]?) -> Void#>)
//
//      manager.requestImage(for: <#T##PHAsset#>, targetSize: <#T##CGSize#>, contentMode: <#T##PHImageContentMode#>, options: <#T##PHImageRequestOptions?#>, resultHandler: <#T##(UIImage?, [AnyHashable : Any]?) -> Void#>)
      
      
      let requestId: PHImageRequestID = manager.requestImage(
        for: asset,
        targetSize: targetSize,
        contentMode: PHImageContentMode.aspectFill,
        options: options,
        resultHandler: {
          (image: UIImage?, info) in
          messenger.send(onChannel: "xinyanyun_flutter/image/\(assetId).\(dataBackChannelSuffix)", message:
            image?.jpegData(compressionQuality: CGFloat(quality / 100)))
        })

      if(PHInvalidImageRequestID != requestId) {
        DispatchQueue.main.async {
          result(true)
        }
      } else {
        DispatchQueue.main.async {
          result(false)
        }
      }
    }
  }

}
