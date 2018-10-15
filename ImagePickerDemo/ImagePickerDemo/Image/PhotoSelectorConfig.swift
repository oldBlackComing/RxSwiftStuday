//
//  PhotoCollectionViewController.swift
//  ImagePickerDemo
//
//  Created by huifenqi on 2018/10/15.
//  Copyright © 2018 huifenqi. All rights reserved.
//

import UIKit
import UIKit
//可以手动改变的常量
class PhotoSelectorConfig: NSObject {
    static let ScreenWidth = UIScreen.main.bounds.width
    static let ScreenHeight = UIScreen.main.bounds.height
    //tableView的RowHeight
    static let AlbumTableViewCellHeight: CGFloat = 90.0
    // 左右间距 内间距
    static let MinimumInteritemSpacing: CGFloat = 4
    
    /// 是否需要相机
    static var needCamrea: Bool = false
    // image total per line
    static let ColNumber: CGFloat = 4
    
    
    static let PreviewImageMaxFetchMaxWidth:CGFloat = 600
    
    
    static let ButtonDone = "完成"
    
    
    static let ButtonConfirmTitle  = "确定"
    
    
    static let ErrorImageMaxSelect = "图片选择最多超过不能超过#张"
    
    // preview view bar background color
    static let PreviewBarBackgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
    
    // button green tin color
    static let GreenTinColor = UIColor(red: 7/255, green: 179/255, blue: 20/255, alpha: 1)
    
    //选择器单元格边长
    static let selectWidth = 80
}
