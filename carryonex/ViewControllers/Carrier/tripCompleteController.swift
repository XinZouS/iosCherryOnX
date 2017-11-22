//
//  tripCompleteController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/20.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit

class tripCompleteController:UIViewController{
    
    @IBOutlet weak var beginLocationLabel: UILabel!
    @IBOutlet weak var endLocationLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var dateString :String!
    var beginLocationString:String!
    var endLocationString:String!
    var descriptionString: String!
    var tripId:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardInformation()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    }
}
