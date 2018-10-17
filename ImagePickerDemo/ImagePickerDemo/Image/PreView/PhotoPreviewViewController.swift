//
//  PhotoSelectorViewController.swift
//  ImagePickerDemo
//
//  Created by huifenqi on 2018/10/15.
//  Copyright © 2018 huifenqi. All rights reserved.
//

import UIKit
import Photos

private let PhotoPreviewCellID = "PhotoPreviewCell"
class PhotoPreviewViewController: UIViewController {

    // 图片
//    var assets = [PHAsset]()
    var dataSource = [PhotoPreviewCellVM]()
    
    //控制器当前导航
    var nav: PhotoSelectorViewController?
    
    // 当前展示的
    var currentPage = 0
    
//    // 底部的view
//    private lazy var bottomView = { () -> PreviewBottomView in
//        let view = PreviewBottomView()
//        view.delegate = self
//        view.imageMaxSelectedNum = (nav?.imageMaxSelectedNum)!
//        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
//        return view
//    }()
    
//    private lazy var cancelButton = { () -> UIButton in
//        let button = UIButton()
//        button.setImage(UIImage.e_imageNamed(named: "icon_selected"), for: UIControlState.normal)
//        button.addTarget(self, action: #selector(self.imageSelected), for: UIControlEvents.touchUpInside)
//        return button
//    }()
    
    //懒加载collectionView
    lazy var collectionView: UICollectionView = {
        
        self.automaticallyAdjustsScrollViewInsets = false
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: self.view.frame.width,height: self.view.frame.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentOffset = CGPoint.zero
        collectionView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(dataSource.count), height: self.view.bounds.height)
        
        collectionView.register(PhotoPreviewCell.self, forCellWithReuseIdentifier: PhotoPreviewCellID)
        return collectionView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never;
        } else {
            self.automaticallyAdjustsScrollViewInsets = false;
        }
        //获取导航并成为代理
        nav = self.navigationController as? PhotoSelectorViewController
        
        view.backgroundColor = UIColor.white
        
        title = "\(currentPage + 1)/\(nav?.assetArr.count ?? 1)"
        
        // 先处理数据
//        resetImageToVM()
        
        // 加载页面
        view.addSubview(collectionView)
        
        configNavigationBar()
        
        collectionView.setContentOffset(CGPoint(x: CGFloat(currentPage) * self.view.bounds.width, y: 0), animated: false)
        
//        // 加载底页面
//        view.addSubview(bottomView)
//
//        // 底部页面数据
//        if let assets = nav?.assetArr {
//            bottomView.bindAsset(assets: assets)
//        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        bottomView.snp.makeConstraints { (make) in
//            make.left.right.bottom.equalTo(0)
//            make.height.equalTo(139)
//        }
    }
    
    func resetImageToVM() {
        dataSource.removeAll()
        
        nav?.assetArr.enumerated().forEach { (arg) in
            let (_, asset) = arg
            dataSource.append(PhotoPreviewCellVM.getInstance(with: asset))
        }
    }
    
    //设置导航
    private func configNavigationBar(){
        //添加取消键
        let cancelButton = UIBarButtonItem.init(image: UIImage.init(named: "icon_selected")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), style: .plain, target: self, action: #selector(self.imageSelected))
        self.navigationItem.rightBarButtonItem = cancelButton
       
    }
    
    @objc func imageSelected(){
        if dataSource.count == 0 {
            return
        }
        // 删除的是一排中最后一个
        if currentPage + 1 == dataSource.count {
            dataSource.remove(at: currentPage)
            nav?.assetArr.remove(at: currentPage)
            collectionView.deleteItems(at: [IndexPath.init(row: currentPage, section: 0)])
//            bottomView.removeVM(at: currentPage)
            currentPage = currentPage - 1
        } else {
            dataSource.remove(at: currentPage)
            nav?.assetArr.remove(at: currentPage)
            collectionView.deleteItems(at: [IndexPath.init(row: currentPage, section: 0)])
//            bottomView.removeVM(at: currentPage)
        }
        
        title = "\(currentPage + 1)/\(nav?.assetArr.count ?? 1)"
        if dataSource.count == 0 {
            navigationController?.popViewController(animated: true)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}

//collectionView的代理方法
extension PhotoPreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoPreviewCellID, for: indexPath) as! PhotoPreviewCell
        let vm = dataSource[indexPath.row]
        cell.binndVM(vm: vm)
        cell.callBack = {[weak self] in
            guard let `self` = self else {
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true)
    }
    //scroView的协议方法
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        self.currentPage = Int(offset.x / self.view.bounds.width)
        title = "\(currentPage + 1)/\(nav?.assetArr.count ?? 1)"
        // 修改底部页面的高亮
//        bottomView.resetBottomBorder(currentPage: currentPage)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        self.changeCurrentToolbar()
    }
    
}

//extension PhotoPreviewViewController: PreviewBottomViewDelegate {
//    
//    func finishBtnPressed() {
//        nav?.imagePickerFinished()
//    }
//    
//    func cellTaped(at index: Int) {
//        currentPage = index
//        title = "\(currentPage + 1)/\(nav?.assetArr.count ?? 1)"
//        collectionView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
//    }
//    
//}


extension PhotoPreviewViewController: DismissProTocol {
    func protocolStartView(t: Int?) -> UIView {
        guard var ta = t else {
            return UIView()
        }
        
        if dataSource.count > ta {
            
        }else if dataSource.count > 0 {
            ta = 0
        }else {
            return UIView()
        }
        let cell: PhotoPreviewCell = self.collectionView.cellForItem(at: IndexPath.init(row: ta, section: 0)) as! PhotoPreviewCell
        
        let view = UIImageView.init(image: cell.imageView.image)
        
        return view

    }
    
    func protocalStartPosition(t: Int?) -> CGRect {
        guard let ta = t else {
            return CGRect.zero
        }
        let width: CGFloat = UIScreen.main.bounds.width
        
        var vm: PhotoPreviewCellVM!
        
        if dataSource.count > ta {
            vm = dataSource[ta]
        }else if dataSource.count > 0 {
            vm = dataSource[0]
        }else {
            return CGRect.init(x: 0, y: 0, width: 0, height: 0)
        }
        
        var mut:CGFloat = 0
        let w = CGFloat(vm.asset?.pixelWidth ?? 0)
        
        if let h = vm.asset?.pixelHeight, h > 0 {
            mut = CGFloat((w / CGFloat(h)))
        }
        let height: CGFloat = width / CGFloat(mut > 0 ? mut : 1)

        let y: CGFloat = UIScreen.main.bounds.height / 2 - height/2
        return CGRect.init(x: 0, y: y, width: width, height: height)

    }
    

    

    
}
