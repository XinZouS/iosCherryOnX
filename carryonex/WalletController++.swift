//
//  WalletController++.swift
//  carryonex
//
//  Created by Xin Zou on 9/6/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


extension WalletController {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print("TODO: open view of select at section:\(indexPath.section), row:\(indexPath.row)")
            let creditCtl = CreditController()
            creditCtl.currentCredit = Wallet.sharedInstance.creditAvailable
            navigationController?.pushViewController(creditCtl, animated: true)
            
        case 1:
            print("TODO: open view of select at section:\(indexPath.section), row:\(indexPath.row)")
            
        case 2:
            print("TODO: open view of select at section:\(indexPath.section), row:\(indexPath.row)")
            
        default:
            print("error:: selecting at undefine section:\(indexPath.section), row:\(indexPath.row)")
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    internal func cancelButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
}


