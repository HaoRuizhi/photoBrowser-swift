//
//  HomeCollectionViewCell.swift
//  PhotoBrowser-swift
//
//  Created by haorise on 2018/3/30.
//  Copyright © 2018年 haorise. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    var pbImageView: UIImageView!
    
    var imageURLStr : String? {
        didSet {
            loadImage()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        pbImageView = UIImageView(frame: bounds)
        contentView.addSubview(pbImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: -加载图片
extension HomeCollectionViewCell {
    private func loadImage() {
        guard let _ = imageURLStr else {
            return
        }
        pbImageView.setImageWith(URL(string: imageURLStr!), options: [])
    }
}
