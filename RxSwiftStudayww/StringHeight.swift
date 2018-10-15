//
//  StringHeight.swift
//  RxSwiftStudayww
//
//  Created by 李锋 on 2018/10/10.
//  Copyright © 2018年 huifenqi. All rights reserved.
//

import Foundation
import UIKit

public extension String{
    
    /**
     *  计算字符串高度
     */
    public func getHeight(font: UIFont, width: CGFloat) -> CGFloat{
        
        let size = CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude)
        return self.getSize(font: font,
                            size: size,
                            lineBreakMode: NSLineBreakMode.byWordWrapping).height
    }
    
    /**
     *  计算字符串宽度
     */
    public func getWidth(font: UIFont, height: CGFloat) -> CGFloat{
        
        let size = CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: height)
        return self.getSize(font: font,
                            size: size,
                            lineBreakMode: NSLineBreakMode.byWordWrapping).width
    }
    
    /**
     *  计算字符串宽高
     */
    public func getSize(font: UIFont, size: CGSize, lineBreakMode: NSLineBreakMode) -> CGSize {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        
        let style = [NSAttributedString.Key.font:font,NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        
        let attributeText = NSAttributedString.init(string: self, attributes: style)
        
        let size = attributeText.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).size
        
        return size
    }
}
