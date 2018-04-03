//
//  PhotoBrowserViewCell.swift
//  PhotoBrowser-swift
//
//  Created by haorise on 2018/3/28.
//  Copyright © 2018年 haorise. All rights reserved.
//

import UIKit
import YYKit

protocol PhotoBrowserCellDelegate : NSObjectProtocol {
    func imageViewClick()
    func imageViewLongPressAction()
}

class PhotoBrowserViewCell: UICollectionViewCell {
    var picModel : PBImageModel? {
        didSet {
            setupContent(model: picModel)
        }
    }
    
    var delegate : PhotoBrowserCellDelegate?
    
    lazy var scrollView : PhotoBrowerImageScrollView? = PhotoBrowerImageScrollView()
    lazy var progressView : ProgressView? = ProgressView()
//    lazy var imageView : UIImageView? = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 设置UI页面
extension PhotoBrowserViewCell {
    private func setUpUI() {
        contentView.addSubview(scrollView!)
        contentView.addSubview(progressView!)
        
        scrollView?.frame = contentView.bounds
        scrollView?.frame.size.width -= 20
        progressView?.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView?.center = CGPoint(x: (scrollView?.frame.size.width)! * 0.5, y: (scrollView?.frame.size.height)! * 0.5)
        progressView?.backgroundColor = UIColor.clear
        
        let longPressTap = UILongPressGestureRecognizer(target: self, action: #selector(imageViewLongPressAction))
        scrollView?.addGestureRecognizer(longPressTap)
    }
}

// imageView点击事件监听
extension PhotoBrowserViewCell {
    // 图片长按事件
    @objc private func imageViewLongPressAction() {
        delegate?.imageViewLongPressAction()
    }
}

// 设置cell内容
extension PhotoBrowserViewCell {
    private func setupContent(model : PBImageModel?) {
        // 1.nil值校验
        guard let _ = model else {
            return
        }
        // 2.计算imageView的frame
        let width = scrollView?.frame.size.width
        let height = (width! / (model?.width)!) * (model?.height)!
        var y : CGFloat = 0
        if height < UIScreen.main.bounds.size.height {
            y = (UIScreen.main.bounds.size.height - height) * 0.5
        }
        scrollView?.imageView.frame = CGRect(x: 0, y: y, width: width!, height: height)
        // 3.取出加载好的小图
        let image = YYWebImageManager.shared().cache?.getImageForKey((model?.sPicUrl)!)
        
        // 4.设置imageView的图片
        progressView?.isHidden = false
        
        scrollView?.imageView.setImageWith(NSURL(string: (model?.bPicUrl)!) as URL?, placeholder: image, options: [], manager: YYWebImageManager.shared(), progress: { (current, total) in
            self.progressView?.progress = CGFloat(current) / CGFloat(total)
        }, transform: { (image, _) -> UIImage? in
            return image
        }, completion: { (_, _, _, _, _) in
            self.progressView?.isHidden = true
        })
    }
}







