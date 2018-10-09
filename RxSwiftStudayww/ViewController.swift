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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "uitableview")
        view.addSubview(tableView)
        
        data.debug()
            .bind(to: tableView.rx.items){ (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(row)：\(element)"
            return cell
        }
    
        
        // Do any additional setup after loading the view, typically from a nib.
    }


}

