//
//  PBImageModel.swift
//  PhotoBrowser-swift
//
//  Created by haorise on 2018/3/29.
//  Copyright © 2018年 haorise. All rights reserved.
//

import UIKit

@objcMembers
class PBImageModel: NSObject {
    // 小图图片下载地址
   var sPicUrl : String = ""
    // 大图图片下载地址
   var bPicUrl : String?
    // 图片宽高比
   var width : CGFloat  = 1
   var height : CGFloat = 0
    
   init(dicValue: [String : Any]) {
        super.init()
        setValuesForKeys(dicValue)
    }
    
   override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
        if key == "sPicUrl" {
            sPicUrl = value as! String
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
