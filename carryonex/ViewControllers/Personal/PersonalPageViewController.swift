//
//  PersonalPage.swift
//  carryonex
//
//  Created by Xin Zou on 11/15/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import ZendeskSDK
import AWSCognito
import AWSCore
import AWSS3
import ALCameraViewController
import Photos

class PersonalPageViewController: UIViewController{
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userProfileNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreStar5MaskWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var scoreColorBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewAllCommentsButton: UIButton!
    
//    var loginViewController = LoginViewController() TODO: are we still need this??? - Xin
    
    @IBOutlet weak var tableView: UITableView!
    
    let scoreLabelHintText = L("personal.ui.title.score")
    let titles = [L("personal.ui.title.wallet"), L("personal.ui.title.help"), L("personal.ui.title.settings")]
    let subTitles = [L("personal.ui.title.wallet-description"), "", ""]
    let titleImgs: [UIImage] = [#imageLiteral(resourceName: "wallet_gray"), #imageLiteral(resourceName: "helping_gray"), #imageLiteral(resourceName: "setting_gray")]
    let cellId = "PersonalPageTableCell"

    let segueIdWalletPage = "creditViewController"
    let segueIdSettingPage = "pushSettingPageSegue"
    let segueIdEditProfile = "editProfile"
    let personalInfoVCId = "PersonalInfoEditingViewController"

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = L("personal.ui.title.me")
        setupTableView()
        setupNavigationBar()
        addObservers()
        loadUserProfile()
        loadUserComments()
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView() // remove empty rows;
        tableView.isScrollEnabled = true
        tableView.separatorColor = colorTableCellSeparatorLightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUserImageView()
        setupNavigationBar()
    }

    private func setupNavigationBar(){
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.shadowImage = colorTableCellSeparatorLightGray.as1ptImage()
    }
    
    private func addObservers(){
        NotificationCenter.default.addObserver(forName: .UserDidUpdate, object: nil, queue: nil) { [weak self] _ in
            self?.loadUserProfile()
        }
    }
    
    private func loadUserProfile(){
        guard let currUser = ProfileManager.shared.getCurrentUser() else { return }
        if let imageUrlString = currUser.imageUrl, let imgUrl = URL(string: imageUrlString) {
            URLCache.shared.removeAllCachedResponses()
            userProfileImage.af_setImage(withURL: imgUrl)
        } else {
            userProfileImage.image = #imageLiteral(resourceName: "blankUserHeadImage")
        }
        if let currUserName  = currUser.realName,currUserName != ""{
            userProfileNameLabel.text = currUserName
        }
        if let profileInfo = ProfileManager.shared.homeProfileInfo {
            let fullLen = scoreStar5MaskWidthConstraint.constant
            scoreLabel.text = scoreLabelHintText + String(format: "%.1f", profileInfo.rating)
            scoreColorBarWidthConstraint.constant = max(0.0, fullLen * CGFloat(profileInfo.rating / 5.0))
        }
    }
    
    private func loadUserComments() {
        guard let currUser = ProfileManager.shared.getCurrentUser(), let currId = currUser.id else { return }
        ApiServers.shared.getUserComments(commenteeId: currId, offset: 0) { (userComments, error) in
            if let err = error {
                DLog("error: PersonalPageViewController::loadUserComments() get error: \(err.localizedDescription)")
                return
            }
            let num = userComments?.commentsLength ?? 0
            let tit = L("orders.ui.title.view-comments-p1") + "\(num)" + L("orders.ui.title.view-comments-p2")
            self.viewAllCommentsButton.setTitle(tit, for: .normal)
        }
    }

    
    private func setupUserImageView(){
        userProfileImage.layer.masksToBounds = true
        userProfileImage.layer.cornerRadius = CGFloat(Int(userProfileImage.bounds.height)/2)
    }
    
    @IBAction func seeAllCommentsButtonTapped(_ sender: Any) {
        AppDelegate.shared().handleMainNavigation(navigationSegue: .historyComment, sender: nil)
        AnalyticsManager.shared.trackCount(.historicCommentCheckCount)
    }
    
}

extension PersonalPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            AppDelegate.shared().handleMainNavigation(navigationSegue: .creditView, sender: nil)
            AnalyticsManager.shared.trackCount(.walletOpenCount)
            
        case 1:
            AppDelegate.shared().handleMainNavigation(navigationSegue: .helpCenter, sender: nil)

        case 2:
            AppDelegate.shared().handleMainNavigation(navigationSegue: .settings, sender: nil)
            
        default:
            DLog("Error: illegal selection row in PersonalPageVC: didselectRowAt: default;")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 60
        default:
            return 50
        }
    }
    
}

extension PersonalPageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? PersonalPageTableCell {
            cell.titleLabel.text = titles[indexPath.row]
            cell.subTitleLabel.text = subTitles[indexPath.row]
            cell.imageIconView.image = titleImgs[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
}
