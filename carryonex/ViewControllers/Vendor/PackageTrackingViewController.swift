//
//  PackageTrackingViewController.swift
//  carryonex
//
//  Created by Zian Chen on 1/16/18.
//  Copyright © 2018 CarryonEx. All rights reserved.
//

import UIKit

class PackageTrackingViewController: UIViewController {

    @IBOutlet weak var trackingIdTextField: UITextField!
    @IBOutlet weak var carrierCodeTextField: UITextField!
    @IBOutlet weak var trackingTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var items: [KuaidiProcessItem]? {
        didSet {
            trackingTableView.reloadData()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                loadingIndicator.startAnimating()
            } else {
                loadingIndicator.stopAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackingTableView.delegate = self
        trackingTableView.dataSource = self
        
        let companyCode = "huitongkuaidi"
        let tracking = "70118428554311"
        
        trackingIdTextField.text = tracking
        carrierCodeTextField.text = companyCode
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Tracking Helper
    
    @IBAction func handleTrackingButton(sender: UIButton) {
        
        guard let trackingNumber = trackingIdTextField.text, let carrierCode = carrierCodeTextField.text else {
            displayAlert(title: "快递资料错误", message: "请输入正确的快递资料", action: L("action.ok"))
            return
        }
        
        trackingIdTextField.resignFirstResponder()
        carrierCodeTextField.resignFirstResponder()
        
        isLoading = true
        
        ApiServers.shared.checkDelivery(tracking: trackingNumber, companyCode: carrierCode) { (object, error) in
            
            self.isLoading = false
            
            if let error = error {
                DLog("Tracking Error: \(error.localizedDescription)")
                
                let serverError = error as NSError
                let errorMessage = serverError.userInfo["message"] ?? serverError.localizedDescription
                let errorCode = serverError.code
                self.displayAlert(title: "搜寻单号错误", message: "错误代码: \(errorCode)。错误讯息: \(errorMessage)", action: L("action.ok"))
                self.items?.removeAll()
                return
            }
            
            if let object = object {
                self.items = object.data
            }
        }
    }
}

extension PackageTrackingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = items {
            return items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PackageItemCell", for: indexPath) as? PackageItemCell {
            if let processItem = self.items?[indexPath.row] {
                cell.contextLabel.text = processItem.context
                cell.timeLabel.text = processItem.ftime
            }
            return cell
        }
        return UITableViewCell()
    }
}

class PackageItemCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contextLabel: UILabel!
}