//
//  PhotoTableViewController.swift
//  ImagePickerDemo
//
//  Created by huifenqi on 2018/10/15.
//  Copyright © 2018 huifenqi. All rights reserved.
//

import UIKit
import Photos

// 选择图片列表页
private let albumTableViewCellItentifier = "PhotoListCell"

class PhotoTableViewController: UITableViewController {
    
    var albums = [PhotoModel]()
    
    
    /// 回调
    var callBack: ((_ model: PhotoModel) -> Void)?
    
    weak var nav: PhotoSelectorViewController?
    
    // 数据源
    var dataSource = [PhotoTableViewCellVM]()
    
    // 自定义需要加载的相册
    var customSmartCollections = [
        PHAssetCollectionSubtype.smartAlbumUserLibrary, // All Photos
        PHAssetCollectionSubtype.smartAlbumRecentlyAdded // Rencent Added
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 清除掉已选择的图片
        nav?.assetArr.removeAll()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "选择相册"
        nav = self.navigationController as? PhotoSelectorViewController
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadAlbums(false)
        configNavigationBar()
        setUpTableVIew()
    }
    
    /// tableView
    private func setUpTableVIew() {
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: albumTableViewCellItentifier)
        tableView.estimatedRowHeight = PhotoSelectorConfig.AlbumTableViewCellHeight
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
//        // 去除tableView多余空格线
//        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)

    }
    
    //设置导航
    private func configNavigationBar(){
        //添加取消键
        let cancelButton = UIBarButtonItem.init(image: UIImage.init(named: "Slice 2")!, style: .plain, target: self, action: #selector(self.eventCancel))
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc func eventCancel(){
        self.navigationController?.popViewController(animated: true)
//        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PhotoTableViewCell = tableView.dequeueReusableCell(withIdentifier: albumTableViewCellItentifier, for: indexPath) as! PhotoTableViewCell
        let vm = dataSource[indexPath.row]
        cell.bindVM(vm: vm)
        
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 	68
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = albums[indexPath.row]
//        let layout = PhotoCollectionViewController.zjxconfigCollectionViewLayout()
//        let controller = PhotoCollectionViewController(collectionViewLayout: layout)
        
        callBack?(model)
        self.navigationController?.popViewController(animated: true)
//        controller.fetchResult = model.fetchResult
//        controller.title = model.name
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    //将数据进行赋值
    func loadAlbums(_ replace: Bool){
        if replace {
            self.albums.removeAll()
        }
        
        // 加载相册的所有小图
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        
        for i in 0 ..< smartAlbums.count  {
            if customSmartCollections.contains(smartAlbums[i].assetCollectionSubtype){
                self.filterFetchResult(collection: smartAlbums[i])
            }
        }
        
        // 用户相册
        let topUserLibarayList = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        if topUserLibarayList.count > 0 {
            
            for i in 0 ..< topUserLibarayList.count {
                if let topUserAlbumItem = topUserLibarayList[i] as? PHAssetCollection {
                    self.filterFetchResult(collection: topUserAlbumItem)
                }
            }
        }
        albums.enumerated().forEach { (_, item) in
            dataSource.append(PhotoTableViewCellVM.getInstance(with: item))
        }
        //获取完数据后刷新
        self.tableView.reloadData()
    }
    
    private func filterFetchResult(collection: PHAssetCollection){
        //将照片进行时间排序
        let Instance = PHFetchOptions.init()
        //对相册进行一个排序，key为creationDate: 按照时间排序
        Instance.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        Instance.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(in: collection, options: Instance)
        //创建模型并加入数组
        if fetchResult.count > 0 {
            let model = PhotoModel(result: fetchResult as! PHFetchResult<AnyObject> as! PHFetchResult<PHObject>, label: collection.localizedTitle, assetType: collection.assetCollectionSubtype)
            self.albums.append(model)
        }
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}



class PhotoModel: NSObject {
    
    var fetchResult: PHFetchResult<PHObject>!
    var assetType: PHAssetCollectionSubtype!
    var name: String!
    
    init(result: PHFetchResult<PHObject>,label: String?, assetType: PHAssetCollectionSubtype){
        self.fetchResult = result
        self.name = label
        self.assetType = assetType
    }
}
