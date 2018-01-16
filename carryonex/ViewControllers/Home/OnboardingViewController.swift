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
    
    fileprivate let pageControlView = ThemPageControlView(frame: CGRect(x: 0, y: 0, width: 60, height: 10), pages: 3)
    fileprivate var lastPendingViewControllerIndex: Int = 0
    fileprivate var currentPageIndex: Int = 0
    let skipButton = UIButton()
    let nextButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white // UIColor.MyTheme.eveningA
        dataSource = self
        delegate = self
        setupPages()
        if let firstVC = pages.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        setupPageControl() // the order of these setup should NOT be change!
        setupBottomButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNextButtonAppearance()
    }
    
    private func setupPages(){
        for i in 0..<pages.count {
            setupPageImageView(i)
        }
    }

    private func setupBottomButtons() {
        let bkgndImgView = UIImageView()
        bkgndImgView.contentMode = .scaleToFill
        bkgndImgView.image = #imageLiteral(resourceName: "onboarding_bottom_white")
        view.addSubview(bkgndImgView)
        bkgndImgView.addConstraints(left: view.leftAnchor, top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 60, width: 0, height: 60)
        
        let w: CGFloat = 120
        let h: CGFloat = 50
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        skipButton.setTitle(L("home.ui.button.skip"), for: .normal)
        skipButton.setTitleColor(colorTextBlack, for: .normal)
        view.addSubview(skipButton)
        skipButton.addConstraints(left: view.leftAnchor, top: nil, right: nil, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: h)
        skipButton.centerYAnchor.constraint(equalTo: pageControlView.bottomAnchor).isActive = true
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.setImage(#imageLiteral(resourceName: "onboarding_next"), for: .normal)
        nextButton.setTitleColor(colorTextBlack, for: .normal)
        nextButton.isUserInteractionEnabled = false
        view.addSubview(nextButton)
        nextButton.addConstraints(left: nil, top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: h)
        nextButton.centerYAnchor.constraint(equalTo: pageControlView.bottomAnchor).isActive = true
    }
    
    fileprivate func setupPageControl() {        
        view.addSubview(pageControlView)
        pageControlView.translatesAutoresizingMaskIntoConstraints = false
        pageControlView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControlView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        pageControlView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        pageControlView.heightAnchor.constraint(equalToConstant: 15).isActive = true
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
        self.dismiss(animated: true, completion: nil)
    }
    
    public func updateNextButtonAppearance() {
        let isLast = currentPageIndex == pages.count - 1
        nextButton.setImage(isLast ? UIImage() : #imageLiteral(resourceName: "onboarding_next"), for: .normal)
        nextButton.setTitle(isLast ? L("action.done") : " ", for: .normal)
        nextButton.isUserInteractionEnabled = isLast
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


extension OnboardingViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]){
        let vc = pendingViewControllers[0]
        switch vc {
        case pages[0]:
            lastPendingViewControllerIndex = 0
        case pages[1]:
            lastPendingViewControllerIndex = 1
        case pages[2]:
            lastPendingViewControllerIndex = 2
        default:
            lastPendingViewControllerIndex = 0
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.currentPageIndex = self.lastPendingViewControllerIndex
            self.pageControlView.selectedIndex = self.currentPageIndex
            updateNextButtonAppearance()
        }
    }
    
    
}
