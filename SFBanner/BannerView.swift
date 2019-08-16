//
//  BannerView.swift
//  无线轮播图
//
//  Created by FDC-Fabric on 2019/8/15.
//  Copyright © 2019年 FDC-Fabric. All rights reserved.
//

import UIKit
protocol BannerViewDelegate {
    func tapIconView(currentPageIndex:Int)
}
class BannerView: UIView {
    var tapDelegate:BannerViewDelegate? = nil
    var currentPageIndex:Int = 0
    //用来记录一共有多少张图片
    var ALLICONCOUNT:Int = 0
    var iconStrA:Array<String> = Array()
    var tempArray:Array<UIImageView> = Array()
    //懒加载scrollView
    lazy var scorllView:UIScrollView = {
       let scrollView = UIScrollView(frame: bounds)
        addSubview(scrollView)
        //开启分页模式
        scrollView.isPagingEnabled = true
        //隐藏水平滚动显示条
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        //设置scrollview的滑动范围
        scrollView.contentSize = CGSize(width: bounds.width * 3, height: 0)
        return scrollView
    }()
    // 添加pageControl
    lazy var pageControl:UIPageControl = {
       let pageControl = UIPageControl(frame: CGRect(x: 0, y: bounds.height - 50, width: bounds.width, height: 50))
        addSubview(pageControl)
        //设置未被选中的小圆点颜色
        pageControl.pageIndicatorTintColor = UIColor.white
        //设置被选中的小圆点颜色
        pageControl.currentPageIndicatorTintColor = UIColor.green
        pageControl.backgroundColor = UIColor.lightGray
        return pageControl
    }()
    //定时器
    var timer:Timer? = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(scorllView)
        self.addSubview(pageControl)
    }
    
    
    //通过传进来的数组来做一些事情
    func createImageview(_ iconA:Array<String>){
        
        //设置pageControl的个数
        pageControl.numberOfPages = iconA.count
        ALLICONCOUNT = iconA.count
        self.iconStrA = iconA
        //创建三个imageview
        for i in 0..<3 {
        let iconView = UIImageView()
            iconView.frame = CGRect(x: bounds.width * CGFloat(i), y: 0, width: bounds.width, height: bounds.height)
            iconView.isUserInteractionEnabled = true
            scorllView.addSubview(iconView)
            let tapIcon = UITapGestureRecognizer(target: self, action: #selector(tapImageView))
            iconView.addGestureRecognizer(tapIcon)
            tempArray.append(iconView)
        }
        
        let leftIconview = tempArray.first
        let middleIconview = tempArray[1]
        let rightIconview = tempArray.last
        
        if iconA.count < 1 {
            
            return;
        }
        
        
        //给三张imageview默认赋值
        leftIconview?.image = UIImage(named: iconA.last!)
        middleIconview.image = UIImage(named: iconA.first!)
        rightIconview!.image = UIImage(named: iconA[1])
        //并且设置默认的scrollview的偏移量
        scorllView.setContentOffset(CGPoint(x: bounds.width, y: 0), animated: true)
        //设置当前页面的索引
        pageControl.currentPage = 0
        timer = Timer(timeInterval: 2, target: self, selector: #selector(scrollToright), userInfo:nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)

    }
    
    
    //MARK:分页控制器的点击事件
    @objc func pagecontrolTouched() -> Void {
        
    }
    //MARK:定时器触发的方法   向右滑动
    @objc func scrollToright(){
        //让scrollview始终偏移2个width
      self.scorllView.setContentOffset(CGPoint(x: 2 * bounds.width, y: 0), animated: false)
        //设置图片显示
        resetPageIndex(isToRight: true)
    }
    //MARK:向左滑动
    func scrollToLeft(){
        self.scorllView.setContentOffset(CGPoint(x:0, y: 0), animated: false)
        //设置图片显示
        resetPageIndex(isToRight: true)
        
        
    }
    //重新设置pagecontrol的索引
    func resetPageIndex(isToRight:Bool){
        
        if isToRight{
            
           
            if currentPageIndex == ALLICONCOUNT - 1{//已经滑动到最后了
                pageControl.currentPage = 0
                
                
            }else{
                pageControl.currentPage = currentPageIndex + 1
            }
            
            
        }else{//向左滑
            
            if currentPageIndex == 0 {
                pageControl.currentPage = ALLICONCOUNT - 1
                
            }else{
            
                pageControl.currentPage = currentPageIndex - 1
            
            }

        }
       
       currentPageIndex = pageControl.currentPage
         resetIcon()
        
    }
    
    
    //MARK:重新设置图片的显示
    func resetIcon(){
        let leftImageView:UIImageView = self.tempArray[0]
        let middleImageview:UIImageView = self.tempArray[1]
        let rightImageview:UIImageView = self.tempArray[2]
        
        if iconStrA.count < 1 {
            return
        }
        
        
        
        if(currentPageIndex == 0){//此时就在起始位置
            leftImageView.image = UIImage(named:self.iconStrA.last!)
            middleImageview.image = UIImage(named: iconStrA.first!)
            rightImageview.image = UIImage(named: iconStrA[1])
        }else if(currentPageIndex == ALLICONCOUNT - 1){//已经滑到最后一张图片了
            leftImageView.image = UIImage(named:self.iconStrA[currentPageIndex])
            middleImageview.image = UIImage(named: iconStrA.last!)
            rightImageview.image = UIImage(named: iconStrA.first!)
       
        }else{
            leftImageView.image = UIImage(named:self.iconStrA[currentPageIndex - 1])
            middleImageview.image = UIImage(named:self.iconStrA[currentPageIndex ])
            rightImageview.image = UIImage(named: self.iconStrA[currentPageIndex + 1])
            
        }
        
        
        
        self.scorllView.setContentOffset(CGPoint(x: bounds.width, y: 0), animated: false)
        
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
extension BannerView:UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       timer?.invalidate()
    }
    //这个方法是手动拖拽结束的时候调用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //开启定时器
        timer = Timer(timeInterval: 2, target: self, selector: #selector(scrollToright), userInfo:nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
        if scorllView.contentOffset.x > bounds.width {//向右滑动
            resetPageIndex(isToRight: true)
            
        }else if scrollView.contentOffset.x < bounds.width {
            resetPageIndex(isToRight: false)
        }
        resetIcon()
        
    }
    
    
    @objc func tapImageView(_ tap:UITapGestureRecognizer){
        if let mytapdelegate = self.tapDelegate {
            mytapdelegate.tapIconView(currentPageIndex: currentPageIndex)
        }
        
    }
    
    
    
    
    
    
}
