//
//  OrderListCardCell.swift
//  carryonex
//
//  Created by Zian Chen on 11/23/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

enum OrderButtonToShow {
    case noButtons
    case oneButton
    case twoButtons
}

protocol OrderListCellDelegate: class {
    func orderCellButtonTapped(request: Request, category: TripCategory, transaction: RequestTransaction, indexPath: IndexPath)
}

protocol OrderListCardCellProtocol {
    func updateButtonAppearance(status: RequestStatus)
    func updateRequestInfoAppearance(request: Request)
}

class OrderListCardCell: UITableViewCell, OrderListCardCellProtocol {

    // bottom buttons
    @IBOutlet weak var finishButton: RequestTransactionButton!
    @IBOutlet weak var finishButton2: RequestTransactionButton!
    
    weak var delegate: OrderListCellDelegate?
    var indexPath: IndexPath?
    var cellCategory: TripCategory = .carrier
    
    private var status: RequestStatus = .invalid {
        didSet {
            updateButtonAppearance(status: status)
        }
    }
    
    var request: Request? {
        didSet {
            if let request = request {
                updateRequestInfoAppearance(request: request)
            }
        }
    }
    
    var buttonsToShow: OrderButtonToShow = .noButtons {
        didSet {
            switch buttonsToShow {
            case .noButtons:
                finishButton.isHidden = true
                finishButton2.isHidden = true
            case .oneButton:
                finishButton.isHidden = false
                finishButton2.isHidden = true
            case .twoButtons:
                finishButton.isHidden = false
                finishButton2.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resetButtons()
    }
    
    func updateButtonAppearance(status: RequestStatus) {
        //Override
    }
    
    func updateRequestInfoAppearance(request: Request) {
        //Override
        if let statusId = request.status?.id, let newStatus = RequestStatus(rawValue: statusId) {
            status = newStatus
        }
    }
    
    //MARK: - Reset Buttons
    func resetButtons() {
        finishButton.reset()
        finishButton2.reset()
    }
    
    @IBAction func handleActionButton(button: RequestTransactionButton) {
        if let request = request,
            let indexPath = indexPath,
            button.transaction.isValid(for: status) {
            delegate?.orderCellButtonTapped(request: request,
                                            category: cellCategory,
                                            transaction: button.transaction,
                                            indexPath: indexPath)
        }
    }
}
