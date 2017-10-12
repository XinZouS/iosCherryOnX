//
//  ImageCell++.swift
//  carryonex
//
//  Created by Xin Zou on 10/7/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation



extension ImageCell {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == images.count { // adding image cell tapped
            requestController?.openALCameraController()
        }
    }
    
    func removeImagePairOfName(imgName: String) {
        for i in 0..<images.count {
            print("get imageName = \(images[i].name!), target name = \(imgName), trying to remove it...")
            if images[i].name! == imgName {
                images.remove(at: i)
                requestController?.imageUploadingSet.remove(imgName)
                requestController?.imageUploadSequence.removeValue(forKey: imgName)
                print("OK, remove file success: \(imgName)")
                return
            }
        }
    }
    
    
}





