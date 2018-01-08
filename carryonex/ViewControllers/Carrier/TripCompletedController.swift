//
//  TripCompletedController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/22.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import AlamofireImage

class TripCompletedController : UIViewController{
    
    @IBOutlet weak var titleHintLabel: UILabel!
    @IBOutlet weak var beginLocationLabel: UILabel!
    @IBOutlet weak var endLocationLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var youxiangLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    
    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardInformation()
        setupBackGroundColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavigationBar()
    }
    
    private func setupCardInformation(){
        beginLocationLabel.text = trip?.startAddress?.fullAddressString()
        endLocationLabel.text = trip?.endAddress?.fullAddressString()
        monthLabel.text = trip?.getMonthString()
        dayLabel.text = trip?.getDayString()
        descriptionLabel.text = trip?.note
        youxiangLabel.text = trip?.tripCode
        if let currentUser = ProfileManager.shared.getCurrentUser(){
            if let urlString = currentUser.imageUrl, let url = URL(string:urlString){
                userImage.af_setImage(withURL: url)
            }else{
                userImage.image = #imageLiteral(resourceName: "blankUserHeadImage")
            }
        }
    }
    
    private func setupBackGroundColor(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        let beginColor :UIColor = UIColor.MyTheme.nightA
        let endColor :UIColor = UIColor.MyTheme.nightB
        gradientLayer.colors = [beginColor.cgColor,endColor.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupNavigationBar(){
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationItem.leftBarButtonItem = UIBarButtonItem()
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        if let trip = trip {
            AnalyticsManager.shared.startTimeTrackingKey(.carrierShareTime)
            let sharingAlertVC = ShareViewFactory().setupShare(self, trip: trip)
            if UIDevice.current.userInterfaceIdiom != .phone {
                sharingAlertVC.popoverPresentationController?.sourceView = self.shareButton
            }
            self.present(sharingAlertVC, animated: true, completion: nil)
        } else {
            debugPrint("Unable to find trip")
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}

