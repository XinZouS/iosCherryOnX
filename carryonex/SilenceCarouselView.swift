//
//  SlienceCarouselView.swift
//  carryonex
//
//  轮播控件
//  Created by Xin Zou on 10/30/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//  Reference: https://github.com/SilenceL/SilenceCarouselView

import UIKit


/// 点击事件回调
public typealias SilenceCarouselViewTapBlock = ((_ carouselView: SilenceCarouselView, _ index:Int) -> ())

/*
 实现原理参考：http://www.tuicool.com/articles/yE73ia
 本插件加载网络图片使用的框架是喵神王巍的Kingfisher：https://github.com/onevcat/Kingfisher
 */
/// 轮播控件
public class SilenceCarouselView: UIView,UIScrollViewDelegate {
    
    // 定义手指滑动方向枚举
    enum CarouselViewDirec {
        case DirecNone      // 没有动
        case DirecLeft      // 向左
        case DirecRight     // 向右
    }
    
    // 点击事件回调
    var silenceCarouselViewTapBlock:SilenceCarouselViewTapBlock?
    
    var scrollView:UIScrollView?
    var pageControl:UIPageControl?
    
    var timeInterval  : TimeInterval = 1
    private var timer : Timer?
    
    var imageArray:[Any]?
    
    private var currentImgView:UIImageView?
    private var otherImgView:UIImageView? // 左右滑动时设置的图片
    
    private var currIndex = 0
    private var nextIndex = 1
    
    private var currentDirec:CarouselViewDirec = .DirecNone // 当前的滚动方向
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    /**
     解决timer被强引用无法释放的问题
     */
    public override func willMove(toWindow newWindow: UIWindow?) {
        if newWindow == nil && timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    
    // 移除计时器
    deinit{
        if timer != nil {
            timer?.invalidate()
        }
    }
    
    /**
     自定义的初始化方法
     
     - parameter frame:                       frame
     - parameter imageArray:                  图片数组：可以是UIImage、NSURL、String
     - parameter silenceCarouselViewTapBlock: 回调闭包
     
     - returns: 初始化成功的轮播对象
     */
    init(frame: CGRect, imageArray: [Any], silenceCarouselViewTapBlock: @escaping SilenceCarouselViewTapBlock) {
        super.init(frame: frame)
        self.imageArray = imageArray
        self.silenceCarouselViewTapBlock = silenceCarouselViewTapBlock
        self.reload()
    }
    
    
    /**
     重新重置加载轮播
     */
    func reload(){
        initTimer()
        initView()
    }
    
    private func initTimer() -> (){
        //如果只有一张图片，则直接返回，不开启定时器
        if self.imageArray!.count <= 1 {
            return
        }
        //如果定时器已开启，先停止再重新开启
        if timer != nil {
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(rollImages), userInfo: nil, repeats: true)
        //        timer?.fire()
        RunLoop.current.add(self.timer!, forMode: .defaultRunLoopMode)
        
    }
    
    /**
     定时调用的方法: 动画改变scrollview的偏移量就可以实现自动滚动
     */
    func rollImages() -> (){
        if let w = self.scrollView?.bounds.width {
            let p = CGPoint(x: w * 2, y: 0)
            self.scrollView?.setContentOffset(p, animated: true)
        }
    }
    
    
    /**
     初始化滚动视图数据
     */
    private func initView() -> (){
        if self.scrollView == nil {
            self.scrollView = UIScrollView.init(frame: self.bounds)
            self.scrollView?.isPagingEnabled = true
            self.scrollView?.showsHorizontalScrollIndicator = false
            self.scrollView?.showsVerticalScrollIndicator = false
            self.scrollView?.delegate = self
            self.addSubview(self.scrollView!)
            
            self.otherImgView = UIImageView(frame: self.bounds)
            self.otherImgView?.isUserInteractionEnabled = true
            self.otherImgView!.contentMode = .scaleAspectFill
            self.otherImgView!.clipsToBounds = true;
            self.scrollView!.addSubview(self.otherImgView!)
            self.otherImgView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappingImage)))
            
