//
//  HZFFont.swift
//  RxSwiftStudayww
//
//  Created by 李锋 on 2018/10/10.
//  Copyright © 2018年 huifenqi. All rights reserved.
//

import Foundation
import UIKit

enum HZFFont: String {
    case DINBold        = "DINAlternate-Bold"   ///<APP中数字字体
    
    case PFUltralight   = "PingFangSC-Ultralight"
    case PFLight        = "PingFangSC-Light"
    case PFThin         = "PingFangSC-Thin"
    case PFRegular      = "PingFangSC-Regular"
    case PFMedium       = "PingFangSC-Medium"
    case PFSemibold     = "PingFangSC-Semibold"

    func fontSize(size: CGFloat) -> UIFont? {
        return UIFont.init(name: self.rawValue, size: size)
    }
}
