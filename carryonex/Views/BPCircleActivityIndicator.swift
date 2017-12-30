//
//  BPCircleActivityIndicator.swift
//  carryonex
//
//  Created by Xin Zou on 12/22/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

@IBDesignable
public class BPCircleActivityIndicator: UIView {
    
    private var circleLotateLayer = CircleLotateLayer()
    private var rotateSpeed: Double = 0.6
    private var interval: Double = 0.0
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    public func rotateSpeed(_ speed: Double) -> Self {
        self.rotateSpeed = speed
        return self
    }
    
    public func interval(_ interval: Double) -> Self {
        self.interval = interval
        return self
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupLayer() {
        let screen = UIScreen.main.bounds //
        let x = -(screen.width / 2.0 + 40)
        let y = -(screen.height / 2.0 + 40)
        
        // big black frame
        let maskFrame = CGRect(x: x, y: y, width: screen.width + 100, height: screen.height + 100)
        let blackMask = UIView(frame: maskFrame)
        blackMask.backgroundColor = UIColor(white: 0, alpha: 0.3)
        self.addSubview(blackMask)
        
        // small white frame
        let bkgd = UIView(frame: CGRect(x: -27, y: -25, width: 80, height: 80))
        bkgd.backgroundColor = UIColor(red: 255, green: 246, blue: 30, alpha: 0.6)
        bkgd.layer.cornerRadius = 10
        bkgd.clipsToBounds = true
        self.addSubview(bkgd)
        
        let frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        circleLotateLayer = CircleLotateLayer(frame: frame)
        layer.addSublayer(circleLotateLayer)
    }
    
    public func animate() {
        circleLotateLayer.animate(duration: rotateSpeed, interval: interval)
    }
    
    public func stop() {
        circleLotateLayer.removeAllAnimations()
    }
}


internal class CircleLayer: CAShapeLayer {
    
    override init() {
        super.init()
    }
    
    init(frame: CGRect, color: CGColor) {
        super.init()
        self.frame = frame
        self.path = UIBezierPath(
            roundedRect: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height),
            cornerRadius: bounds.width / 2
            ).cgPath
        self.fillColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


// MARK: - CircleLotateLayer

internal class CircleLotateLayer: CALayer, CommonAnimation {
    
    var circle1 = CircleLayer()
    var circle2 = CircleLayer()
    var circle3 = CircleLayer()
    var circle4 = CircleLayer()
    
    override init() {
        super.init()
    }
    
    init(frame: CGRect) {
        super.init()
        self.frame = frame
        setupLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }
    
    private func setupLayer() {
        circle1 = CircleLayer(frame: CLSet.leftUp.frame, color: CLSet.leftUp.color)
        circle2 = CircleLayer(frame: CLSet.rightUp.frame, color: CLSet.rightUp.color)
        circle3 = CircleLayer(frame: CLSet.rightDown.frame, color: CLSet.rightDown.color)
        circle4 = CircleLayer(frame: CLSet.leftDown.frame, color: CLSet.leftDown.color)
        
        [circle1, circle2, circle3, circle4].forEach { addSublayer($0) }
    }
    
    func animate(duration: Double = 0.6, interval: Double = 0) {
        CATransaction.begin()
        circle1.add(intervalAnimation(interval, anim: fillColorAnimation(to: CLSet.leftUp.nextColor, duration: duration)), forKey: nil)
        circle2.add(intervalAnimation(interval, anim: fillColorAnimation(to: CLSet.rightUp.nextColor, duration: duration)), forKey: nil)
        circle3.add(intervalAnimation(interval, anim: fillColorAnimation(to: CLSet.rightDown.nextColor, duration: duration)), forKey: nil)
        circle4.add(intervalAnimation(interval, anim: fillColorAnimation(to: CLSet.leftDown.nextColor, duration: duration)), forKey: nil)
        
        circle1.add(intervalAnimation(interval, anim: positionAnimation(to: CLSet.leftUp.nextPosition, duration: duration)), forKey: nil)
        circle2.add(intervalAnimation(interval, anim: positionAnimation(to: CLSet.rightUp.nextPosition, duration: duration)), forKey: nil)
        circle3.add(intervalAnimation(interval, anim: positionAnimation(to: CLSet.rightDown.nextPosition, duration: duration)), forKey: nil)
        circle4.add(intervalAnimation(interval, anim: positionAnimation(to: CLSet.leftDown.nextPosition, duration: duration)), forKey: nil)
        CATransaction.commit()
    }
    
    private func intervalAnimation(_ interval: Double, anim: CABasicAnimation) -> CAAnimationGroup {
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = anim.duration + interval
        groupAnimation.repeatCount = Float.infinity
        groupAnimation.animations = [anim]
        return groupAnimation
    }
    
