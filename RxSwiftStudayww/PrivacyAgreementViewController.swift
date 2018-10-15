//
//  PrivacyAgreementViewController.swift
//  RxSwiftStudayww
//
//  Created by 李锋 on 2018/10/10.
//  Copyright © 2018年 huifenqi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let scr = UIScreen.main.bounds


/// titleLabel 文字
fileprivate let titleS: String = "会找房"

/// thanksLabel 文字
fileprivate let thank: String = "感谢您下载会找房！当您开始使用本软件时，我们可能会对您的部分个人信息进行收集、使用和共享。请您仔细阅读《会找房隐私政策》并确定我们对您个人信息的处理规则，包括："

/// incloud 文字
fileprivate let incloud: String = "我们如何收集您的个人信息\n我们如何保留和使用您的个人信息\n我们如何共享、转让、公开您的个人信息\n我们如何保护您的个人信息\n我们如何使用Cookie和同类技术\n未成年人信息的保护"


/// tips 文字
fileprivate let tipsPre = "如您同意"
fileprivate let tipsMidd = "《会找房隐私政策》"
fileprivate let tipsLast = "请点击“同意”开始使用我们的产品和服务，我们尽全力保护您的个人信息安全。"

fileprivate let tips = tipsPre + tipsMidd + tipsLast

class privacyCell: UITableViewCell {
    var attributedText: NSMutableAttributedString = NSMutableAttributedString.init()
    
    private var baseView: UIView = UIView()
    
    
    /// 上面灰色的地方
    private var topBackImgView: UIImageView = {
        let i: UIImageView = UIImageView()
        i.backgroundColor = UIColor.red
        return i
    }()
    
    /// logo 视图
    private var iconImageView: UIImageView = {
        let i: UIImageView = UIImageView()
        i.backgroundColor = UIColor.e_random
        return i
    }()
    
    
    /// 会找房隐私政策 title
    private var titleLabel: UILabel = {
        let l: UILabel = UILabel()
        l.textAlignment = .center
        l.backgroundColor = UIColor.e_random
        l.font = HZFFont.PFMedium.fontSize(size: 9)
        let y = 132 * UIScreen.e_ratio_375
        return l
    }()
    
    /// 文字描述
    private var thanksLabel: UILabel = {
        let l: UILabel = UILabel()
        l.numberOfLines = 0
        l.backgroundColor = UIColor.e_random
        l.font = HZFFont.PFMedium.fontSize(size: 7)
        let y = 156.5 * UIScreen.e_ratio_375
        return l
    }()
    
    /// z政策说明
    private var incloudLabel: UILabel = {
        let l: UILabel = UILabel()
        l.numberOfLines = 0
        l.backgroundColor = UIColor.e_random
        l.font = HZFFont.PFMedium.fontSize(size: 6)
        return l
    }()
    
    private lazy var tipsTextView: UITextView = {[unowned self] in
        let t: UITextView = UITextView()
        t.isEditable = false
        t.delegate = self
        t.linkTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(red:0,green:145/255,blue:63/255,alpha:1)]
        t.isEditable = false
        t.textContainerInset = UIEdgeInsets.zero;
        t.textContainer.lineFragmentPadding = 0;
        return t
        }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setUpUI() {
        addSubview(baseView)
        
        baseView.e_addSubviews([topBackImgView, iconImageView, titleLabel, thanksLabel, incloudLabel, tipsTextView])
        // 上面logo 上面的部分 是两部分
        let heightTop = 63.5 * 2 * UIScreen.e_ratio_375
        // 上面logo 部分的高度
        let heig = 62 * 2 * UIScreen.e_ratio_375
        
        topBackImgView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(heightTop)
            make.top.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalTo(topBackImgView.snp.bottom)
            make.height.equalTo(heig)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(6.5 * UIScreen.e_ratio_375)
            make.height.equalTo(12.5)
        }
        
        thanksLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(9)
            make.right.equalToSuperview().offset(-9)
            make.top.equalTo(titleLabel.snp.bottom).offset(12 * UIScreen.e_ratio_375)
        }
        
        incloudLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(9)
            make.right.equalToSuperview().offset(-9)
            make.top.equalTo(thanksLabel.snp.bottom).offset(10 * UIScreen.e_ratio_375)
        }
        
        
        
        appendLinkString(string: tipsPre, withURLString: "", font: HZFFont.PFRegular.fontSize(size: 6)!)
        appendLinkString(string: tipsMidd, withURLString: "tip:", font: HZFFont.PFRegular.fontSize(size: 6)!)
        appendLinkString(string: tipsLast, withURLString: "", font: HZFFont.PFRegular.fontSize(size: 6)!)
        
        tipsTextView.attributedText = attributedText
        
        //2.根据字符串计算textView的高度
        let padding = tipsTextView.textContainer.lineFragmentPadding 
        let constraintRect = CGSize(width: UIScreen.e_width - 18, height: .greatestFiniteMagnitude)
        tipsTextView.textContainerInset = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        let attrs = [NSAttributedString.Key.font : HZFFont.PFRegular.fontSize(size: 6)!]

        let height = ceil(tipsTextView.text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: attrs, context: nil).height)
        tipsTextView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(9)
            make.right.equalToSuperview().offset(-9)
            make.top.equalTo(incloudLabel.snp.bottom).offset(15.5 * UIScreen.e_ratio_375)
            make.bottom.equalToSuperview()
            make.height.equalTo(height)
        }
        //3.设置textView的高度
//        textViewHeightConstraint.constant = height
        
        titleLabel.text = titleS
        thanksLabel.text = thank
        incloudLabel.text = incloud
        baseView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func appendLinkString(string:String, withURLString:String = "", font: UIFont, color: UIColor? = nil) {
        //原来的文本内容
        let attrString:NSMutableAttributedString = NSMutableAttributedString()
        
        
        attrString.append(self.attributedText)
        //新增的文本内容（使用默认设置的字体样式）
        let attrs = [NSAttributedString.Key.font : font]
        
        let appendString = NSMutableAttributedString(string: string, attributes:attrs)
        if string.count > 0 {
            let range1:NSRange = NSMakeRange(0, appendString.length)
            
            appendString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red:0,green:145/255,blue:63/255,alpha:1), range: range1)
        }
        //判断是否是链接文字
        if withURLString != "" {
            let range:NSRange = NSMakeRange(0, appendString.length)
            //            appendString.beginEditing()
            appendString.addAttribute(NSAttributedString.Key.link, value:withURLString, range:range)
            //            appendString.endEditing()
        }
        //合并新的文本
        attrString.append(appendString)
        
        //设置合并后的文本
        self.attributedText = attrString
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
class PrivacyAgreementViewController: UIViewController {
    
    private var tableView: UITableView = UITableView()
    
    let disponse = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.register(privacyCell.self, forCellReuseIdentifier: NSStringFromClass(privacyCell.self))
        Observable.just([""])
            .bind(to: tableView.rx.items) { (table, row, _) -> UITableViewCell in
                let cell:privacyCell = table.dequeueReusableCell(withIdentifier: NSStringFromClass(privacyCell.self)) as! privacyCell
                
                return cell
                
        }.disposed(by: disponse)
        
        
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

public extension UIColor {
    
    /// Random color.
    public static var e_random: UIColor {
        let r = CGFloat(arc4random_uniform(255))
        let g = CGFloat(arc4random_uniform(255))
        let b = CGFloat(arc4random_uniform(255))
        return UIColor.init(red: r, green: g, blue: b, alpha: 1)
    }
}



extension privacyCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "tip" {
            
        }
        
        return true
    }
   
}
