//
//  PhotoBrowerImageScrollView.swift
//  PhotoBrowser-swift
//
//  Created by haorise on 2018/4/3.
//  Copyright © 2018年 haorise. All rights reserved.
//

import UIKit
import YYKit

protocol PhotoBrowserScrollViewDelegate : NSObjectProtocol {
    func imageViewLongPressAction()
}

class PhotoBrowerImageScrollView: UIScrollView {
    let imageView = YYAnimatedImageView()
    var imageViewdelegate : PhotoBrowserScrollViewDelegate?
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        initAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PhotoBrowerImageScrollView : UIScrollViewDelegate {
    // 初始化方法
    private func initAction() {
        minimumZoomScale = 1
        maximumZoomScale = 2.5
        self.delegate = self
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(PhotoBrowerImageScrollView.imageViewTapAction))
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(PhotoBrowerImageScrollView.handleDoubleTapAction(_:)))
        doubleTap.numberOfTapsRequired = 2
        
        imageView.addGestureRecognizer(singleTap)
        imageView.addGestureRecognizer(doubleTap)
        singleTap.require(toFail: doubleTap)
        imageView.isUserInteractionEnabled = true
        
        addSubview(imageView)
        
        
    }
    private func handleZoomForLocation(_ location : CGPoint) {
        let touchPoint = superview?.convert(location, to: imageView)
        if zoomScale > 1 {
            setZoomScale(1, animated: true)
        } else if maximumZoomScale > 1 {
            let newZoomScale = maximumZoomScale
            let horizontalWidth = bounds.size.width / newZoomScale
            let verticalHeight = bounds.size.height / newZoomScale
            let zoomRect = CGRect(x: ((touchPoint?.x)! - horizontalWidth * 0.5), y: ((touchPoint?.y)! -  verticalHeight * 0.5), width: horizontalWidth, height: verticalHeight)
            zoom(to: zoomRect, animated: true)
        }
    }
    
    private func recenterImage() {
        let contentWidth = contentSize.width
        let horizontalDiff = self.bounds.size.width - contentWidth
        let horizontalAddtion : CGFloat = (CGFloat)(horizontalDiff > 0 ? horizontalDiff : 0)
        
        let contentHeight = contentSize.height
        let verticalDiff = self.bounds.size.height - contentHeight
        let verticalAddtion: CGFloat  = (CGFloat)(verticalDiff > 0 ? verticalDiff : 0)
        
        imageView.center = CGPoint(x: (contentWidth + horizontalAddtion) * 0.5, y: (contentHeight + verticalAddtion) * 0.5)
    }
    
    
}

// imageView点击事件监听
extension PhotoBrowerImageScrollView {
    // 图片点击手势事件
    @objc private func imageViewTapAction() {
        let myParentViewController : UIViewController? = getParentViewController()
        guard (myParentViewController != nil) else {
            return
        }
        
        myParentViewController?.dismiss(animated: true, completion: nil)
    }
    @objc private func handleDoubleTapAction(_ doubleTapGesture: UITapGestureRecognizer) {
        if doubleTapGesture.state != .ended {
            return
        }
        let location = doubleTapGesture.location(in: self)
        handleZoomForLocation(location)
    }
    // 图片长按事件
    @objc private func imageViewLongPressAction() {
        imageViewdelegate?.imageViewLongPressAction()
    }
    
    // 获得父控制器
    private func getParentViewController() -> UIViewController? {
        var nextResponder = next
        while nextResponder != nil {
            nextResponder = nextResponder?.next
            if (nextResponder is UIViewController) {
                return nextResponder as? UIViewController
            }
        }
        return nil
    }
}

// #MARK: - UIScrollViewDelegate
extension PhotoBrowerImageScrollView {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        recenterImage()
    }
}
