//
//  ThemPageControlView.swift
//  carryonex
//
//  Created by Xin Zou on 1/3/18.
//  Copyright © 2018 CarryonEx. All rights reserved.
//

import UIKit


class ThemPageControlView: UIView {
    
    public var numOfPages: Int = 1 {
        didSet{
            setupDots()
        }
    }
    public var selectedIndex: Int = 0 {
        didSet{
            updateDotAppearance()
        }
    }
    
    private let stackView = UIStackView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        setupDots()
    }
    
    init(frame: CGRect, pages: Int) {
        super.init(frame: frame)
        setupStackView()
        self.numOfPages = pages
        setupDots()
    }
    
    private func setupStackView() {
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        addSubview(stackView)
        stackView.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
    }

    private func setupDots() {
        for _ in 1...numOfPages {
            let dot = ThemPageControlDot(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            stackView.addArrangedSubview(dot)
        }
        updateDotAppearance()
    }
    
    private func updateDotAppearance() {
        for i in 0..<stackView.arrangedSubviews.count {
            if let dot = stackView.arrangedSubviews[i] as? ThemPageControlDot {
                DLog("get dot at: \(i), isSelect = \(i == selectedIndex)")
                dot.isSelected = (i == selectedIndex)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class ThemPageControlDot: UIView {
    
    public var isSelected: Bool = false {
        didSet{
            updateAppearance()
        }
    }
    
    private let dotLayer = CAShapeLayer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayers()
    }
    
    private func setupLayers() {
        let x: CGFloat = -5
        let y: CGFloat = 0
        let r: CGFloat = 10
        
        let dotPath = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: r, height: r))
        dotLayer.path = dotPath.cgPath
        dotLayer.fillColor = UIColor.white.cgColor
        dotLayer.lineWidth = 2.0
        dotLayer.strokeColor = colorTextFieldUnderLineLightGray.cgColor
        
        self.layer.addSublayer(dotLayer)
    }

    private func updateAppearance() {
        dotLayer.fillColor = isSelected ? colorTextFieldUnderLineLightGray.cgColor : UIColor.white.cgColor
        dotLayer.strokeColor = isSelected ? colorTextBlack.cgColor : colorTextFieldUnderLineLightGray.cgColor
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
