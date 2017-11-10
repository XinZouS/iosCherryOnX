//
//  ImageCell.swift
//  carryonex
//
//  Created by Xin Zou on 10/7/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


struct ImageNamePair {
    var name : String?
    var image: UIImage?
    
    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
    
}

/// MARK: - ImageCell for RequestController:

class ImageCell: RequestBaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    // number of images = [1,6]
//    var images : [UIImage] = [#imageLiteral(resourceName: "CarryonExIcon-29"), #imageLiteral(resourceName: "yadianwenqing"), #imageLiteral(resourceName: "CarryonEx_OnBoarding-02-1")] {
    var images : [ImageNamePair] = [] {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    let cellId = "ImageCellCollectionCellId"
    let cellAddId = "ImageCellCollectionAddButtonCellId"

    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.dataSource = self
        v.delegate = self
        v.isPagingEnabled = false
        v.backgroundColor = .white
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textField.isHidden = true
        textField.allowsEditingTextAttributes = false
        textField.isUserInteractionEnabled = false
        
        setupTitleLabel()
        setupCollectionView()
    }
    
    override func setupTitleLabel(){
        addSubview(titleLabel)
        titleLabel.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 95, height: 30)
    }
    
    func setupCollectionView(){
        collectionView.register(ImageCellCollectionCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(ImageCellCollectionAddButtonCell.self, forCellWithReuseIdentifier: cellAddId)
        
        let margin : CGFloat = 20
        let width: CGFloat = (self.bounds.height - 20) * (4 / 3)
        addSubview(collectionView)
        collectionView.addConstraints(left: leftAnchor, top: titleLabel.bottomAnchor, right: rightAnchor, bottom: underlineView.topAnchor, leftConstent: margin, topConstent: 5, rightConstent: margin, bottomConstent: 15, width: width, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - CollectionView delegate

extension ImageCell {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    // number of images = [1,6]
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(images.count + 1, 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = ImageCellCollectionCell()
        
        // number of images = [1,6]
        if indexPath.item < images.count || (images.count == 6) {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCellCollectionCell
            cell.imageFileName = images[indexPath.item].name!
            cell.imageView.image = images[indexPath.item].image!
        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellAddId, for: indexPath) as! ImageCellCollectionAddButtonCell
        }
        cell.requestCtl = self.requestController
        cell.backgroundColor = .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let s : CGFloat = (collectionView.bounds.width - 20) / (UIDevice.current.userInterfaceIdiom == .phone ? 3 : 6)
        return CGSize(width: s, height: s)
    }
}


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
