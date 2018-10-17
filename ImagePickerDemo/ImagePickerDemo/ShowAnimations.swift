//
//  ShowAnimations.swift
//  ImagePickerDemo
//
//  Created by huifenqi on 2018/10/17.
//  Copyright © 2018 huifenqi. All rights reserved.
//

import Foundation
import UIKit

fileprivate let str = "sadasdasdasdasd"

class ShowAnimations: NSObject {
    static let share: ShowAnimations = ShowAnimations()
    private var v: UIView?
    
    private var isShow:Bool = true
    
    var call:((_ stop: Bool, _ show: Bool)-> Void)?
    
    typealias aa = (x: CGFloat, y: CGFloat, z: CGFloat)
    private lazy var caAni: CAKeyframeAnimation = {
        let caK: CAKeyframeAnimation = CAKeyframeAnimation()
        caK.keyPath = "transform"
        caK.delegate = self
        caK.fillMode = CAMediaTimingFillMode.forwards
        return caK
    }()
    
    var aarr:Array<CATransform3D> = Array()
    
    func show(show: Bool, view: UIView?) {
        v = view
        
        aarr.removeAll()
        if show {
            //            view?.layer.transform = CATransform3DMakeScale(0.4, 0.4, 0.4)
            
            showAni(View: view)
        }else{
            hidAni()
        }
        caAni.values = aarr
        caAni.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        caAni.fillMode = CAMediaTimingFillMode.forwards
        caAni.isRemovedOnCompletion = false
        view?.layer.add(caAni, forKey: str)
    }
    
    func showAni(View: UIView?) {
        isShow = true
        caAni.duration = 0.2
        aarr.append(a3D(tr: (0.5, 0.5, 0.5)))
        aarr.append(a3D(tr: (0.7, 0.7, 0.7)))
        aarr.append(a3D(tr: (0.8, 0.8, 0.8)))
        aarr.append(a3D(tr: (1.0, 1.0, 1.0)))
        aarr.append(a3D(tr: (0.9, 0.9, 0.9)))
        aarr.append(a3D(tr: (1.0, 1.0, 1.0)))
        
    }
    
    private func hidAni() {
        isShow = false
        caAni.duration = 0.2
        aarr.append(a3D(tr: (1.0, 1.0, 1.0)))
        aarr.append(a3D(tr: (0.9, 0.9, 0.9)))
        aarr.append(a3D(tr: (0.8, 0.8, 0.8)))
        aarr.append(a3D(tr: (0.7, 0.7, 0.7)))
        aarr.append(a3D(tr: (0.6, 0.6, 0.6)))
        aarr.append(a3D(tr: (0.5, 0.5, 0.5)))
        aarr.append(a3D(tr: (0.4, 0.4, 0.4)))
        aarr.append(a3D(tr: (0.3, 0.3, 0.3)))
        aarr.append(a3D(tr: (0.2, 0.2, 0.2)))
        
    }
    func a3D(tr: aa) -> CATransform3D {
        return CATransform3DMakeScale(tr.x, tr.y, tr.z)
    }
}

extension ShowAnimations: CAAnimationDelegate{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        call?(flag, isShow)
        if isShow {
            v?.layer.transform = CATransform3DMakeScale(1, 1, 1)
            
        }else{
            v?.layer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2)
        }
    }
}
