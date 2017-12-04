//
//  TripCompletedController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/22.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit

class TripCompletedController:UIViewController{
    @IBOutlet weak var beginLocationLabel: UILabel!
    @IBOutlet weak var endLocationLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var youxiangLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    var alert: UIAlertController?
    var gradientLayer: CAGradientLayer!
    var dateString :String!
    var beginLocationString:String!
    var endLocationString:String!
    var descriptionString: String!
    var tripId:Int!
    var startState:String!
    var endState:String!
    
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
        var monthString = ""
        switch month{
        case "01":
            monthString = "JAN"
        case "02":
            monthString = "FEB"
        case "03":
            monthString = "MAR"
        case "04":
            monthString = "APR"
        case "05":
            monthString = "MAY"
        case "06":
            monthString = "JUN"
        case "07":
            monthString = "JULY"
        case "08":
            monthString = "AUG"
        case "09":
            monthString = "SEP"
        case "10":
            monthString = "OCT"
        case "11":
            monthString = "NOV"
        case "12":
            monthString = "DEC"
        default:
            break
        }
        monthLabel.text = monthString
        dayLabel.text = day
        descriptionLabel.text = descriptionString
        youxiangLabel.text = String(tripId)
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
        DispatchQueue.main.async {
            self.present(self.alert!, animated: true, completion:{})
        }
    }
    
    private func shareInformation(){
            if let youxiangId = self.youxiangLabel.text, let beginLocation = self.startState, let endLocation = self.endState, let dateTime = self.dateString {
            let startIndex = dateTime.index(dateTime.startIndex, offsetBy: 5)
            let EndIndex = dateTime.index(dateTime.startIndex, offsetBy: 10)
            let monthAnddayString = dateTime[startIndex...EndIndex]
            let title = "我的游箱号:\(youxiangId)"
            let msg = "我的游箱号:\(youxiangId) \n【\(monthAnddayString)】 \n【\(beginLocation)-\(endLocation)】"
            ShareManager.shared.SetupShareInfomation(shareMessage: msg,shareTitle:title)
        }
    }
    
    @IBAction func gobackToFirstPageButtonTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}

