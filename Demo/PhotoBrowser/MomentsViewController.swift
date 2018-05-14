
//
//  MomentsViewController.swift
//  PhotoBrowser
//
//  Created by JiongXing on 2017/3/9.
//  Copyright © 2017年 JiongXing. All rights reserved.
//

import UIKit
import JXPhotoBrowser

class MomentsViewController: UIViewController {
    
    private lazy var thumbnailImageUrls: [String] = {
        return ["http://wx3.sinaimg.cn/thumbnail/bfc243a3gy1febm7nzbz7j20ib0iek5j.jpg",
                "http://wx1.sinaimg.cn/thumbnail/bfc243a3gy1febm7n9eorj20i60hsann.jpg",
                "http://wx1.sinaimg.cn/thumbnail/bfc243a3gy1febm7orgqfj20i80ht15x.jpg",
                "http://wx2.sinaimg.cn/thumbnail/bfc243a3gy1febm7pmnk7j20i70jidwo.jpg",
                "http://wx3.sinaimg.cn/thumbnail/bfc243a3gy1febm7qjop4j20i00hw4c6.jpg",
                "http://wx4.sinaimg.cn/thumbnail/bfc243a3gy1febm7rncxaj20ek0i74dv.jpg",
                "http://wx2.sinaimg.cn/thumbnail/bfc243a3gy1febm7sdk4lj20ib0i714u.jpg",
                "http://wx4.sinaimg.cn/thumbnail/bfc243a3gy1febm7tekewj20i20i4aoy.jpg",
                "http://wx3.sinaimg.cn/thumbnail/bfc243a3gy1febm7usmc8j20i543zngx.jpg",]
    }()
    
    private lazy var highQualityImageUrls: [String] = {
        return ["http://wx3.sinaimg.cn/large/bfc243a3gy1febm7nzbz7j20ib0iek5j.jpg",
                "http://wx1.sinaimg.cn/large/bfc243a3gy1febm7n9eorj20i60hsann.jpg",
                "http://wx1.sinaimg.cn/large/bfc243a3gy1febm7orgqfj20i80ht15x.jpg",
                "http://wx2.sinaimg.cn/large/bfc243a3gy1febm7pmnk7j20i70jidwo.jpg",
                "http://wx3.sinaimg.cn/large/bfc243a3gy1febm7qjop4j20i00hw4c6.jpg",
                "http://wx4.sinaimg.cn/large/bfc243a3gy1febm7rncxaj20ek0i74dv.jpg",
                "http://wx2.sinaimg.cn/large/bfc243a3gy1febm7sdk4lj20ib0i714u.jpg",
                "http://wx4.sinaimg.cn/large/bfc243a3gy1febm7tekewj20i20i4aoy.jpg",
                "http://wx3.sinaimg.cn/large/bfc243a3gy1febm7usmc8j20i543zngx.jpg",]
    }()
    
    weak private var selectedCell: MomentsPhotoCollectionViewCell?
    
    private var collectionView: UICollectionView?
    
    deinit {
        #if DEBUG
        print("deinit:\(self)")
        #endif
    }
    
    override func viewDidLoad() {
        let colCount = 3
        let rowCount = 3
        
        let xMargin: CGFloat = 60.0
        let interitemSpacing: CGFloat = 10.0
        let width: CGFloat = self.view.bounds.size.width - xMargin * 2
        let itemSize: CGFloat = (width - 2 * interitemSpacing) / CGFloat(colCount)
        
        let lineSpacing: CGFloat = 10.0
        let height = itemSize * CGFloat(rowCount) + lineSpacing * 2
        let y: CGFloat = 60.0
        
        let frame = CGRect(x: xMargin, y: y, width: width, height: height)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = interitemSpacing
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.register(MomentsPhotoCollectionViewCell.self, forCellWithReuseIdentifier: MomentsPhotoCollectionViewCell.defalutId)
        
        view.addSubview(cv)
        
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = UIColor.white
        collectionView = cv
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
}

extension MomentsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbnailImageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MomentsPhotoCollectionViewCell.defalutId, for: indexPath) as! MomentsPhotoCollectionViewCell
        cell.imageView.kf.setImage(with: URL(string: thumbnailImageUrls[indexPath.row]))
        return cell
    }
}

