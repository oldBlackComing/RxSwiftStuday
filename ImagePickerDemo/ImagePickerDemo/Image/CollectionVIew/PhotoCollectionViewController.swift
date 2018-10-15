//
//  PhotoCollectionViewController.swift
//  ImagePickerDemo
//
//  Created by huifenqi on 2018/10/15.
//  Copyright © 2018 huifenqi. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "Cell"

class PhotoCollectionViewController: UICollectionViewController, AlbumToolbarViewDelegate, PhotoCollectionViewCellDelegate {
    func cellTaped(at cell: PhotoCollectionViewCell) {
        if let indexPath = collectionView?.indexPath(for: cell) {
            if indexPath.row == 0, PhotoSelectorConfig.needCamrea {
                // 不会触发
                
            } else {
                let vm = dataSource[indexPath.row]
                if selectedVM.contains(vm) {
                    selectedVM.remove(at: selectedVM.index(of: vm)!)
                    vm.selected = false
                    vm.index = -1
                    nav?.assetArr.remove(at: (nav?.assetArr.index(of: vm.asset!)!)!)
                } else {
                    vm.selected = true
                    selectedVM.append(vm)
                    nav?.assetArr.append(vm.asset!)
                }
                resetDataStatus()
            }
        }
    }
    
    func finishBtnTap() {
        nav?.imagePickerFinished()
    }
    
    func previewBtnTap() {
        // 去预览
        let preview = PhotoPreviewViewController()
        self.navigationController?.show(preview, sender: nil)
        
    }
    
    
    
    //最下方工具条高度
    private let toolbarHeight: CGFloat = 49.0
    
    
    // 选中的图片的VM
    var selectedVM = [PhotoCollectionViewCellVM]()
    
    //大小
    var assetGridThumbnailSize: CGSize?
    
    
    //最下方工具条
    var toolbar: AlbumToolbarView?
    
    weak var nav: PhotoSelectorViewController? // = <#value#>
    
    // cellVM
    var dataSource = [PhotoCollectionViewCellVM]()
    
    //需要显示的照片
    var fetchResult: PHFetchResult<PHObject>?
    
    // 页面滚动的offset
    private var offset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nav = self.navigationController as? PhotoSelectorViewController
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        let originFrame = self.collectionView!.frame
        //重新设置collectionView的大小，留出底部工具条的位置
        self.collectionView!.frame = CGRect(x:originFrame.origin.x, y:originFrame.origin.y, width:originFrame.size.width, height: originFrame.height - self.toolbarHeight)
        
        if PhotoSelectorConfig.needCamrea {
            
            // 添加拍照位置
            dataSource.append(PhotoCollectionViewCellVM.getInstance(with: nil, isFirst: true))
        }
        resetPHFetchResultToCellVM()
        
        configBottomToolBar()
        // Register cell classes
        self.collectionView!.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.contentInset = UIEdgeInsets(
            top: PhotoSelectorConfig.MinimumInteritemSpacing,
            left: PhotoSelectorConfig.MinimumInteritemSpacing,
            bottom: PhotoSelectorConfig.MinimumInteritemSpacing,
            right: PhotoSelectorConfig.MinimumInteritemSpacing
        )
        self.collectionView?.backgroundColor = UIColor.white
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 找出被移除的vm 为了同步反复进入 进入选择 - 退出删除 - 进入选择 - 退出删除 数据不同步问题
        selectedVM.enumerated().forEach({ (idx, vm) in
            //
            if !nav!.assetArr.contains(vm.asset!) {
                // 改变被移除vm的状态
                vm.selected = false
            }
            
        })
        
        // 同步选中的数据
        selectedVM = selectedVM.filter {nav!.assetArr.contains($0.asset!)}
        
