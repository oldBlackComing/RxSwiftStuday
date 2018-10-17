//
//  PrivacyAgreementViewController.swift
//  RxSwiftStudayww
//
//  Created by 李锋 on 2018/10/10.
//  Copyright © 2018年 huifenqi. All rights reserved.
//

import UIKit

let scr = UIScreen.main.bounds

let thank: String = "感谢您下载会找房！当您开始使用本软件时，我们可能会对您的部分个人信息进行收集、使用和共享。请您仔细阅读《会找房隐私政策》并确定我们对您个人信息的处理规则，包括："
let incloud: String = "我们如何收集您的个人信息\n我们如何保留和使用您的个人信息\n我们如何共享、转让、公开您的个人信息\n我们如何保护您的个人信息\n我们如何使用Cookie和同类技术\n未成年人信息的保护"

class PrivacyAgreementViewController: UIViewController {

    private var baseView: UIView = UIView()
    
    
    /// 上面灰色的地方
    private var topBackImgView: UIImageView = {
        let i: UIImageView = UIImageView()
        i.backgroundColor = UIColor.gray
        return i
    }()
    
    /// logo 视图
    private var iconImageView: UIImageView = {
        let i: UIImageView = UIImageView()
        return i
    }()
    
    
    /// 会找房隐私政策 title
    private var titleLabel: UILabel = {
        let l: UILabel = UILabel()
        l.font = HZFFont.PFMedium.fontSize(size: 9)
        let y = 132 * UIScreen.e_ratio_375

        l.frame = CGRect.init(x: 0, y: y, width: UIScreen.e_width, height: 12.5)

        return l
    }()
    
    /// 文字描述
    private var thanksLabel: UILabel = {
        let l: UILabel = UILabel()
        l.font = HZFFont.PFMedium.fontSize(size: 7)
        let y = 156.5 * UIScreen.e_ratio_375

        l.frame = CGRect.init(x: 0, y: y, width: UIScreen.e_width, height: 10)

        return l
    }()
    
    /// z政策说明
    private var incloudLabel: UILabel = {
        let l: UILabel = UILabel()
        l.font = HZFFont.PFMedium.fontSize(size: 6)
        
//        l.frame = CGRect.init(x: 0, y: 10, width: UIScreen.e_width, height: 10)

        return l
    }()
    
    private lazy var tipsTextView: UITextView = {[unowned self] in
        let t: UITextView = UITextView()
        t.isEditable = false
//        t.delegate = self
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let heightTop = 63.5 * UIScreen.e_ratio_375
        let heig = 62 * UIScreen.e_ratio_375

//        topBackImgView.snp.makeConstraints { (make) in
//            make.width.equalToSuperView()
//            make.left.equalToSuperView()
//            make.height.equalTo(heightTop)
//            make.top.equalToSuperView()
//        }
//
//        iconImageView.snp.makeConstraints { (make) in
//            make.width.equalToSuperView()
//            make.left.equalToSuperView()
//            make.top.equalTo(topBackImgView.snp.bottom)
//            make.height.equalTo(heig)
//        }
//
//        titleLabel.snp.makeConstraints { (make) in
//            make.width.equalToSuperView()
//            make.left.equalToSuperView()
//            make.top.equalTo(iconImageView.snp.bottom).offset(6.5 * UIScreen.e_ratio_375)
//            make.height.equalTo(12.5)
//        }
//
//        thanksLabel.snp.makeConstraints { (make) in
//            make.width.equalToSuperView()
//            make.left.equalToSuperView().offset(9)
//            make.right.equalToSuperView().offset(-9)
//            make.top.equalTo(titleLabel.snp.bottom).offset(12 * UIScreen.e_ratio_375)
//        }
//        
//        incloudLabel.snp.makeConstraints { (make) in
//            make.width.equalToSuperView()
//            make.left.equalToSuperView().offset(9)
//            make.right.equalToSuperView().offset(-9)
//            make.top.equalTo(thanksLabel.snp.bottom).offset(10 * UIScreen.e_ratio_375)
//        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

public extension UIView {
    public func e_addSubviews(_ subviews: [UIView]) {
        subviews.forEach({self.addSubview($0)})
    }
}
public extension UIScreen {
    
    /**
     *  屏幕size
     */
    public static var e_size : CGSize { return self.main.bounds.size }
    
    /**
     *  屏幕宽度
     */
    public static var e_width : CGFloat { return self.e_size.width }
    
    /**
     *  屏幕高度
     */
    public static var e_height : CGFloat { return self.e_size.height }
    
    /**
     *  当前屏幕宽度与设计图比例系数（宽度375标准）
     */
    public static var e_ratio_375 : CGFloat { return self.e_width / 375.0 }
    
    /**
     *  当前屏幕宽度与设计图比例系数（宽度320标准）
     */
    public static var e_ratio_320 : CGFloat { return self.e_width / 320.0 }
    
    /// 屏幕缩放比
    public static var e_scale: CGFloat { return self.main.scale}
    
}
