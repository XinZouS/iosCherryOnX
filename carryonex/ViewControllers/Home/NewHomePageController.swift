//
//  NewHomePageController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/9.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

class NewHomePageController :UIViewController{
    enum timeEnum: Int{
    case morning = 6
    case noon = 12
    case afternoon = 14
    case night = 18
    }
    var nowHour :String = ""
    var timeStatus :String = ""
    var gradientLayer: CAGradientLayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNowHour()
        setupBackGroundColor()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    private func setupNowHour(){
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyyMMddHHmmssSSS"
        let strNowTime = timeFormatter.string(from: date) as String
        let StartIndex = strNowTime.index(strNowTime.startIndex, offsetBy: 8)
        let endIndex = strNowTime.index(strNowTime.startIndex, offsetBy: 9)
        nowHour = String(strNowTime[StartIndex]) + String(strNowTime[endIndex])
        if let nowHourInt = Int(nowHour){
            if nowHourInt >= timeEnum.night.rawValue || nowHourInt < timeEnum.morning.rawValue { // night
                timeStatus = "night"
            }else if nowHourInt >= timeEnum.afternoon.rawValue {
                timeStatus = "afternoon"
            }else if nowHourInt >= timeEnum.noon.rawValue{
                timeStatus = "noon"
            }else{
                timeStatus = "morning"
            }
        }
    }
    private func setupBackGroundColor(){
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        switch timeStatus {
        case "night":
            let beginColor :UIColor = UIColor(red: 0.1592482924, green: 0.1658681333, blue: 0.3862371445, alpha: 1)
            let endColor :UIColor = UIColor(red: 0.2750508785, green: 0.3392701447, blue: 0.5798990726, alpha: 1)
            gradientLayer.colors = [beginColor.cgColor,endColor.cgColor]
        default:
            let beginColor :UIColor = UIColor(red: 0.1592482924, green: 0.1658681333, blue: 0.3862371445, alpha: 1)
            let endColor :UIColor = UIColor(red: 0.2750508785, green: 0.3392701447, blue: 0.5798990726, alpha: 1)
            gradientLayer.colors = [beginColor.cgColor,endColor.cgColor]
        }
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
