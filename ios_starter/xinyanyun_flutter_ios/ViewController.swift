//
//  ViewController.swift
//  xinyanyun_flutter_ios
//
//  Created by dragonetail on 2019/4/25.
//  Copyright © 2019 XinyanYun. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()


    let collections = getCollections()
    print(collections)

    collections.forEach { (collection) in
      let collectionId: String = String(describing: collection["id"] ?? "")

      let assets = getAssets(collectionId)
      print(assets)
    }
  }

  func getAssets(_ collectionId: String) -> [NSDictionary] {
    let fetchResult: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [collectionId], options: nil)
    guard fetchResult.count == 1 else {
      return [NSDictionary]()
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
    return assets
  }

  func getCollections() -> [NSDictionary] {
    //let types: [PHAssetCollectionType] = [.smartAlbum, .album, .moment]
    let types: [PHAssetCollectionType] = [.smartAlbum, .album]

    let fetchResults: [PHFetchResult<PHAssetCollection>] = types.map {
      return PHAssetCollection.fetchAssetCollections(with: $0, subtype: .any, options: nil)
    }

    var collections = [NSDictionary]()
    for fetchResult in fetchResults {
      //let fetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
      print(fetchResult.count)
      fetchResult.enumerateObjects({ (collection, _, _) in
        collections.append([
          "id": collection.localIdentifier,
          "name": collection.localizedTitle ?? "-",
          "hasVideo": false,
        ])
      })
    }

    return collections
  }
}

