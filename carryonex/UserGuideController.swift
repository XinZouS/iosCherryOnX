//
//  UserGuideController.swift
//  carryonex
//
//  Created by Xin Zou on 10/16/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import ZendeskSDK

class UserGuideController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var tableView : UITableView = {
        let t = UITableView()
        t.delegate = self
        t.dataSource = self
        return t
    }()
    
    let userGuideCellId = "userGuideCellId"
    
    let tabTitleMenuBarHeight : CGFloat = 40
    
    var topDataSource: [ConfigURLItem]?
    var bottomDataSource: [ConfigURLItem]?
    let segmentControl : UISegmentedControl = {
        let segment = UISegmentedControl(items: ["我是发件人", "我是揽件人"])
        segment.selectedSegmentIndex = 0
        segment.tintColor = buttonThemeColor
        return segment
    }()
    
    lazy var onlineCustomerServersButton : UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(onlineCustomerServersButtonTapped), for: .touchUpInside)
        b.backgroundColor = buttonThemeColor
        let atts = [NSFontAttributeName: UIFont.systemFont(ofSize: 20),
                    NSForegroundColorAttributeName: UIColor.white]
        let attStr = NSAttributedString(string: "在线客服", attributes: atts)
        b.setAttributedTitle(attStr, for: .normal)
        return b
    }()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        //TODO: for test only, should move under guard let;
        setupBottomButton()

        //If config not found, do nothing
        guard let config = ApiServers.shared.config else { return }
        
        //Setup the datasource
        topDataSource = config.problems
        bottomDataSource = config.sender
        
        setupSegmentControl()
        setupTableView()
    }
    
    private func setupSegmentControl(){
        segmentControl.addTarget(self, action: #selector(handleSegmentValueChanged), for: .valueChanged)
        view.addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.addConstraints(left: view.leftAnchor, top: topLayoutGuide.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: tabTitleMenuBarHeight)
    }
    
    func handleSegmentValueChanged() {
        guard let config = ApiServers.shared.config else { return }
        if segmentControl.selectedSegmentIndex == TripCategory.Sender.rawValue {
            bottomDataSource = config.sender
        } else if segmentControl.selectedSegmentIndex == TripCategory.Carrier.rawValue {
            bottomDataSource = config.carrier
        }
        tableView.setContentOffset(CGPoint.zero, animated: false)   //Bring table view back to the top
        tableView.reloadData()
    }
    
    private func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: userGuideCellId)
        tableView.backgroundColor = pickerColorLightGray
        
        view.addSubview(tableView)
        tableView.addConstraints(left: view.leftAnchor,
                                 top: segmentControl.bottomAnchor,
                                 right: view.rightAnchor,
                                 bottom: view.bottomAnchor,
                                 leftConstent: 0,
                                 topConstent: 0,
                                 rightConstent: 0,
                                 bottomConstent: 0,
                                 width: 0,
                                 height: 0)
    }

    private func setupBottomButton(){
        view.addSubview(onlineCustomerServersButton)
        onlineCustomerServersButton.addConstraints(left: view.leftAnchor,
                                                   top: nil,
                                                   right: view.rightAnchor,
                                                   bottom: view.bottomAnchor,
                                                   leftConstent: 0,
                                                   topConstent: 0,
                                                   rightConstent: 0,
                                                   bottomConstent: 44,
                                                   width: 0,
                                                   height: 44)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userGuideCellId, for: indexPath)
        var item: ConfigURLItem?
        if indexPath.section == 0 {
            item = topDataSource?[indexPath.row]
        } else if indexPath.section == 1 {
            item = bottomDataSource?[indexPath.row]
        }
        guard let urlItem = item else { return UITableViewCell() }
        
        cell.textLabel?.text = urlItem.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSource = (indexPath.section == 0) ? topDataSource : bottomDataSource else { return }
        let urlItem = dataSource[indexPath.row]
        let webCtl = WebController()
        webCtl.url = URL(string: urlItem.url)
        webCtl.title = urlItem.title
        navigationController?.pushViewController(webCtl, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return topDataSource?.count ?? 0
        } else {
            return bottomDataSource?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "📝 常见问题"
        } else if section == 1 {
            return "✅ 操作说明"
        }
        return "❓"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
}



extension UserGuideController {
    
    func onlineCustomerServersButtonTapped(){
        let helpCenterContentModel = ZDKHelpCenterOverviewContentModel.defaultContent()
        ZDKHelpCenter.pushOverview(self.navigationController, with:helpCenterContentModel)
    }
    

}

