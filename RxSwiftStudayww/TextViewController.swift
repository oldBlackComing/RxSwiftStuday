//
//  TextViewController.swift
//  RxSwiftStudayww
//
//  Created by huifenqi on 2018/10/10.
//  Copyright © 2018 huifenqi. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class TextViewController: UIViewController {

    var viewModel: MusicListViewModel = MusicListViewModel()
    
    var tableVIew: UITableView = {
        let t: UITableView = UITableView.init(frame: UIScreen.main.bounds, style: .plain)
        t.register(UITableViewCell.self, forCellReuseIdentifier: "tableVIewxell")
        
        return t
    }()
    
    var disposebag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableVIew)
        
//      _ = viewModel
//        .data
//        .bind(to: tableVIew.rx.items) { (tableView, row, element) in
//            let cell = tableView.dequeueReusableCell(withIdentifier: "tableVIewxell")!
//            cell.textLabel?.text = "\(row)：\(element)"
//            return cell
//        }
    
        viewModel.data.bind(to: tableVIew.rx.items) { (tableView, row, element) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableVIewxell")!
            cell.textLabel?.text = "\(row)：\(element)"
            return cell
        }.disposed(by: disposebag)
        tableVIew.rx.itemSelected.subscribe(
            onNext: {item in
                print(item)
        }
        ).disposed(by: disposebag)
        
        tableVIew.rx.modelSelected(Music.self).subscribe(onNext: {item in
            print(item)
        }).disposed(by: disposebag)
        
        tableVIew.rx.itemDeleted.subscribe(onNext: {item in
            print(item)
        }).disposed(by: disposebag)
        tableVIew.rx.itemMoved.subscribe(onNext: {item in
            print(item)
        }).disposed(by: disposebag)
        
        tableVIew.rx.willDisplayCell.subscribe(onNext:{item, indexPath in
            item.textLabel?.text = "\(indexPath.row)：ssss"

            print(item)
        }).disposed(by: disposebag)
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

struct Music {
    var name: String //歌名
    var singer: String //演唱者
    
    init(name: String, singer: String) {
        self.name = name
        self.singer = singer
    }
}

struct MusicListViewModel {
    var data = Observable.just([
        Music(name: "无条件", singer: "陈奕迅"),
        Music(name: "你曾是少年", singer: "S.H.E"),
        Music(name: "从前的我", singer: "陈洁仪"),
        Music(name: "在木星", singer: "朴树"),
        ])
    
    var datas = Observable.just([
        Music(name: "无条件", singer: "陈奕迅"),
        Music(name: "你曾是少年", singer: "S.H.E"),
        Music(name: "从前的我", singer: "陈洁仪"),
        Music(name: "在木星", singer: "朴树"),
        ])
    
}

