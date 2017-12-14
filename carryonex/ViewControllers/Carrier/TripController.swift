//
//  TripController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/19.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit

class TripController: UIViewController{
    
    let segueIdTripComplete = "tripComplete"
    
    @IBOutlet weak var confirmTripButton: UIButton!
    
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupcomfirmTripButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupBackgroundColor()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == segueIdTripComplete) {
            if let viewController = segue.destination as? TripCompletedController, let trip = sender as? Trip {
                viewController.trip = trip
            }
        }
    }
    
    private func setupNavigationBar(){
        title = "出行"
        //UIApplication.shared.statusBarStyle = .default
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setupcomfirmTripButton(){
        confirmTripButton.isEnabled = false
        confirmTripButton.backgroundColor = #colorLiteral(red: 0.8972528577, green: 0.9214243889, blue: 0.9380477071, alpha: 1)
        confirmTripButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
    }
    
    private func setupBackgroundColor(){
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        let beginColor :UIColor = UIColor.MyTheme.nightBlue
        let endColor :UIColor = UIColor.MyTheme.nightCyan
        gradientLayer.colors = [beginColor.cgColor,endColor.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func commitTripInfo(_ sender: Any) {
        let trip = Trip()
        if let childVC = self.childViewControllers.first as? TripTableController {
            
            if childVC.pickUpDate < (Date().timeIntervalSince1970 - 86400) {    //86400 seconds/day
                self.displayAlert(title: "出行日期有误", message: "出行日期不能早于今天，请重新输入", action: "好")
                return
            }
            
            trip.endAddress?.state = childVC.endState
            trip.endAddress?.city = childVC.endCity
            trip.endAddress?.country = Country(rawValue:childVC.endCountry)
            trip.startAddress?.state = childVC.startState
            trip.startAddress?.city = childVC.startCity
            trip.startAddress?.country = Country(rawValue: childVC.startCountry)
            trip.pickupDate = childVC.pickUpDate
            trip.note = childVC.otherTextField.text
            ApiServers.shared.postTripInfo(trip: trip) { (success, msg, tripCode) in
                if success, let tripCode = tripCode {
                    trip.tripCode = tripCode
                    self.performSegue(withIdentifier: self.segueIdTripComplete, sender: trip)
                    ProfileManager.shared.loadLocalUser(completion: nil)
                    TripOrderDataStore.shared.pull(category: .carrier, delay: 1, completion: nil)
                } else {
                    print(msg ?? "Failed post trip")
                }
            }
        }else{
            print("something wrong!")
        }
    }
    
    private func setupBackGroundColor(){
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        let beginColor :UIColor = UIColor.MyTheme.nightBlue
        let endColor :UIColor = UIColor.MyTheme.nightCyan
        gradientLayer.colors = [beginColor.cgColor,endColor.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
