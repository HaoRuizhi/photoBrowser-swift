//
//  PhotoBrowerController.swift
//  PhotoBrowser-swift
//
//  Created by haorise on 2018/3/28.
//  Copyright © 2018年 haorise. All rights reserved.
//

import UIKit
import SVProgressHUD

fileprivate let PhotoBrowserCellID = "PhotoBrowserCellID"
class PhotoBrowserController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK:- 定义属性
    var currentIndexPath : NSIndexPath
    var imageModels : [PBImageModel]
    
    // MARK:- 懒加载属性
    
    private lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserCollectionViewLayout())
    
    init(indexPath: NSIndexPath, imageArray: [PBImageModel]) {
        currentIndexPath = indexPath
        imageModels = imageArray
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        super.loadView()
        view.frame.size.width += 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
    }


}

// MARK:- 设置UI页面
extension PhotoBrowserController {
    private func setupUI() {
        // 1.添加子控件
        view.addSubview(collectionView)
        // 2.设置frame
        collectionView.frame = view.bounds
        
        // 3.设置collectionView单元格
        collectionView.register(PhotoBrowserViewCell.self, forCellWithReuseIdentifier: PhotoBrowserCellID)
        collectionView.frame = view.bounds
        
        // 4.设置代理
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // 5.滚动到具体的图片
        collectionView.scrollToItem(at: currentIndexPath as IndexPath, at: .left, animated: false)
    }
}

// MARK:- 点击事件监听
extension PhotoBrowserController {
    @objc private func closeBTNAction() {
        dismiss(animated: true, completion: nil)
    }
    private func saveImageAction() {
        // 1.获取当前正在显示的image
        let cell : PhotoBrowserViewCell = collectionView.visibleCells.first as! PhotoBrowserViewCell
        guard let image = cell.scrollView?.imageView.image else {
            return
        }
         UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSavedToPhotosAlbum(image:error:contextInfo:)), nil)
    }
    
    @objc func imageSavedToPhotosAlbum(image:UIImage,error:Error?,contextInfo:Any) {
        let showInfo = error == nil ? "保存成功" : "保存失败"
        SVProgressHUD.showInfo(withStatus: showInfo)
    }
    
}

extension PhotoBrowserController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : PhotoBrowserViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCellID, for: indexPath) as! PhotoBrowserViewCell
        cell.delegate = self
        cell.picModel = imageModels[indexPath.row]
        return cell
    }
    
}

extension PhotoBrowserController : AnimatorDismissDelegate {
    func indexPathForDismissView() -> NSIndexPath {
        let cell = collectionView.visibleCells.first
        return collectionView.indexPath(for: cell!)! as NSIndexPath
    }
    
    func imageViewForDismissView() -> UIImageView {
        let cell : PhotoBrowserViewCell = collectionView.visibleCells.first as! PhotoBrowserViewCell
        return cell.scrollView!.imageView
    }
    
}

extension PhotoBrowserController : PhotoBrowserCellDelegate {
    func imageViewClick() {
        closeBTNAction()
    }
    
    func imageViewLongPressAction() {
        // 判断是否有弹出的控制器
        guard self.presentedViewController == nil else {
            return
        }
        let alertViewController = UIAlertController(title: "", message: "确定保存图片", preferredStyle: .actionSheet)
        let alertViewAction = UIAlertAction(title: "确定", style: .default) { (_) in
            self.saveImageAction()
        }
        let cancelViewAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertViewController.addAction(alertViewAction)
        alertViewController.addAction(cancelViewAction)
        present(alertViewController, animated: true, completion: nil)
    }
    
}


// MARK:- 自定义布局
class PhotoBrowserCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        // 1.设置itemSize
        itemSize = (collectionView?.frame.size)!
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .horizontal
        
        // 2.设置CollectionView属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}
