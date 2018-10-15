//
//  PhotoPreviewCellVM.swift
//  PhotoSelector
//
//  Created by 张玺 on 2018/2/5.
//

import UIKit
import Photos

class PhotoPreviewCellVM: NSObject {

    var asset: PHAsset?             // 图片
    
    class func getInstance(with asset: PHAsset) -> PhotoPreviewCellVM {
        let vm = PhotoPreviewCellVM()
        vm.asset = asset
        return vm
    }
    
}
