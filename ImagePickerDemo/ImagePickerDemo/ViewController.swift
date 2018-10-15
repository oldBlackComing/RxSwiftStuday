//
//  ViewController.swift
//  ImagePickerDemo
//
//  Created by huifenqi on 2018/10/15.
//  Copyright © 2018 huifenqi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.present(PhotoSelectorViewController.init(maxNum: 9), animated: true, completion: nil)

    }
}