            self.currentImgView = UIImageView(frame: self.bounds)
            self.currentImgView?.isUserInteractionEnabled = true
            self.currentImgView!.contentMode = .scaleAspectFill
            self.currentImgView!.clipsToBounds = true;
            self.currentImgView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappingImage)))
            self.scrollView!.addSubview(self.currentImgView!)
            
            let rec = CGRect(x: 0, y: self.bounds.height - 30, width: self.bounds.width, height: 30)
            self.pageControl = UIPageControl(frame: rec)
            self.addSubview(self.pageControl!)
        }
        self.scrollView?.frame = self.bounds
        // 设置内容宽度为3倍的尺寸
        self.scrollView?.contentSize = self.bounds.size
        // 设置当前显示的图片
        self.currentImgView?.frame = self.frame
        self.loadImg(imgView: self.currentImgView!, index: 0)
        // 设置页数
        self.pageControl?.numberOfPages = self.imageArray!.count
        self.pageControl?.currentPage = 0
        self.pageControl?.hidesForSinglePage = true
        // 设置显示的位置
        self.scrollView?.contentOffset = CGPoint(x: self.bounds.width, y: 0)
        // 设置整个轮播图片的显示逻辑
        self.reloadImg()
        //为一张图片的时候
        if self.pageControl?.numberOfPages == 1 {
            self.scrollView?.contentSize = self.frame.size
            self.scrollView?.contentOffset = CGPoint(x:0, y:0)
            self.currentImgView?.frame = self.frame
        }
    }
    
    /**
     图片点击事件
     */
    func tappingImage(){
        if self.silenceCarouselViewTapBlock != nil {
            self.silenceCarouselViewTapBlock!(self, self.pageControl!.currentPage)
        }
    }
    
    /**
     设置整个轮播图片的显示逻辑
     */
    private func reloadImg() -> (){
        self.currentDirec = .DirecNone;//清空滚动方向
        //判断最终是滚到了右边还是左边
        let index = self.scrollView!.contentOffset.x / self.scrollView!.bounds.size.width;
        //等于1表示最后没有滚动，返回不做任何操作
        if index == 1 {return}
        //当前图片索引改变
        self.currIndex = self.nextIndex;
        self.pageControl!.currentPage = self.currIndex
        // 将当前图片的位置放到中间
        let fra = CGRect(x: (scrollView?.frame.width)!, y: 0, width: (scrollView?.frame.width)!, height: (scrollView?.bounds.height)!)
        self.currentImgView!.frame = fra
        // 将其他图片对象的图片给当前显示的图片
        self.currentImgView!.image = self.otherImgView!.image
        // 设置视图滚到中间位置
        self.scrollView!.contentOffset = CGPoint(x: (scrollView?.bounds.width)!, y: 0)
    }
    
    /**
     加载图片
     
     - parameter imgView: 需要加载图片的 UIImageView
     - parameter index:   加载图片的索引
     */
    private func loadImg(imgView:UIImageView,index:Int){
        let imgData = self.imageArray![index]
        // 如果是字符串类型，就去拼接URL
        if let url = imgData as? String {
            imgView.yy_setImage(with: URL(string: url), placeholder: #imageLiteral(resourceName: "CarryonEx_Logo")) //此处可以换成别的网络图片加载逻辑
        }
        // 如果是URL类型则直接去加载
        else if let url = imgData as? URL {
            imgView.yy_setImage(with: url, placeholder: #imageLiteral(resourceName: "CarryonEx_Logo")) // 此处可以换成别的网络图片加载逻辑
        }
        // 图片类型
        else if imgData is UIImage {
            imgView.image = imgData as? UIImage
        }
        // 其他未找到为空
        else{
            imgView.image = nil
        }
    }
    
    
    
    //MARK: - UIScrollView代理方法
    
    // 开始拖动时停止自动轮播
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.timer?.invalidate()
    }
    
    // 结束拖动时开启自动轮播
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.initTimer()
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // 带动画的设置scrollview位置后会调用此方法
        self.reloadImg() // 设置图片
    }
    
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 结束滚动时重置方向
        self.currentDirec = .DirecNone
        // 设置图片
        self.reloadImg()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 设置手指滑动方向
        self.currentDirec = scrollView.contentOffset.x > scrollView.bounds.size.width ? .DirecLeft : .DirecRight;
        // 向右滑
        if self.currentDirec == .DirecRight {
            // 将其他图片显示到左边
            self.otherImgView!.frame = scrollView.frame
            // 下一索引-1
            self.nextIndex = self.currIndex - 1
            // 当索引 < 0 时, 显示最后一张图片
            if self.nextIndex < 0 {
                self.nextIndex = self.imageArray!.count - 1
            }
        }
            // 向左滑动
        else if self.currentDirec == .DirecLeft {
            // 将其他图片显示到右边
            let fra = CGRect(x: (currentImgView?.frame.maxX)!, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
            self.otherImgView!.frame = fra
            // 设置下一索引
            self.nextIndex = (self.currIndex + 1) % self.imageArray!.count
        }
        // 去加载图片
        self.loadImg(imgView: self.otherImgView!, index: self.nextIndex)
    }
    
    
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

