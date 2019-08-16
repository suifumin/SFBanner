//
//  ViewController.swift
//  无线轮播图
//
//  Created by FDC-Fabric on 2019/8/15.
//  Copyright © 2019年 FDC-Fabric. All rights reserved.
//

import UIKit

class ViewController: UIViewController,BannerViewDelegate {
    func tapIconView(currentPageIndex: Int) {
        print("%d",currentPageIndex)
    }
    
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bannerview = BannerView(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 300))
        bannerview.tapDelegate = self
        view.addSubview(bannerview)
        bannerview.createImageview(["01.jpg","02.jpg","03.jpg","04.jpg","05.jpg"])
//        bannerview.createImageview([])
    }


}

