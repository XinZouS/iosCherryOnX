//
//  TripController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/19.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit
import FSCalendar

class TripController: UIViewController{
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
        if (segue.identifier == "tripComplete") {
            if let destVC = segue.destination as? TripCompletedController{
                if let childVC = self.childViewControllers.first as? TripTableController {
                    destVC.beginLocationString = childVC.beginLocation.text
                    destVC.endLocationString = childVC.endLocation.text
                    destVC.dateString = childVC.timeTextField.text
                    destVC.descriptionString = childVC.otherTextField.text
                    destVC.startState = childVC.startState
                    destVC.endState = childVC.endState
                    if let tripId = sender {
                        destVC.tripId = tripId as! Int
                    }
                }
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
        let beginColor :UIColor = UIColor.MyTheme.darkBlue
        let endColor :UIColor = UIColor.MyTheme.cyan
        gradientLayer.colors = [beginColor.cgColor,endColor.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func commitTripInfo(_ sender: Any) {
        let trip = Trip()
        if let childVC = self.childViewControllers.first as? TripTableController {
            trip.endAddress?.state = childVC.endState
            trip.endAddress?.city = childVC.endCity
            trip.endAddress?.country = Country(rawValue:childVC.endCountry)
            trip.startAddress?.state = childVC.startState
            trip.startAddress?.city = childVC.startCity
            trip.startAddress?.country = Country(rawValue: childVC.startCountry)
            trip.pickupDate = childVC.pickUpDate
            trip.note = childVC.otherTextField.text
            ApiServers.shared.postTripInfo(trip: trip) { (success,msg, tripId) in
                if success {
                    self.performSegue(withIdentifier: "tripComplete", sender: tripId)
                    ProfileManager.shared.loadLocalUser(completion: nil)
                }else{
                    print(msg ?? "")
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
        let beginColor :UIColor = UIColor.MyTheme.darkBlue
        let endColor :UIColor = UIColor.MyTheme.cyan
        gradientLayer.colors = [beginColor.cgColor,endColor.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
