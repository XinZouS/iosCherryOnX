//
//  RequestTransactionButton.swift
//  carryonex
//
//  Created by Zian Chen on 11/22/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class RequestTransactionButton: UIButton {
    var transaction: RequestTransaction = .invalid {
        didSet {
            setTitle(transaction.displayString(), for: .normal)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func reset() {
        setTitle("", for: .normal)
        transaction = .invalid
    }
}
