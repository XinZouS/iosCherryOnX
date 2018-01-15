//
//  RequestTripViewController.swift
//  carryonex
//
//  Created by Xin Zou on 1/9/18.
//  Copyright © 2018 CarryonEx. All rights reserved.
//

import UIKit

class RequestTripViewController: UIViewController {
    
    // info contents
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var youxiangTitleLabel: UILabel!
    @IBOutlet weak var youxiangCodeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var startAddressLabel: UILabel!
    @IBOutlet weak var endAddressLabel: UILabel!
    // buttons
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var trip: Trip?
    let segueSenderDetailInfo = "senderDetailInfo"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViewLabels()
        setupTripInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavigationBar()
        okButton.isEnabled = true
    }
    
    private func setupNavigationBar(){
        title = L("sender.ui.title.new-request")
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setupViewLabels() {
        youxiangTitleLabel.text = L("sender.ui.title.youxiangcode")
        okButton.setTitle(L("sender.ui.title.enter-youxiang"), for: .normal)
        cancelButton.setTitle(L("action.cancel"), for: .normal)
    }

    private func setupTripInfo(){
        guard let t = trip else { return }
        monthLabel.text = t.getMonthString()
        dayLabel.text = t.getDayString()
        youxiangCodeLabel.text = t.tripCode
        if let imageUrl = t.carrierImageUrl, let url = URL(string: imageUrl) {
            imageView.af_setImage(withURL: url)
        }else{
            imageView.image = #imageLiteral(resourceName: "blankUserHeadImage")
        }
        startAddressLabel.text = t.startAddress?.fullAddressString()
        endAddressLabel.text = t.endAddress?.fullAddressString()
    }

    
    @IBAction func okButtonTapped(_ sender: Any) {
        guard let t = trip else { return }
        okButton.isEnabled = false
        performSegue(withIdentifier: segueSenderDetailInfo, sender: t)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == segueSenderDetailInfo {
            return sender != nil
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let infoVC = segue.destination as? SenderDetailViewController,
            let tp = sender as? Trip {
            title = " "
            infoVC.trip = tp
        }
    }
    

}
