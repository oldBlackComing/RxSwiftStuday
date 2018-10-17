//
//  PhotoSelectorViewController.swift
//  ImagePickerDemo
//
//  Created by huifenqi on 2018/10/15.
//  Copyright © 2018 huifenqi. All rights reserved.
//

import UIKit
import Photos

protocol PhotoCollectionViewCellDelegate: class {
    func cellTaped(at cell: PhotoCollectionViewCell)
}

class PhotoCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: PhotoCollectionViewCellDelegate?
    
    var asset: PHAsset?  //

    private var isFirst: Bool = false
    
    let photoImageManager = PHCachingImageManager()
    
    private lazy var coverView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.alpha = 0.6
        return view
    }()
    
    private lazy var numBtn = { () -> UIButton in
        let button = UIButton()
        button.layer.cornerRadius = 0
        button.layer.masksToBounds = true
        button.setBackgroundImage(UIImage.init(named: "icon_unselect"), for: UIControl.State.normal)
        button.setBackgroundImage(UIImage.init(named: "icon_select"), for: UIControl.State.selected)
        return button
    }()
    
     lazy var photoImageView = { () -> UIImageView in
        let view = UIImageView()
        view.backgroundColor = UIColor.white
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        addSubview(numBtn)
        addSubview(coverView)
        numBtn.addTarget(self, action: #selector(buttonPressed), for: UIControl.Event.touchUpInside)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isFirst {
            photoImageView.snp.remakeConstraints { (make) in
                make.width.height.equalTo(30)
                make.center.equalTo(self)
            }
        } else {
            photoImageView.snp.remakeConstraints { (make) in
                make.width.height.equalTo(self)
                make.center.equalTo(self)
            }
        }
        
        
        coverView.snp.remakeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
        
        numBtn.snp.remakeConstraints { (make) in
            make.top.equalTo(3.5)
            make.right.equalTo(-3.5)
            make.width.height.equalTo(24)
        }
        
    }
    
    @objc func buttonPressed() {
        self.delegate?.cellTaped(at: self)
    }
    
    func resetWith(vm: PhotoCollectionViewCellVM) {
        numBtn.isHidden = vm.isFirst
        coverView.isHidden = !vm.isCovered
        
        self.isFirst = vm.isFirst
        
        numBtn.isSelected = vm.selected
        if numBtn.isSelected {
//            numBtn.setTitle("\(vm.index)", for: UIControl.State.normal)
        } else {
//            numBtn.setTitle("", for: UIControl.State.normal)
        }
    }
    
    func bindVM(vm: PhotoCollectionViewCellVM) {
        
        numBtn.isHidden = vm.isFirst
        coverView.isHidden = !vm.isCovered
        asset = vm.asset

        self.isFirst = vm.isFirst
      
        numBtn.isSelected = vm.selected
        if numBtn.isSelected {
//            numBtn.setTitle("\(vm.index)", for: UIControl.State.normal)
        } else {
//            numBtn.setTitle("", for: UIControl.State.normal)
        }
        
        let size = CGSize.init(width: self.bounds.size.width * 2, height: self.bounds.size.height * 2)
        if let asset = vm.asset {
            photoImageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: nil, resultHandler: {
                [weak self](image, info) in
                if image != nil {
                    self!.photoImageView.image = image
                    
                }
            })
        } else {
            photoImageView.image = UIImage.init(named: "icon_photo")
        }
        
    }
}
