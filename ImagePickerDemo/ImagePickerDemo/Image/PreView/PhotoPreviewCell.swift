//
//  PhotoPreviewCell.swift
//  PhotoSelector
//
//  Created by 张玺 on 2018/2/5.
//

import UIKit
import Photos

class PhotoPreviewCell: UICollectionViewCell {
    
    lazy var imageView = { () -> UIImageView in
        let view = UIImageView()
        view.backgroundColor = UIColor.white
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    let photoImageManager = PHCachingImageManager()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        
    }
    
    func binndVM(vm: PhotoPreviewCellVM) {
        if let asset = vm.asset {
            photoImageManager.requestImage(for: asset, targetSize: self.bounds.size, contentMode: .aspectFit, options: nil, resultHandler: {
                [weak self](image, info) in
                if image != nil {
                    self!.imageView.image = image
                    
                }
            })
        }
        
    }
    
}