    override func removeAllAnimations() {
        super.removeAllAnimations()
        circle1.removeAllAnimations()
        circle2.removeAllAnimations()
        circle3.removeAllAnimations()
        circle4.removeAllAnimations()
    }
}


// MARK: - CircleLotationSet

internal typealias CLSet = CircleLotationSet

internal enum CircleLotationSet {
    
    case leftUp
    case rightUp
    case rightDown
    case leftDown
    
    var color: CGColor {
        switch self {
        case .leftUp: return #colorLiteral(red: 0.2431372549, green: 0.3098039216, blue: 0.7058823529, alpha: 0.7955907534).cgColor
        case .rightUp: return #colorLiteral(red: 0.2431372549, green: 0.3098039216, blue: 0.7058823529, alpha: 0.6039169521).cgColor
        case .rightDown: return #colorLiteral(red: 0.2431372549, green: 0.3098039216, blue: 0.7058823529, alpha: 0.395119863).cgColor
        case .leftDown: return #colorLiteral(red: 0.2431372549, green: 0.3098039216, blue: 0.7058823529, alpha: 0.2003424658).cgColor
        }
    }
    
    var frame: CGRect {
        switch self {
        case .leftUp: return CGRect(x: 0, y: 0, width: 10, height: 10)
        case .rightUp: return CGRect(x: 20, y: 0, width: 10, height: 10)
        case .rightDown: return CGRect(x: 20, y: 20, width: 10, height: 10)
        case .leftDown: return CGRect(x: 0, y: 20, width: 10, height: 10)
        }
    }
    
    var nextColor: CGColor {
        switch self {
        case .leftUp: return CircleLotationSet.rightUp.color
        case .rightUp: return CircleLotationSet.rightDown.color
        case .rightDown: return CircleLotationSet.leftDown.color
        case .leftDown: return CircleLotationSet.leftUp.color
        }
    }
    
    var nextPosition: CGPoint {
        switch self {
        case .leftUp: return CGPoint(x: 25, y: 5)
        case .rightUp: return CGPoint(x: 25, y: 25)
        case .rightDown: return CGPoint(x: 5, y: 25)
        case .leftDown: return CGPoint(x: 5, y: 5)
        }
    }
}

// MARK: - CommonAnimation
enum KeyframeAnimationType: String {
    
    case color = "backgroundColor"
    case position = "position"
    case rotate = "transform.rotation"
    case scale = "transform.scale"
    case opacity = "opacity"
    case fillColor = "fillColor"
}

enum EasingType: String {
    
    case linear
    case easeIn
    case easeOut
    case easeInOut
    case defaultEasing
    
    var rawValue: String {
        switch self {
        case .linear: return kCAMediaTimingFunctionLinear
        case .easeIn: return kCAMediaTimingFunctionEaseIn
        case .easeOut: return kCAMediaTimingFunctionEaseOut
        case .easeInOut: return kCAMediaTimingFunctionEaseInEaseOut
        case .defaultEasing: return kCAMediaTimingFunctionDefault
        }
    }
}

internal protocol CommonAnimation { }

internal extension CommonAnimation {
    
    func colorAnimation(to: CGColor, easing: EasingType = .linear, duration: Double) -> CABasicAnimation {
        return animation(to: to, keyPath: .color, easing: easing, duration: duration)
    }
    
    func positionAnimation(to: CGPoint, easing: EasingType = .linear, duration: Double) -> CABasicAnimation {
        return animation(to: to, keyPath: .position, easing: easing, duration: duration)
    }
    
    func rotateAnimation(to: CGFloat, easing: EasingType = .linear, duration: Double) -> CABasicAnimation {
        return animation(to: to, keyPath: .rotate, easing: easing, duration: duration)
    }
    
    func scaleAnimation(to: CGFloat, easing: EasingType = .linear, duration: Double) -> CABasicAnimation {
        return animation(to: to, keyPath: .scale, easing: easing, duration: duration)
    }
    
    func opacityAnimation(to: CGFloat, easing: EasingType = .linear, duration: Double) -> CABasicAnimation {
        return animation(to: to, keyPath: .opacity, easing: easing, duration: duration)
    }
    
    func fillColorAnimation(to: CGColor, easing: EasingType = .linear, duration: Double) -> CABasicAnimation {
        return animation(to: to, keyPath: .fillColor, easing: easing, duration: duration)
    }
    
    private func animation(to: Any, keyPath: KeyframeAnimationType, easing: EasingType, duration: Double) -> CABasicAnimation {
        let animation = CABasicAnimation()
        animation.keyPath = keyPath.rawValue
        animation.toValue = to
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: easing.rawValue)
        return animation
    }
}
