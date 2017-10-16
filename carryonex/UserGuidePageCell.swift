//
//  UserGuidePageCell.swift
//  carryonex
//
//  Created by Xin Zou on 10/16/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

class UserGuidePageCell : UICollectionViewCell {
    
    var titles : [[String]]! {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let userGuidePageTableCellId = "userGuidePageTableCellId"
    
    lazy var tableView : UITableView = {
        let v = UITableView()
        v.delegate = self
        v.dataSource = self
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTableView()
    }
    
    private func setupTableView(){
        tableView.register(UserGuidePageTableCell.self, forCellReuseIdentifier: userGuidePageTableCellId)
        addSubview(tableView)
        tableView.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 50, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        self.sizeHeaderToFit()
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension UserGuidePageCell : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userGuidePageTableCellId, for: indexPath) as! UserGuidePageTableCell
        cell.titleLabel.text = titles[indexPath.section][indexPath.item]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "📝 常见问题"
        }else if section == 1 {
            return "✅ 操作说明"
        }
        return "❓"
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    internal func sizeHeaderToFit() {
        
    }
    
}
