//
//  PhotoSelectorViewController.swift
//  ImagePickerDemo
//
//  Created by huifenqi on 2018/10/15.
//  Copyright © 2018 huifenqi. All rights reserved.
//

import UIKit
import Photos

public protocol PhotoSelectorViewControllerDelegate: class {
    
    func imageSelectFinished(images: [UIImage])
}

class PhotoSelectorViewController: UINavigationController {

    
    /// 获取已选择的图片
    weak var imageSelectDelegate: PhotoSelectorViewControllerDelegate? // = <#value#>
    
    /// 能够获取的图片的大小
    var imageSize: CGSize = PHImageManagerMaximumSize
    
    /// 获取图片的最大数量
    var maxSelectNum: Int = 9
    
    
    //需要回传的值
    var assetArr = [PHAsset]()

    /// 必须使用这个构造器
    ///
    /// - Parameters:
    ///   - maxNum: 可选的最大数量传入
    ///   - size: 图片的大小
    init(maxNum: Int, size: CGSize = PHImageManagerMaximumSize) {
        
        let photoTVC: PhotoTableViewController = PhotoTableViewController(style: .plain)
        
        super.init(rootViewController: photoTVC)
        
        imageSize = size
        maxSelectNum = maxNum
        
        
        /// 获取智能相册
        let result: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: PHAssetCollectionSubtype.smartAlbumUserLibrary, options: nil)
        if result.count > 0 {
            
            let model: PHFetchResult? = self.getModel(collection: result[0])
            let layout: UICollectionViewFlowLayout = PhotoCollectionViewController.zjxconfigCollectionViewLayout()
            let controller: PhotoCollectionViewController = PhotoCollectionViewController(collectionViewLayout: layout)
            controller.fetchResult = model as? PHFetchResult<PHObject>
            controller.title = result[0].localizedTitle
            self.pushViewController(controller, animated: false)
            
        }
        
    }
    
    
    
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    private func getModel(collection: PHAssetCollection) -> PHFetchResult<PHAsset>? {
        
        /// 过滤出图片 并按时间排序的呢
        let option: PHFetchOptions = PHFetchOptions()
        
        option.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        ///
        let fetchResult = PHAsset.fetchAssets(in: collection, options: option)

        if fetchResult.count > 0 {
            return fetchResult
        }
        return  nil
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // 用户还没有授权
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in
                // 用户授权
                if status == .authorized {
                    // 重新获取数据
                    if let controller = self.topViewController as? PhotoTableViewController {
                        controller.loadAlbums(false)
                    }
                }
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            // 用户关闭权限
            if PHPhotoLibrary.authorizationStatus() == .denied {
                let alert = UIAlertController.init(title: nil, message: "访问相册需要授权", preferredStyle: UIAlertController.Style.alert)
                let cancleAction = UIAlertAction.init(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
                let sureAction = UIAlertAction.init(title: "去授权", style: UIAlertAction.Style.destructive, handler: { (action) in
                    let settingUrl = URL(string: UIApplication.openSettingsURLString)!
                    if UIApplication.shared.canOpenURL(settingUrl) {
                        UIApplication.shared.openURL(settingUrl)
                    }
                })
                alert.addAction(cancleAction)
                alert.addAction(sureAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        // Do any additional setup after loading the view.
    }
    

    func imagePickerFinished() {
        var images = [UIImage]()
        if assetArr.count > 0 {
            // 同步操作
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            assetArr.enumerated().forEach { (_, element) in
                PHCachingImageManager().requestImage(for: element, targetSize: imageSize, contentMode: .aspectFill, options: options, resultHandler: { (image, info) in
                    if let `image` = image {
                        images.append(image)
                    }
                })
            }
        }
        
        imageSelectDelegate?.imageSelectFinished(images: images)
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
