//
//  PhotoBrowserAnimator.swift
//  PhotoBrowser-swift
//
//  Created by haorise on 2018/3/28.
//  Copyright © 2018年 haorise. All rights reserved.
//

import UIKit

// 面向协议开发
protocol AnimatorPresentDelegate : NSObjectProtocol {
    func startRect(indexPath : NSIndexPath) -> CGRect
    func endRect(indexPath : NSIndexPath) -> CGRect
    func imageView(indexPath : NSIndexPath) -> UIImageView
}

protocol AnimatorDismissDelegate : NSObjectProtocol {
    func indexPathForDismissView() -> NSIndexPath
    func imageViewForDismissView() -> UIImageView
}

class PhotoBrowserAnimator: NSObject {
    var isPresented = false
    
    var presentedDelegate : AnimatorPresentDelegate?
    var dismissDelegate : AnimatorDismissDelegate?
    var indexPath : NSIndexPath?
}

extension PhotoBrowserAnimator : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self as UIViewControllerAnimatedTransitioning?
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self as UIViewControllerAnimatedTransitioning?
    }
}

extension PhotoBrowserAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animateTransitionForPresentedView(using: transitionContext) : animateTransitionForDismissView(using: transitionContext)
    }
}
// MARK:- 私有方法
extension PhotoBrowserAnimator {
    func animateTransitionForPresentedView(using transitionContext: UIViewControllerContextTransitioning) {
        // 0.nil值校验
        guard let _ = presentedDelegate, let _ = indexPath else {
            return
        }
        
        // 1.取出弹出的View
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        // 2.将presentedView添加到containerView中
        transitionContext.containerView.addSubview(presentedView!)
        
        // 3.获取执行动画的imageView
        let startRect = presentedDelegate?.startRect(indexPath: indexPath!)
        let imageView = presentedDelegate?.imageView(indexPath: indexPath!)
        transitionContext.containerView.addSubview(imageView!)
        imageView?.frame = startRect!
        
        // 4.执行动画
        presentedView?.alpha = 0
        transitionContext.containerView.backgroundColor = UIColor.black
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView?.frame = (self.presentedDelegate?.endRect(indexPath: self.indexPath!))!
        }) { (_) -> Void in
            imageView?.removeFromSuperview()
            presentedView?.alpha = 1
            transitionContext.containerView.backgroundColor = UIColor.clear
            transitionContext.completeTransition(true)
        }
    }
    func animateTransitionForDismissView(using transitionContext: UIViewControllerContextTransitioning) {
        guard let _ = dismissDelegate, let _ = presentedDelegate else {
            return
        }
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        dismissView?.removeFromSuperview()
        
        let imageView = dismissDelegate?.imageViewForDismissView()
        transitionContext.containerView.addSubview(imageView!)
        let indexPath = dismissDelegate?.indexPathForDismissView()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView?.frame = (self.presentedDelegate?.startRect(indexPath: indexPath!))!
        }) { (_) -> Void in
            transitionContext.completeTransition(true)
        }
        
        
    }
}
