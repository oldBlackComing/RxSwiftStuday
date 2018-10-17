//
//  CustomerTranslation.swift
//  ImagePickerDemo
//
//  Created by 李锋 on 2018/10/16.
//  Copyright © 2018年 huifenqi. All rights reserved.
//

import Foundation
import UIKit

protocol DismissProTocol: class {
    
    /// 谁
    ///
    /// - Returns: 即将
    func protocolStartView(t: Int?) -> UIView
    
    /// 从哪来
    ///
    /// - Returns: 从哪来
    func protocalStartPosition(t: Int?) -> CGRect
    
    /// 到哪去
    ///
    /// - Returns: 到哪去
    
    /// 到哪frame
    ///
    /// - Returns: 到哪
    func protocolEndFrame(t: Int?) -> CGRect
    
}

extension DismissProTocol {
    func protocolEndFrame(t: Int?) -> CGRect{
        return CGRect.zero
    }

}

protocol AnimationProTocol: class {
    
    /// 谁
    ///
    /// - Returns: 即将
    func protocolStartView(t: Int?) -> UIView
    
    /// 从哪来
    ///
    /// - Returns: 从哪来
    func protocalStartPosition(t: Int?) -> CGRect
    
    /// 到哪去
    ///
    /// - Returns: 到哪去
    
    /// 到哪frame
    ///
    /// - Returns: 到哪
    func protocolEndFrame(t: Int?) -> CGRect
    
}
class CustomerTranslation:NSObject, UIViewControllerTransitioningDelegate {
    
    weak var preDelegate: AnimationProTocol?
    
    weak var disDelegate: DismissProTocol?
    
    
    /// 所选 view 的 tag 或者其它标记 方便获取
    var t: Int?
    
    var isPresent: Bool = false
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
}


extension CustomerTranslation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            animationFromPresent(transitionContext: transitionContext)
        }else{
            animationFromDisMIss(transitionContext: transitionContext)
        }
    }
    
    func animationFromPresent(transitionContext: UIViewControllerContextTransitioning) {
        let presentView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        if let p = presentView {
            transitionContext.containerView.addSubview(p)
        }
        
        let view = preDelegate?.protocolStartView(t: t)
        let startPosition = preDelegate?.protocalStartPosition(t: t)
        let endFrame = preDelegate?.protocolEndFrame(t: t)
        
        
        guard let `view1` = view, let `startPosition1` = startPosition, let `endFrame1` = endFrame else {
            return
        }
        
        transitionContext.containerView.addSubview(view1)

        view1.frame = startPosition1
        transitionContext.containerView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        presentView?.alpha = 0

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            view1.frame = endFrame1
            transitionContext.containerView.backgroundColor = UIColor.black.withAlphaComponent(1)
        }) { (com) in
            if com {
                presentView?.alpha = 1
                view1.removeFromSuperview()
                transitionContext.containerView.backgroundColor = .clear
            }
            transitionContext.completeTransition(true)
        }
        
    }

    func animationFromDisMIss(transitionContext: UIViewControllerContextTransitioning) {
        let disView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        disView?.removeFromSuperview()
        let view = disDelegate?.protocolStartView(t: t)
        let startPosition = disDelegate?.protocalStartPosition(t: t)
        let endFrame = preDelegate?.protocalStartPosition(t:t)
        
        guard let `view1` = view, let `startPosition1` = startPosition, let `endFrame1` = endFrame else {
            return
        }
        transitionContext.containerView.addSubview(view1)
        view1.frame = startPosition1
        transitionContext.containerView.backgroundColor = UIColor.black
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            view1.frame = endFrame1
            transitionContext.containerView.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) { (com) in
            if com {
            }
            transitionContext.completeTransition(com)
        }
    }
    
//    UIView *dismissView = [transitionContext viewForKey:UITransitionContextFromViewKey];
//    [dismissView removeFromSuperview];
    
//    UIImageView *imageView = [self.animationDismissDelegate imageViewForDismissView];
//    [transitionContext.containerView addSubview:imageView];
//    NSInteger index = [self.animationDismissDelegate indexForDismissView];
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//    imageView.frame = [self.animationPresentDelegate startRect:index];
//    } completion:^(BOOL finished) {
//    [transitionContext completeTransition:YES];
//    }];
}