extension MomentsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MomentsPhotoCollectionViewCell else {
            return
        }
        selectedCell = cell
        
        // 直接打开图片浏览器
        PhotoBrowser.show(delegate: self, originPageIndex: indexPath.item)
        
        // 也可以先创建，然后传参，再打开
        //openPhotoBrowserWithInstanceMethod(index: indexPath.item)
    }
    
    private func openPhotoBrowserWithInstanceMethod(index: Int) {
        // 创建图片浏览器
        let browser = PhotoBrowser()
        // 提供两种动画效果：缩放`.scale`和渐变`.fade`。
        browser.animationType = .scale
        // 浏览器协议实现者
        browser.photoBrowserDelegate = self
        // 装配页码指示器插件，提供了两种PageControl实现，若需要其它样式，可参照着自由定制
        // 光点型页码指示器
        browser.plugins.append(DefaultPageControlPlugin())
        // 数字型页码指示器
        browser.plugins.append(NumberPageControlPlugin())
        // 装配图片描述插件
        browser.plugins.append(DescriptionPlugin())
        // 指定打开图片组中的哪张
        browser.originPageIndex = index
        // 展示
        self.present(browser, animated: true, completion: nil)
        /*
        // 可主动关闭图片浏览器
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            browser.dismiss(animated: false)
        }*/
    }
}

// 实现浏览器代理协议
extension MomentsViewController: PhotoBrowserDelegate {
    /// 共有多少张图片
    func numberOfPhotos(in photoBrowser: PhotoBrowser) -> Int {
        return thumbnailImageUrls.count
    }
    
    /// 缩放动画起始图，也是图片加载完成前的 placeholder
    func photoBrowser(_ photoBrowser: PhotoBrowser, originImageForIndex index: Int) -> UIImage? {
        let cell = collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as? MomentsPhotoCollectionViewCell
        return cell?.imageView.image
    }
    
    /// 缩放起始视图
    func photoBrowser(_ photoBrowser: PhotoBrowser, originViewForIndex index: Int) -> UIView? {
        return collectionView?.cellForItem(at: IndexPath(item: index, section: 0))
    }
    
    /// 高清图
    func photoBrowser(_ photoBrowser: PhotoBrowser, highQualityUrlForIndex index: Int) -> URL? {
        // 测试Gif
        if index == 1 {
            return URL(string: "http://img.gaoxiaogif.cn/GaoxiaoGiffiles/images/2015/07/10/maomiqiangqianbuhuan.gif")
        }
        return URL(string: highQualityImageUrls[index])
    }
    
    /// 原图
    func photoBrowser(_ photoBrowser: PhotoBrowser, rawUrlForIndex index: Int) -> URL? {
        // 测试原图
        if index == 5 {
            return URL(string: "http://seopic.699pic.com/photo/00040/8565.jpg_wh1200.jpg")
        }
        return nil
    }
    
    /// 加载本地图片，本地图片的展示将优先于网络图片
    func photoBrowser(_ photoBrowser: PhotoBrowser, localImageForIndex index: Int) -> UIImage? {
        // 测试本地图
        if index == 3 {
            return UIImage(named: "xingkong")
        }
        return nil
    }
    
    /// 长按图片。你可以在此处得到当前图片，并可以做弹窗，保存图片等操作
    func photoBrowser(_ photoBrowser: PhotoBrowser, didLongPressForIndex index: Int, image: UIImage) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let saveImageAction = UIAlertAction(title: "保存图片", style: .default) { (_) in
            print("保存图片：\(image)")
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        actionSheet.addAction(saveImageAction)
        actionSheet.addAction(cancelAction)
        photoBrowser.present(actionSheet, animated: true, completion: nil)
    }
    
    /// 即将关闭图片浏览器
    func photoBrowser(_ photoBrowser: PhotoBrowser, willDismissWithIndex index: Int, image: UIImage?) {
        print("即将关闭图片浏览器，index:\(index)")
    }
    
    /// 已经关闭图片浏览器
    func photoBrowser(_ photoBrowser: PhotoBrowser, didDismissWithIndex index: Int, image: UIImage?) {
        print("已经关闭图片浏览器，index:\(index)")
    }
}


