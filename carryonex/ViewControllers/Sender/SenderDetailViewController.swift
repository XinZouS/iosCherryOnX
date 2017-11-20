//
//  SenderDetailViewController.swift
//  carryonex
//
//  Created by Xin Zou on 11/20/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit


class SenderDetailViewController: UIViewController {
    
    // master info card
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var dateDayLabel: UILabel!
    @IBOutlet weak var youxiangCodeLabel: UILabel!
    @IBOutlet weak var senderProfileImageButton: UIButton!
    @IBOutlet weak var startAddressLabel: UILabel!
    @IBOutlet weak var endAddressLabel: UILabel!
    // detail info card
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var itemImagesCollectionView: UICollectionView!
    @IBOutlet weak var messageTextField: UITextField!
    // price contents
    @IBOutlet weak var currencyTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var priceMinLabel: UILabel!
    @IBOutlet weak var priceMidLabel: UILabel!
    @IBOutlet weak var priceMaxLabel: UILabel!
    @IBOutlet weak var priceSlider: UISlider!
    @IBOutlet weak var priceFinalLabel: UILabel!
    @IBOutlet weak var priceFinalHintLabel: UILabel!

    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - actions forcontents
    
    @IBAction func senderProfileImageButtonTapped(_ sender: Any) {
    }
    
    @IBAction func currencyTypeSegmentValueChanged(_ sender: Any) {
    }
    
    @IBAction func priceSliderValueChanged(_ sender: Any) {
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
    }
    
    
    
    
}
