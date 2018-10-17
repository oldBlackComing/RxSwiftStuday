//
//  PhotoCollectionViewController.swift
//  ImagePickerDemo
//
//  Created by huifenqi on 2018/10/15.
//  Copyright © 2018 huifenqi. All rights reserved.
//

import UIKit
import Photos
import SnapKit

class PhotoTableViewCell: UITableViewCell {

    let photoImageManager = PHCachingImageManager()
    
    
    private lazy var coverImage = { () -> UIImageView in
        let view = UIImageView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private lazy var titleLabel = { () -> UILabel in
        let label = UILabel()
        label.sizeToFit()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var numLabel = { () -> UILabel in
        let label = UILabel()
        label.sizeToFit()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(coverImage)
        addSubview(titleLabel)
        addSubview(numLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        coverImage.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.left.equalTo(10)
            make.centerY.equalTo(self)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(coverImage.snp.right).offset(10)
            make.centerY.equalTo(coverImage)
        }
        numLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(0)
            make.bottom.equalTo(titleLabel.snp.bottom)
        }
    }
    
    func bindVM(vm: PhotoTableViewCellVM) {
        titleLabel.text = vm.albumTitle
        numLabel.text = vm.albumNumTitle
        if let asset = vm.asset {
            photoImageManager.requestImage(for: asset, targetSize: self.coverImage.bounds.size, contentMode: .aspectFit, options: nil, resultHandler: {
                [weak self](image, info) in
                if image != nil {
                    self!.coverImage.image = image
                    
                }
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
