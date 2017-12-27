//
//  ImageCellCollectionCell.swift
//  carryonex
//
//  Created by Xin Zou on 10/9/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

/// MARK: - the cell for single image presen and selection
class ImageCellCollectionCell : UICollectionViewCell {
    
    weak var requestCtl : RequestController?
    
    var imageFileName : String = ""
    
    let imageView : UIImageView = {
        let v = UIImageView()
        v.image = #imageLiteral(resourceName: "CarryonExIcon-29")
        v.contentMode = .scaleAspectFill
        v.layer.cornerRadius = 5
        v.layer.masksToBounds = true
        return v
    }()
    
    lazy var cancelButton : UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        b.setImage(#imageLiteral(resourceName: "CarryonEx_Close"), for: .normal)
        b.backgroundColor = UIColor(white: 1, alpha: 0.3)
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupImageView()
        setupCancelButton()
    }
    
    func setupImageView(){
        addSubview(imageView)
        imageView.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
    }
    
    func setupCancelButton(){
        let margin: CGFloat = 10
        let sz    : CGFloat = 15
        cancelButton.layer.cornerRadius = sz / 2
        cancelButton.layer.masksToBounds = true
        addSubview(cancelButton)
        cancelButton.addConstraints(left: nil, top: topAnchor, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: margin, rightConstent: margin, bottomConstent: 0, width: sz, height: sz)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


/// The last button in CollectionView for adding Button
class ImageCellCollectionAddButtonCell : ImageCellCollectionCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cancelButton.isHidden = true
        cancelButton.isEnabled = false
        
        imageView.image = #imageLiteral(resourceName: "CarryonEx_UploadID") // upload ID image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ImageCellCollectionCell {
    
    func cancelButtonTapped(){
        print("TODO: image cancelButtonTapped...")
        removeLocalImageWithFileName()
        removeLocalImageInCollectionView()
    }
    
    private func removeLocalImageWithFileName(){
        requestCtl?.removeImageWithUrlInLocalFileDirectory(fileName: imageFileName)
    }
    
    private func removeLocalImageInCollectionView(){
        requestCtl?.cell08Image?.removeImagePairOfName(imgName: imageFileName)
    }
}
