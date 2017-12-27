//
//  GiftController.swift
//  carryonex
//
//  Created by Xin Zou on 10/30/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit


class GiftController: UIViewController {
    
    var silenceCarouselView : SilenceCarouselView?
    
    let imgCarouselArray: [Any] = [
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
        s.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.gray], for: .normal)
        s.selectedSegmentIndex = 0
        return s
    }()
    
    let cellIdPrize = "cellIdPrize"
    let cellIdYoupiao = "cellIdYoupiao"
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3

        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = .clear
        v.dataSource = self
        v.delegate = self
        return v
    }()
    
    var luckyPrizes = ["1", "2", "3", "1", "2", "3"]
    var youpiaoExchanges = ["1", "2", "3", "2", "3"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSilenceCarouseView()
        setupDetailBarView()
        //setupSegmentBar()
        setupCollectionView()
    }
    
    
    
    private func setupNavigationBar(){
        title = "福利专区"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        view.backgroundColor = pickerColorLightGray
        
        let cancelButton = UIBarButtonItem(image: #imageLiteral(resourceName: "CarryonEx_Back"), style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
        
        let detailButton = UIBarButtonItem(title: "兑换明细", style: .plain, target: self, action: #selector(detailButtonTapped))
        navigationItem.rightBarButtonItem = detailButton
    }
    private func setupSilenceCarouseView(){
        let h = view.bounds.height / 5
        let yOffset: CGFloat = (self.navigationController?.navigationBar.bounds.height ?? 0) + UIApplication.shared.statusBarFrame.height
        let f = CGRect(x: 0, y: yOffset, width: view.bounds.width, height: h)
        silenceCarouselView = SilenceCarouselView(frame: f, imageArray: imgCarouselArray, silenceCarouselViewTapBlock: { (silenceCarView, page) in
            print("GiftController: setupSilenceCarouseView(), tap block: page = \(page)")
        })
        silenceCarouselView?.timeInterval = 2
        view.addSubview(silenceCarouselView!)
        
        silenceCarouseImageReload()
    }
    
    private func setupDetailBarView(){
        detailBarView.giftCtl = self
        view.addSubview(detailBarView)
        detailBarView.addConstraints(left: view.leftAnchor, top: silenceCarouselView?.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 50)
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
        collectionView.reloadData()
    }
    
    private func setupCollectionView(){
        collectionView.backgroundColor = .clear
        //collectionView.register(GiftPrizeCell.self, forCellWithReuseIdentifier: cellIdPrize)
        collectionView.register(GiftYoupiaoCell.self, forCellWithReuseIdentifier: cellIdYoupiao)

        let sideMargin: CGFloat = 20
        view.addSubview(collectionView)
        collectionView.addConstraints(left: view.leftAnchor, top: detailBarView.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: sideMargin, topConstent: 1, rightConstent: sideMargin, bottomConstent: 0, width: 0, height: 0)

        //collectionView.contentInset = UIEdgeInsetsMake(<#T##top: CGFloat##CGFloat#>, <#T##left: CGFloat##CGFloat#>, <#T##bottom: CGFloat##CGFloat#>, <#T##right: CGFloat##CGFloat#>) // t,l,b,r
        //collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(<#T##top: CGFloat##CGFloat#>, <#T##left: CGFloat##CGFloat#>, <#T##bottom: CGFloat##CGFloat#>, <#T##right: CGFloat##CGFloat#>)
    }

}

extension GiftController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return youpiaoExchanges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdYoupiao, for: indexPath) as! GiftYoupiaoCell
        //TODO: setup cell data
        
        return cell
    }
    
}

extension GiftController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2 - 2, height: 180)
    }
    
}

extension GiftController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selecting at : .item = \(indexPath.item)")
    }
    
}




extension GiftController {
    
    func silenceCarouseImageReload(){
        silenceCarouselView?.imageArray = imgCarouselArray
        silenceCarouselView?.reload()
    }
    
    
    func cancelButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func detailButtonTapped(){
//        self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
    }
    
    
}
