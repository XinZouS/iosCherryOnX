//
//  UIColor+App.swift
//  carryonex
//
//  Created by Chen, Zian on 11/29/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

extension UIColor {
    
    open class var carryon_aciveStatus: UIColor { return carryon_red }
    open class var carryon_passiveStatus: UIColor { return carryon_yellow }
    open class var carryon_normalStatus: UIColor { return carryon_teal }
    open class var carryon_endedStatus: UIColor { return carryon_lightGray }
    
    open class var carryon_textActiveStatus: UIColor { return .white }
    open class var carryon_textPassiveStatus: UIColor { return carryon_darkGray }
    open class var carryon_textNormalStatus: UIColor { return carryon_darkGray }
    open class var carryon_textEndedStatus: UIColor { return carryon_darkGray }
    
    open class var carryon_buttonEnabled: UIColor { return carryon_red }
    open class var carryon_buttonDisabled: UIColor { return carryon_lightGray }
    open class var carryon_buttonLogin: UIColor { return carryon_darkTeal }
    open class var carryon_normalText: UIColor { return carryon_darkGray }
    
    open class var carryon_loadingBackground: UIColor { return UIColor(r: 0, g: 0, b: 0, a: 0.3) }
    
    open class var carryon_pending: UIColor { return carryon_textBlack }
    open class var carryon_payout: UIColor { return carryon_red }
    open class var carryon_wallet_text: UIColor { return carryon_textBlack }
    
    //MARK: - Internal Color Scheme
    //status
    private class var carryon_teal: UIColor { return UIColor.rgb(128, 250, 235) }
    private class var carryon_yellow: UIColor { return UIColor.rgb(249, 226, 120) }
    private class var carryon_red: UIColor { return UIColor.rgb(255, 107, 107) }
    private class var carryon_lightGray: UIColor { return UIColor.rgb(229, 235, 239) }
    
    //UI Components
    private class var carryon_darkTeal: UIColor { return UIColor.rgb(51, 166, 184) }
    private class var carryon_darkGray: UIColor { return UIColor.rgb(78, 88, 96) }
    private class var carryon_textBlack: UIColor { return UIColor.rgb(37, 44, 49) }
}
