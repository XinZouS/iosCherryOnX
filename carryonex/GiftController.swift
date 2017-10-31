//
//  GiftController.swift
//  carryonex
//
//  Created by Xin Zou on 10/30/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class GiftController: UIViewController {
    
    var silenceCarouselView : SilenceCarouselView?
    
    let imgArray: [Any] = [
//        "http://www.netbian.com/d/file/20150519/f2897426d8747f2704f3d1e4c2e33fc2.jpg",
//        "http://www.netbian.com/d/file/20130502/701d50ab1c8ca5b5a7515b0098b7c3f3.jpg",
//        URL(string: "http://www.netbian.com/d/file/20110418/48d30d13ae088fd80fde8b4f6f4e73f9.jpg")!,
        #imageLiteral(resourceName: "CarryonExIcon-29"), #imageLiteral(resourceName: "yadianwenqing"), #imageLiteral(resourceName: "CarryonEx_Waiting_B"), #imageLiteral(resourceName: "CarryonEx_OnBoarding-02-1")
    ]
    
    let detailBarView = DetailBarView()
    
    enum GiftTabSection: Int {
        case prize, youpiao
    }
    let segmentMargin: CGFloat = 15
    let segmentBar : UISegmentedControl = {
        let s = UISegmentedControl(items: ["幸运抽奖", "游票兑换"])
        s.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .selected)
        s.tintColor = buttonThemeColor // selected
        s.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.lightGray], for: .normal)
        s.backgroundColor = UIColor.gray // deselected
        s.selectedSegmentIndex = 0
        return s
    }()
    
    let cellIdPrize = "cellIdPrize"
    let cellIdYoupiao = "cellIdYoupiao"
    lazy var collectionView : UICollectionView = {
        let v = UICollectionView()
        v.backgroundColor = .clear
        v.dataSource = self
        v.delegate = self
        return v
    }()
    
    var dataSource = ["1", "2", "3"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSilenceCarouseView()
        setupDetailBarView()
        setupSegmentBar()
        setupCollectionView()
    }
    
    
    
    private func setupNavigationBar(){
        title = "福利专区"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        view.backgroundColor = pickerColorLightGray
    }
    private func setupSilenceCarouseView(){
        let h = view.bounds.height / 5
        let yOffset: CGFloat = (self.navigationController?.navigationBar.bounds.height ?? 0) + UIApplication.shared.statusBarFrame.height
        let f = CGRect(x: 0, y: yOffset, width: view.bounds.width, height: h)
        silenceCarouselView = SilenceCarouselView(frame: f, imageArray: imgArray, silenceCarouselViewTapBlock: { (silenceCarView, page) in
            print("GiftController: setupSilenceCarouseView(), tap block: page = \(page)")
        })
        silenceCarouselView?.timeInterval = 2
        view.addSubview(silenceCarouselView!)
        
        silenceCarouseImageReload()
    }
    
    private func setupDetailBarView(){
        detailBarView.giftCtl = self
        view.addSubview(detailBarView)
        detailBarView.addConstraints(left: view.leftAnchor, top: silenceCarouselView?.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 60)
    }
    
    private func setupSegmentBar(){
        segmentBar.addTarget(self, action: #selector(handleSegmentValueChanged), for: .valueChanged)
        view.addSubview(segmentBar)
        segmentBar.translatesAutoresizingMaskIntoConstraints = false
        segmentBar.addConstraints(left: view.leftAnchor, top: detailBarView.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 30, topConstent: segmentMargin, rightConstent: 30, bottomConstent: 0, width: 0, height: 40)
    }
    
    func handleSegmentValueChanged() {
        //guard let config = ApiServers.shared.config else { return }
        if segmentBar.selectedSegmentIndex == GiftTabSection.prize.rawValue {
            //bottomDataSource = config.sender
        } else if segmentBar.selectedSegmentIndex == GiftTabSection.youpiao.rawValue {
            //bottomDataSource = config.carrier
        }
        //tableView.setContentOffset(CGPoint.zero, animated: false)   //Bring table view back to the top
        //tableView.reloadData()
    }
    
    private func setupCollectionView(){
        collectionView.register(GiftPrizeCell.self, forCellWithReuseIdentifier: cellIdPrize)
        collectionView.register(GiftYoupiaoCell.self, forCellWithReuseIdentifier: cellIdYoupiao)
        let sideMargin: CGFloat = 30
        view.addSubview(collectionView)
        collectionView.addConstraints(left: view.leftAnchor, top: segmentBar.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: sideMargin, topConstent: segmentMargin, rightConstent: sideMargin, bottomConstent: 0, width: 0, height: 0)
    }

}

extension GiftController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if segmentBar.selectedSegmentIndex == GiftTabSection.prize.rawValue {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdPrize, for: indexPath) as! GiftPrizeCell
            //TODO: setup cell data
            
            return cell
        }
        else if segmentBar.selectedSegmentIndex == GiftTabSection.youpiao.rawValue {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdYoupiao, for: indexPath) as! GiftYoupiaoCell
            //TODO: setup cell data

            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
}

extension GiftController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 60)
    }
    
}

extension GiftController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selecting at : .item = \(indexPath.item)")
    }
    
}




extension GiftController {
    
    func silenceCarouseImageReload(){
        silenceCarouselView?.imageArray = imgArray
        silenceCarouselView?.reload()
    }
    
    
}
