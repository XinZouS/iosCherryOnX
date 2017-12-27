//
//  PhotoBrowserCollectionViewCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/23.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class PhotoBrowserCollectionViewCell: UICollectionViewCell {
    
    static var defalutId: String {
        return NSStringFromClass(self)
    }
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        imageView.frame = contentView.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

