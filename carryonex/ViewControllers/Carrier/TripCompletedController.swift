//
//  TripCompletedController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/22.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit
import AlamofireImage

class TripCompletedController:UIViewController{
    
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
    
    var alert: UIAlertController?
    var gradientLayer: CAGradientLayer!
    var dateString: String!
    var beginLocationString: String!
    var endLocationString: String!
    var descriptionString: String!
    var tripcode: String!
    var startState: String!
    var endState: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardInformation()
        setupBackGroundColor()
    }
    
    private func setupCardInformation(){
        beginLocationLabel.text = beginLocationString
        endLocationLabel.text = endLocationString
        let MonthStartIndex = dateString.index(dateString.startIndex, offsetBy: 5)
        let MonthEndIndex = dateString.index(dateString.startIndex, offsetBy: 6)
        let DayStartIndex = dateString.index(dateString.startIndex, offsetBy: 8)
        let DayEndIndex = dateString.index(dateString.startIndex, offsetBy: 9)
        let month = dateString[MonthStartIndex...MonthEndIndex]
        let day = dateString[DayStartIndex...DayEndIndex]
        monthLabel.text = getMonthString(month)
        dayLabel.text = day
        descriptionLabel.text = descriptionString
        youxiangLabel.text = tripcode
        if let currentUser = ProfileManager.shared.getCurrentUser(){
            if let urlString = currentUser.imageUrl, let url = URL(string:urlString){
                userImage.af_setImage(withURL: url)
            }else{
                userImage.image = #imageLiteral(resourceName: "blankUserHeadImage")
            }
        }
    }
    
    private func setupBackGroundColor(){
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        let beginColor :UIColor = UIColor.MyTheme.darkBlue
        let endColor :UIColor = UIColor.MyTheme.cyan
        gradientLayer.colors = [beginColor.cgColor,endColor.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        let isPhone = UIDevice.current.userInterfaceIdiom == .phone
        alert = ShareManager.shared.setupShareFrame()
        shareInformation()
        if !isPhone {
            alert?.popoverPresentationController?.sourceView = self.shareButton
        }
        self.present(self.alert!, animated: true, completion:{})
    }
    
    private func shareInformation(){
            if let youxiangId = self.youxiangLabel.text, let beginLocation = self.startState, let endLocation = self.endState, let dateTime = self.dateString {
            let startIndex = dateTime.index(dateTime.startIndex, offsetBy: 5)
            let EndIndex = dateTime.index(dateTime.startIndex, offsetBy: 10)
            let monthAnddayString = dateTime[startIndex...EndIndex]
            let title = "我的游箱号:\(youxiangId)"
            let msg = "我的游箱号:\(youxiangId) \n【\(monthAnddayString)】 \n【\(beginLocation)-\(endLocation)】"
            let url = "www.carryonex.com"
            ShareManager.shared.SetupShareInfomation(shareMessage: msg,shareTitle:title,shareUrl:url)
        }
    }
    
    private func getMonthString(_ month: String) -> String {
        switch month {
        case "01":
            return "JAN"
        case "02":
            return "FEB"
        case "03":
            return "MAR"
        case "04":
            return "APR"
        case "05":
            return "MAY"
        case "06":
            return "JUN"
        case "07":
            return "JULY"
        case "08":
            return "AUG"
        case "09":
            return "SEP"
        case "10":
            return "OCT"
        case "11":
            return "NOV"
        case "12":
            return "DEC"
        default:
            return "N/A"
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}

