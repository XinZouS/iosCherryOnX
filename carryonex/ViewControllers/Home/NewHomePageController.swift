//
//  NewHomePageController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/9.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

extension UIColor {
    struct MyTheme {
        static var darkGreen: UIColor  { return UIColor(red: 0.1549919546, green: 0.2931276262, blue: 0.3640816808, alpha: 1) }
        static var purple: UIColor { return UIColor(red: 0.8728510737, green: 0.758017838, blue: 0.8775048256, alpha: 1) }
        static var grey : UIColor{ return UIColor(red: 0.7805191875, green: 0.7680291533, blue: 0.8010284305, alpha: 1)}
        static var littleGreen : UIColor{ return UIColor(red: 0.7296996117, green: 0.8510946035, blue: 0.8725016713, alpha: 1)}
        static var mediumGreen : UIColor{ return UIColor(red: 0.2490211129, green: 0.277058661, blue: 0.4886234403, alpha: 1)}
        static var cyan : UIColor{ return UIColor(red: 0.261000365, green: 0.6704152226, blue: 0.7383304834, alpha: 1)}
    }
}

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
    var activityIndicator: UIActivityIndicatorCustomizeView! // UIActivityIndicatorView!
    // paramter to send to other field
    var imageurl = ""
    var realname = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNowHour()
        setupBackGroundColor()
        setupActivityIndicator()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "shiper"){
            if let destVC = segue.destination as? UserCardViewController {
                destVC.viewTag = 0
            }
        }
        if (segue.identifier == "sender"){
            if let destVC = segue.destination as? UserCardViewController {
                destVC.viewTag = 1
            }
        }
    }
    
    private func setupActivityIndicator(){
        activityIndicator = UIActivityIndicatorCustomizeView() // UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.center = view.center
        activityIndicator.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        view.addSubview(activityIndicator)
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
        switch timeStatus {
        case "night":
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            let beginColor :UIColor = UIColor.MyTheme.darkGreen
            let endColor :UIColor = UIColor.MyTheme.purple
            gradientLayer.colors = [beginColor.cgColor,endColor.cgColor]
        default:
            let beginColor :UIColor = UIColor.MyTheme.grey
            let endColor :UIColor = UIColor.MyTheme.littleGreen
            gradientLayer.colors = [beginColor.cgColor,endColor.cgColor]
        }
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

