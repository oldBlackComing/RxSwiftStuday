//
//  AlbumToolbarView.swift
//  PhotoSelector
//
//  Created by 张玺 on 2018/2/3.
//

import UIKit

protocol AlbumToolbarViewDelegate: class {
    func finishBtnTap()
    func previewBtnTap()
}

class AlbumToolbarView: UIView {

    weak var delegate: AlbumToolbarViewDelegate?
    
    //照片最大数量
    var imageMaxSelectedNum = 9 {
        didSet {
            finishBtn.setTitle("完成(0/\(imageMaxSelectedNum))", for: UIControl.State.normal)
        }
    }
    //改变工具条上已选数字的值
    var selectedNumber = 0 {
        didSet {
            finishBtn.setTitle("完成(\(selectedNumber)/\(imageMaxSelectedNum))", for: UIControl.State.normal)
            finishBtn.backgroundColor = selectedNumber == 0 ?  UIColor.init(red: 204/255, green: 204/255, blue: 204/255, alpha: 1) : UIColor.init(red: 255/255, green: 99/255, blue: 99/255, alpha: 1) 
        }
    }
    
    private lazy var previewBtn = { () -> UIButton in
        let button = UIButton()
        button.setTitle("预览", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor.init(red: 51/255, green: 51/255, blue: 51/255, alpha: 1), for: UIControl.State.normal)
        return button
    }()
    
    private lazy var finishBtn = { () -> UIButton in
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.backgroundColor = UIColor.init(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        button.setTitleColor( UIColor.white, for: UIControl.State.normal)
        button.setTitle("完成(0/\(imageMaxSelectedNum))", for: UIControl.State.normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        finishBtn.snp.makeConstraints { (make) in
            make.width.equalTo(125)
            make.height.equalTo(self)
            make.top.right.equalTo(0)
        }
        
        previewBtn.snp.makeConstraints { (make) in
            make.left.top.equalTo(0)
            make.height.equalTo(self)
            make.width.equalTo(60)
        }
        
    }
    
    private func setupView() {
        backgroundColor = UIColor.white
        addSubview(previewBtn)
        addSubview(finishBtn)
        
        finishBtn.addTarget(self, action: #selector(finishBtnHasTapped), for: UIControl.Event.touchUpInside)
        previewBtn.addTarget(self, action: #selector(previewBtnHasTapped), for: UIControl.Event.touchUpInside)
        
    }
    
    @objc func finishBtnHasTapped() {
        self.delegate?.finishBtnTap()
    }
    
    @objc func previewBtnHasTapped() {
        self.delegate?.previewBtnTap()
    }
    
}