        resetDataStatus()
    }
    
    func resetPHFetchResultToCellVM() {
        if fetchResult != nil {
            self.setAssetGridThumbnailSize()
            fetchResult?.enumerateObjects({
                [weak self] (obj, index, _) in
                if let asset = obj as? PHAsset {
                    let vm = PhotoCollectionViewCellVM.getInstance(with: asset)
                    self?.dataSource.append(vm)
                }
            })
        }
    }
    
    //设置collection中元素大小
    func setAssetGridThumbnailSize(){
        if assetGridThumbnailSize == nil {
            //按照屏幕分辨率重设大小
            let scale = UIScreen.main.scale
            let cellSize = (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
            let size = cellSize.width * scale
            assetGridThumbnailSize = CGSize(width: size, height: size)
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        cell.delegate = self
        let vm = dataSource[indexPath.row]
        cell.bindVM(vm: vm)
        
        // Configure the cell
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        if indexPath.row == 0, PhotoSelectorConfig.needCamrea {
            // 拍照
            openCamera()
        } else if selectedVM.count == nav?.maxSelectNum {
            let vm = dataSource[indexPath.row]
            // 被覆盖，即没有被选中
            if vm.isCovered {
                let alert = UIAlertController.init(title: nil, message: "你最多只能选\(nav!.maxSelectNum)张", preferredStyle: UIAlertController.Style.alert)
                let sureAction = UIAlertAction.init(title: "我知道了", style: UIAlertAction.Style.destructive, handler: nil)
                alert.addAction(sureAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                previewBtnTap()
            }
        } else {
            previewBtnTap()
            // 去预览
            //            let preview = PhotoPreviewViewController()
            //            preview.currentPage = indexPath.row - 1
            //            var assets = [PHAsset]()
            //            dataSource.enumerated().forEach({ (index, vm) in
            //                if index != 0 {
            //                    if vm.asset != nil {
            //                        assets.append(vm.asset!)
            //                    }
            //                }
            //            })
            //            preview.assets = assets
            //            self.navigationController?.show(preview, sender: nil)
        }
    }
    func configBottomToolBar() {
        if toolbar != nil {return}
        toolbar = AlbumToolbarView()
        toolbar?.delegate = self
        toolbar?.imageMaxSelectedNum = nav?.maxSelectNum ?? 0
        self.view.addSubview(toolbar!)
        toolbar?.snp.makeConstraints({ (make) in
            make.height.equalTo(self.toolbarHeight)
            make.left.bottom.right.equalToSuperview()
        })
    }
    public class func zjxconfigCollectionViewLayout() -> UICollectionViewFlowLayout {
        let collectionLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - PhotoSelectorConfig.MinimumInteritemSpacing * 2
        collectionLayout.minimumInteritemSpacing = PhotoSelectorConfig.MinimumInteritemSpacing
        let cellToUsableWidth = width - (PhotoSelectorConfig.ColNumber - 1) * PhotoSelectorConfig.MinimumInteritemSpacing
        let size = cellToUsableWidth / PhotoSelectorConfig.ColNumber
        collectionLayout.itemSize = CGSize(width:size, height: size)
        collectionLayout.minimumLineSpacing = PhotoSelectorConfig.MinimumInteritemSpacing
        
        return  collectionLayout
    }
    
    func resetDataStatus() {
        selectedVM.enumerated().forEach({ (index, vm) in
            vm.index = index + 1
        })
        toolbar?.selectedNumber = selectedVM.count
        // 选中的最大量
        if selectedVM.count == nav?.maxSelectNum {
            dataSource.enumerated().forEach({ (index, vm) in
                vm.isCovered = !selectedVM.contains(vm)
            })
        } else {
            dataSource.enumerated().forEach({ (index, vm) in
                vm.isCovered = false
            })
        }
        
        if PhotoSelectorConfig.needCamrea {
            // 第一个按钮始终是可以点击的
            dataSource[0].isCovered = false
        }
        
        if let cells = collectionView?.visibleCells as? [PhotoCollectionViewCell] {
            cells.enumerated().forEach({ (index, indexCell) in
                if let indexP = collectionView?.indexPath(for: indexCell) {
                    if PhotoSelectorConfig.needCamrea {
                        if indexP.row != 0 {
                            let indexVM = dataSource[indexP.row]
                            indexCell.resetWith(vm: indexVM)

                        }
                    }else{
                        let indexVM = dataSource[indexP.row]
                        indexCell.resetWith(vm: indexVM)
                    }
                }
                
            })
        }
    }
    
    // 利用滚动，刷新视野内的页面样式 -- 流畅度需要优化
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 位移距离超过20就刷新
        if abs(offset - scrollView.contentOffset.y) > 20 {
            offset = scrollView.contentOffset.y
            if let cells = collectionView?.visibleCells as? [PhotoCollectionViewCell] {
                cells.enumerated().forEach({ (index, indexCell) in
                    if let indexP = collectionView?.indexPath(for: indexCell) {
                        if indexP.row != 0 {
                            let indexVM = dataSource[indexP.row]
                            indexCell.resetWith(vm: indexVM)
                        }
                    }
                    
                })
            }
        }
        
    }
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
    func openCamera() {
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
}


extension PhotoCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        //        print("didFinishPickingImage")
        //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil) // 将图片保存到相册
        picker.dismiss(animated: true, completion: nil) // 退出相机界面
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //        print(info)
        
        let type:String = (info[UIImagePickerController.InfoKey.mediaType]as!String)
        //当选择的类型是图片
        if type == "public.image" {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                nav?.imageSelectDelegate?.imageSelectFinished(images: [image])
            }
            
        }
        
        picker.dismiss(animated: true) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}