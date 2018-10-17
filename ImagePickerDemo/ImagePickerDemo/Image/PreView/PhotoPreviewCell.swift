//
//  PhotoPreviewCell.swift
//  PhotoSelector
//
//  Created by 张玺 on 2018/2/5.
//

import UIKit
import Photos

class PhotoPreviewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    var callBack:(()-> Void)?
    
    private var scrollView: UIScrollView = {
        let s = UIScrollView()
        s.minimumZoomScale = 0.2
        s.maximumZoomScale = 2.0
        s.contentSize = CGSize.init(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height+1)
        s.backgroundColor = .black
        return s
    }()
    lazy var imageView = { () -> UIImageView in
        let view = UIImageView()
        view.backgroundColor = UIColor.clear
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    let photoImageManager = PHCachingImageManager()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never;
        } else {
//            self.automaticallyAdjustsScrollViewInsets = false;
        }
        addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapClick(tap:)))
        
        scrollView.addGestureRecognizer(tap)
        
    }
    
    @objc func tapClick(tap:UITapGestureRecognizer) {
        callBack?()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.delegate = self
        scrollView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        
//        imageView.snp.makeConstraints { (make) in
//            make.top.left.right.bottom.equalTo(0)
//        }
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height + 1
        
        imageView.center = CGPoint.init(x:width/2 , y: height/2)
        var frame1 = imageView.frame
        
        frame1.size.width = width
        frame1.size.height = height
        
        imageView.frame = frame

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
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            scrollView.contentOffset = CGPoint.init(x: 0, y: 0)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < -20 {
            callBack?()
        }
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scrollView.minimumZoomScale >= scale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
        
        if scrollView.maximumZoomScale <= scale{
            scrollView.setZoomScale(2.0, animated: true)
        }
        
        let offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
        let offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ?
            (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
        UIView.animate(withDuration: 0.3) {[weak self]in
            self?.imageView.center = CGPoint.init(x:scrollView.contentSize.width * 0.5 + offsetX , y: scrollView.contentSize.height * 0.5 + offsetY)
        }
        
    }
    
}
