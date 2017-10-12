//
//  ImageCellCollectionCell++.swift
//  carryonex
//
//  Created by Xin Zou on 10/9/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit





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


