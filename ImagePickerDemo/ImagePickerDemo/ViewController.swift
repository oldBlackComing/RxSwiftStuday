//
//  ViewController.swift
//  ImagePickerDemo
//
//  Created by huifenqi on 2018/10/15.
//  Copyright © 2018 huifenqi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PhotoSelectorViewControllerDelegate {
    func imageSelectFinished(images: [UIImage]) {
        print(images)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let a = PhotoSelectorViewController.init(maxNum: 9)
        a.imageSelectDelegate = self
        self.present(a, animated: true, completion: nil)

    }
}

