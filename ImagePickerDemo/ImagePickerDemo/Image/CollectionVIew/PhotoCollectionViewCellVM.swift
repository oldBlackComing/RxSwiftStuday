//
//  PhotoSelectorViewController.swift
//  ImagePickerDemo
//
//  Created by huifenqi on 2018/10/15.
//  Copyright © 2018 huifenqi. All rights reserved.
//

import UIKit
import Photos

class PhotoCollectionViewCellVM: NSObject {

    var selected: Bool = false      // 是否被选中
    var index: Int = -1             // 被选中的顺序
    var isFirst: Bool = false       // 是否是第一个
    var isCovered: Bool = false     // 是否遮住
    
    var asset: PHAsset?             // 图片信息
    
    class func getInstance(with asset: PHAsset?, isFirst: Bool = false) -> PhotoCollectionViewCellVM {
        let vm = PhotoCollectionViewCellVM()
        vm.asset = asset
        vm.isFirst = isFirst
        return vm
    }
    
}
