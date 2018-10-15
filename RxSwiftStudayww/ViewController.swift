//
//  ViewController.swift
//  RxSwiftStudayww
//
//  Created by huifenqi on 2018/10/9.
//  Copyright © 2018 huifenqi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    var data = Observable.just(["asdasdas", "dasdasdxcxz", "dzxxcxzxxcca", "daaddaad"])
    
    var tableView: UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), style: .plain)
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var btn: UIButton = {
        let b: UIButton = UIButton()
        
        b.backgroundColor = .red
        b.frame = CGRect.init(x: 100, y: 100, width: 200, height: 200)
        
        return b
    }()
    
    //歌曲列表数据源
    let musicListViewModel = MusicListViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "uitableview")
        view.addSubview(tableView)
        view.addSubview(self.btn)
        
        data
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "uitableview")!
                cell.textLabel?.text = "\(row)：\(element)"
                return cell
            }
//


        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            print("选中项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        self.btn.rx.tap.debug("btn tap").subscribe(
            onNext: {
                print("wwwwwwww")
        })
        
<<<<<<< HEAD
        data.debug()
            .bind(to: tableView.rx.items){ (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "uitableview")!
            cell.textLabel?.text = "\(row)：\(element)"
            return cell
        }
    
=======
        let btn: UIButton = self.btn
        btn.rx.tap.scan(0) { (privalue, _) in
            return privalue + 1
            }.subscribe(onNext: {current in
                print(current)
            })
        
        btn.rx.tap.debug()
            .scan(0) { (privalue, _) in
                return privalue + 1
        }
            .map { (currentCount) in
                return "aadasdasdasd\(currentCount)"
        }
        .asDriver(onErrorJustReturn: "0")
            .drive()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.present(TextViewController(), animated: true, completion: nil)
        self.present(PrivacyAgreementViewController(), animated: true, completion: nil)
    }

    }
}



struct MusicListViewModel {
    let data = Observable.just([
        Music(name: "无条件", singer: "陈奕迅"),
        Music(name: "你曾是少年", singer: "S.H.E"),
        Music(name: "从前的我", singer: "陈洁仪"),
        Music(name: "在木星", singer: "朴树"),
        ])
}

struct Music {
    var name:String?
    var singer: String?
    
    
}
