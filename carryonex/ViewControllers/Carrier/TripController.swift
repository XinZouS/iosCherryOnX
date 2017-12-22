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
        AnalyticsManager.shared.startTimeTrackingKey(.carrierDetailFillTime)
        setupNavigationBar()
        setupcomfirmTripButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        title = L("carrier.ui.title.trip")
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
                self.displayAlert(title: L("carrier.error.title.date"), message: L("carrier.error.message.date"), action: L("action.ok"))
                return
            }
            AnalyticsManager.shared.finishTimeTrackingKey(.carrierDetailFillTime)
            
            let days = Date(timeIntervalSince1970: childVC.pickUpDate).days(from: Date())
            AnalyticsManager.shared.track(.carrierPrePublishDay, attributes: ["days": days])
            
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
