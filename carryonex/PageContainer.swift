//
//  HomePageContainer.swift
//  carryonex
//
//  Created by Xin Zou on 8/9/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


enum SlideOutState {
    case BothCollapsed
    case LeftPanelExpanded
    case RightPanelExpanded
}

protocol PageContainerDelegate : class {
    func toggleLeftPanel()
}

let centerPanelExpandedOffset: CGFloat = UIScreen.main.bounds.width / 4.6



class PageContainer: UIViewController, PageContainerDelegate {
    
    // MARK: slide-out menu
    
    var centerNavigationController: UINavigationController!
    var centerViewController: HomePageController!
    
    var leftViewController: SideMenuLeftController?
    var currentState: SlideOutState = .BothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .BothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // plan A: for slide-out menu:
//        centerViewController = HomePageController()
//        centerViewController.pageContainer = self
//        
//        view.backgroundColor = .white
//        
//        centerNavigationController = UINavigationController(rootViewController: centerViewController)
//        view.addSubview(centerNavigationController.view)
//        addChildViewController(centerNavigationController)
//        
//        centerNavigationController.didMove(toParentViewController: self)
    }
    


    // MARK: CenterViewController delegate

    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        
        print("func toggleLeftPanel()  -- inside toggleLeftPanel(){}")
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    private func addLeftPanelViewController() {
        if (self.leftViewController == nil) {
            //leftViewController = UIStoryboard.leftViewController()
            //leftViewController!.animals = Animal.allCats()
            self.leftViewController = SideMenuLeftController()
            self.leftViewController?.containerDelegate = self
        }
        print("  ---  generate leftViewController = SideMenuLeftController()")
        addChildSidePanelController()
    }
    
//    func addChildSidePanelController(_ sidePanelController: SideMenuLeftController) {
//        view.insertSubview(sidePanelController.view, at: 0)
//        
//        addChildViewController(sidePanelController)
//        sidePanelController.didMove(toParentViewController: self)
//    }
    private func addChildSidePanelController() {
        guard let leftViewController = leftViewController else { return }
        view.insertSubview(leftViewController.view, at: 0)
        
        addChildViewController(leftViewController)
        leftViewController.didMove(toParentViewController: self)
    }
    
    private func addRightPanelViewController() {
    }
    
    private func animateLeftPanel(shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .LeftPanelExpanded
            
            animateCenterPanelXPosition(targetPosition: centerNavigationController.view.frame.width - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .BothCollapsed
                
                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController = nil;
            }
        }
    }
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        centerNavigationController.view.layer.shadowOpacity = shouldShowShadow ? 0.8 : 0.0
    }
    
    func animateRightPanel(shouldExpand: Bool) {
    }
    
}
