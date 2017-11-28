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
    @IBOutlet weak var userProfileImage: UIButton!
    @IBOutlet weak var userProfileNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreColorBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewAllCommentsButton: UIButton!
    var personInfoEditCtl: PersonalInfoEditingViewController!
    var loginViewController = LoginViewController()
    @IBOutlet weak var tableView: UITableView!
    
    let titles = ["钱包","帮助","设置"]
    let subTitles = ["收付款，查看余额，提现", "", ""]
    let titleImgs: [UIImage] = [#imageLiteral(resourceName: "wallet_gray"), #imageLiteral(resourceName: "helping_gray"), #imageLiteral(resourceName: "setting_gray")]
    let cellId = "PersonalPageTableCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的"
        setupTableView()
        setupNavigationBar()
        addUserUpdateNotificationObservers()
        loadUserProfile()
    }
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView() // remove empty rows;
        tableView.isScrollEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUserImageView()
        setupNavigationBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfile"{
            if let destVC = segue.destination as? PersonalInfoEditingViewController {
                personInfoEditCtl = destVC
            }
        }
    }
    
    private func setupNavigationBar(){
        UIApplication.shared.statusBarStyle = .default
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.isNavigationBarHidden = false
    }
    
    private func addUserUpdateNotificationObservers(){
        NotificationCenter.default.addObserver(forName: .UserDidUpdate, object: nil, queue: nil) { [weak self] _ in
            self?.loadUserProfile()
        }
    }
    private func loadUserProfile(){
        guard let currUser = ProfileManager.shared.getCurrentUser() else { return }
        if let imageUrlString = currUser.imageUrl, let imgUrl = URL(string: imageUrlString) {
            URLCache.shared.removeAllCachedResponses()
            userProfileImage.af_setImage(for: .normal, url: imgUrl, placeholderImage: #imageLiteral(resourceName: "carryonex_UserInfo"), filter: nil, progress: nil, completion: nil)
        } else {
            userProfileImage.setImage(#imageLiteral(resourceName: "carryonex_UserInfo"), for: .normal)
        }
        if let currUserName  = currUser.realName,currUserName != ""{
            userProfileNameLabel.text = currUserName
        }
    }
    
    private func setupUserImageView(){
        userProfileImage.layer.masksToBounds = true
        userProfileImage.layer.cornerRadius = CGFloat(Int(userProfileImage.height)/2)
    }
    
    @IBAction func userProfileImageTapped(_ sender: Any) {
        
    }
    
    @IBAction func editProfileButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "editProfile", sender: self)
    }
    @IBAction func seeAllCommentsButtonTapped(_ sender: Any) {
        // TODO: navigate to see comments page;
    }
    
    
    
}

extension PersonalPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("TODO: show wallet page")
            
        case 1:
            let helpCenterContentModel = ZDKHelpCenterOverviewContentModel.defaultContent()
            ZDKHelpCenter.pushOverview(self.navigationController, with:helpCenterContentModel)

        case 2:
            performSegue(withIdentifier: "pushSettingPageSegue", sender: self)
            
        default:
            print("Error: illegal selection row in PersonalPageVC: didselectRowAt: default;")
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
