//
//  PhotoCollectionViewController.swift
//  ImagePickerDemo
//
//  Created by huifenqi on 2018/10/15.
//  Copyright © 2018 huifenqi. All rights reserved.
//

import UIKit
import Photos

class PhotoTableViewCellVM: NSObject {

    var asset: PHAsset?                 // 图片
    var albumTitle: String = "albumTitle"         // 专辑名称
    var albumNumTitle: String = "albumNumTitle"      // 专辑内照片数量
    
    let imageSize: CGFloat = 40
    
    class func getInstance(with model: PhotoModel) -> PhotoTableViewCellVM {
        let vm = PhotoTableViewCellVM()
        vm.albumTitle = model.name
        vm.albumNumTitle = "（\(model.fetchResult.count)）"
        
        if model.fetchResult.count > 0 {
            if let firstImageAsset = model.fetchResult[0] as? PHAsset {
                vm.asset = firstImageAsset
//                let retinaMultiplier = UIScreen.main.scale
//                let realSize = vm.imageSize * retinaMultiplier
//                let size = CGSize(width:realSize, height: realSize)
                
//                let imageOptions = PHImageRequestOptions()
//                imageOptions.resizeMode = .exact
//
//                PHImageManager.default().requestImage(for: firstImageAsset, targetSize: size, contentMode: .aspectFill, options: imageOptions, resultHandler: {
//                    [weak vm](image, info) -> Void in
//                    vm?.image = image
//                })
            }
        }
        
        return vm
    }
}
