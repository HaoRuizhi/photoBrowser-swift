//
//  ProgressView.swift
//  PhotoBrowser-swift
//
//  Created by haorise on 2018/3/28.
//  Copyright © 2018年 haorise. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    // MARK:- 定义属性
    var progress : CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK:- 重写drawRect方法
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // 获得基本参数
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = rect.width * 0.5
        let startEngle = CGFloat(-Double.pi / 2)
        let endEngle = CGFloat(Double.pi * 2) * progress + startEngle
        // 创建贝塞尔曲线
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startEngle, endAngle: endEngle, clockwise: true)
        
        // 绘制一条线到中心
        path.addLine(to: center)
        path.close()
        // 设置填充颜色
        UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).setFill()
        // 开始绘制
        path.fill()
    }
    
}
