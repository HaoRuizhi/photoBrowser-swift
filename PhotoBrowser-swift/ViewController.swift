//
//  ViewController.swift
//  PhotoBrowser-swift
//
//  Created by haorise on 2018/3/28.
//  Copyright © 2018年 haorise. All rights reserved.
//

import UIKit
import YYKit

let HomeCollectionViewCellID = "HomeCollectionViewCellID"
class ViewController: UIViewController, AnimatorPresentDelegate {
    
    let modalAnimator = PhotoBrowserAnimator()
    var imageModels : [PBImageModel]? = {
        
        var rawArray : [[String : Any]] = [["sPicUrl":"https://wx3.sinaimg.cn/orj360/a69337f3ly1fkt61goaw0g2078078npg.gif","bPicUrl":"https://wx3.sinaimg.cn/large/a69337f3ly1fkt61goaw0g2078078npg.gif","width": "260","height": "260"],
        ["sPicUrl":"https://wx1.sinaimg.cn/orj360/bf4ee2c0gy1fkmgply1jzj20m80gbjve.jpg","bPicUrl":"https://wx1.sinaimg.cn/large/bf4ee2c0gy1fkmgply1jzj20m80gbjve.jpg","width": "367","height": "270"],
        ["sPicUrl":"https://wx2.sinaimg.cn/orj360/bf4ee2c0gy1fkmgpmspk0j20hs0c2770.jpg","bPicUrl":"https://wx2.sinaimg.cn/large/bf4ee2c0gy1fkmgpmspk0j20hs0c2770.jpg","width": "398","height": "270"],
        ["sPicUrl":"https://wx2.sinaimg.cn/orj360/bf4ee2c0gy1fkmgpn5gvvj20g20bgmz8.jpg","bPicUrl":"https://wx2.sinaimg.cn/large/bf4ee2c0gy1fkmgpn5gvvj20g20bgmz8.jpg","width": "378","height": "270"],
        ["sPicUrl":"https://wx1.sinaimg.cn/orj360/6961aadegy1fkuhb2qqocj20t60xc13m.jpg","bPicUrl":"https://wx1.sinaimg.cn/large/6961aadegy1fkuhb2qqocj20t60xc13m.jpg","width": "360","height": "411"],
        ["sPicUrl":"https://wx2.sinaimg.cn/orj360/6961aadegy1fkuhb0cl6rj20s50xck1k.jpg","bPicUrl":"https://wx2.sinaimg.cn/large/6961aadegy1fkuhb0cl6rj20s50xck1k.jpg","width": "360","height": "426"],
        ["sPicUrl":"https://wx3.sinaimg.cn/orj360/6961aadegy1fkuhb1wdb7j20qy0xcajx.jpg","bPicUrl":"https://wx3.sinaimg.cn/large/6961aadegy1fkuhb1wdb7j20qy0xcajx.jpg","width": "360","height": "445"],
        ["sPicUrl":"https://wx1.sinaimg.cn/orj360/6961aadegy1fkuhb382fej20pb0xcqch.jpg","bPicUrl":"https://wx1.sinaimg.cn/large/6961aadegy1fkuhb382fej20pb0xcqch.jpg","width": "360","height": "474"],
        ["sPicUrl":"https://wx2.sinaimg.cn/orj360/6961aadegy1fkuhb24hknj20qp0xcn6m.jpg","bPicUrl":"https://wx2.sinaimg.cn/large/6961aadegy1fkuhb24hknj20qp0xcn6m.jpg","width": "360","height": "449"]]
        
        var imageModelArray = [PBImageModel]()
        for (index, value) in rawArray.enumerated() {
            let imageModel = PBImageModel(dicValue: value)
            imageModelArray.append(imageModel)
        }
        
        return imageModelArray
    }()
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }


}

// MARK: -私有方法
extension ViewController {
    private func setupUI() {
        let layout : UICollectionViewFlowLayout  = imageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width * 0.3, height: UIScreen.main.bounds.size.width * 0.3)
        let spacing = UIScreen.main.bounds.size.width * 0.025
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        imageCollectionView.collectionViewLayout = layout
        imageCollectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCellID)
        imageCollectionView.reloadData()
    }
    private func gotoPhotoBrowserVC(indexPath : IndexPath) {
        let browserVC = PhotoBrowserController(indexPath: indexPath as NSIndexPath, imageArray: imageModels!)
        // 2.设置modal样式
        browserVC.modalPresentationStyle = .custom
        // 3.设置转场的代理
        browserVC.transitioningDelegate = modalAnimator
        modalAnimator.indexPath = indexPath as NSIndexPath
        modalAnimator.presentedDelegate = self as AnimatorPresentDelegate
        modalAnimator.dismissDelegate = (browserVC as AnimatorDismissDelegate)
        present(browserVC, animated: true, completion: nil)
    }
}

// MARK: -设置collectionView代理
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print((imageModels?.count)!)
        return (imageModels?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let homeCell : HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCellID, for: indexPath) as! HomeCollectionViewCell
        let imageModel = imageModels![indexPath.row]
        homeCell.imageURLStr = imageModel.sPicUrl
        return homeCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        gotoPhotoBrowserVC(indexPath: indexPath)
    }
}

// MARK: -AnimatorPresentedDelegate
extension ViewController {
    func startRect(indexPath: NSIndexPath) -> CGRect {
        // 1.获取cell
        let cell = imageCollectionView.cellForItem(at: indexPath as IndexPath)
        
        // 2.获取cell的frame
        let startFrame = imageCollectionView.convert((cell?.frame)!, to: UIApplication.shared.keyWindow)
        return startFrame;
    }
    func endRect(indexPath: NSIndexPath) -> CGRect {
        // 1.获取该位置的image对象
        let imageModel = imageModels![indexPath.item]
        
        // 2.计算结束后的frame
        let w = UIScreen.main.bounds.size.width
        let h = w / imageModel.width * imageModel.height
        let y = h < UIScreen.main.bounds.size.height ? (UIScreen.main.bounds.size.height - h) * 0.5 : 0
        
        return CGRect(x: 0, y: y, width: w, height: h)
    }
    func imageView(indexPath: NSIndexPath) -> UIImageView {
        // 1.创建UIImageView对象
        let imageView = UIImageView()
        
        // 2.获取该位置的image对象
        let imageModel = imageModels![indexPath.item]
        let image = YYWebImageManager.shared().cache?.getImageForKey(imageModel.sPicUrl)
        
        // 3.设置imageView的属性
        imageView.image = image;
        imageView.contentMode = UIViewContentMode.scaleToFill;
        imageView.clipsToBounds = true;
        
        return imageView;
    }
}

