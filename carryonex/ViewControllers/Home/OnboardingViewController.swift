//
//  OnboardingViewController.swift
//  carryonex
//
//  Created by Xin Zou on 1/2/18.
//  Copyright © 2018 CarryonEx. All rights reserved.
//

import UIKit


class OnboardingViewController: UIPageViewController {
    
    lazy var pages: [UIViewController] = {
        let v1 = UIViewController()
        let v2 = UIViewController()
        let v3 = UIViewController()
        return [v1, v2, v3]
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.MyTheme.nightA
        dataSource = self
        setupPages()
        if let firstVC = pages.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        setupBottomButtons()
        setupPageControl()
    }
    
    private func setupPages(){
        for i in 0..<pages.count {
            setupPageImageView(i)
        }
    }

    private func setupBottomButtons() {
        let btmImgView = UIImageView()
        btmImgView.contentMode = .scaleToFill
        btmImgView.image = #imageLiteral(resourceName: "onboarding_bottom_white")
        view.addSubview(btmImgView)
        btmImgView.addConstraints(left: view.leftAnchor, top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 60, width: 0, height: 60)
        
        let buttonWidth: CGFloat = 100
        let skipButton = UIButton()
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        skipButton.setTitle("Skip!!!", for: .normal)
        view.addSubview(skipButton)
        skipButton.addConstraints(left: view.leftAnchor, top: btmImgView.bottomAnchor, right: nil, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: buttonWidth, height: 0)
        
        let nextButton = UIButton()
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.setTitle(">", for: .normal)
        view.addSubview(nextButton)
        nextButton.addConstraints(left: nil, top: btmImgView.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: buttonWidth, height: 0)
    }
    
    fileprivate func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = .yellow
        appearance.currentPageIndicatorTintColor = .green
    }

    private func setupPageImageView(_ i: Int) {
        let bottomMargin: CGFloat = 30
        let image = UIImage(named: "onboarding0\(i + 1)")
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = image
        
        let vc = pages[i]
        vc.view.addSubview(imageView)
        imageView.addConstraints(left: vc.view.leftAnchor, top: vc.view.topAnchor, right: vc.view.rightAnchor, bottom: vc.view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: bottomMargin, width: 0, height: 0)
    }
    
    public func skipButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func nextButtonTapped() {
        ////
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        setupPageControl()
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let idx = pages.index(of: viewController) else { return nil }
        
        let previousIdx = idx - 1
        guard previousIdx >= 0, pages.count > previousIdx else { return nil }
        return pages[previousIdx]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let idx = pages.index(of: viewController) else { return nil }
        
        let nextIdx = idx + 1
        guard pages.count > nextIdx else { return nil }
        
        return pages[nextIdx]
    }
    
    
}
