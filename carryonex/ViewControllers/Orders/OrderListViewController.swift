//
//  OrderListViewController.swift
//  carryonex
//
//  Created by Zian Chen on 11/13/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class OrderListViewController: UIViewController {
    
    var listType: TripCategory = .carrier {
        didSet {
            if dataSourceShiper.count == 0 || dataSourceSender.count == 0 {
                fetchRequests()
            }
        }
    }
    
    var isFetching = false
    
    @IBOutlet weak var tableViewShiper: UITableView!
    @IBOutlet weak var tableViewSender: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint! // default == 400
    @IBOutlet weak var tableViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var listButtonShiper: UIButton!
    @IBOutlet weak var listButtonSender: UIButton!
    @IBOutlet weak var sliderBar: UIView!
    @IBOutlet weak var sliderBarCenterConstraint: NSLayoutConstraint!
    
    
    
    var selectedRowIndex: IndexPath = IndexPath(row: -1, section: 0) {
        didSet{
            if listType == .sender {
                self.tableViewShiper.beginUpdates()
                self.tableViewShiper.endUpdates()
            }else{
                self.tableViewSender.beginUpdates()
                self.tableViewSender.endUpdates()
            }
        }
    }
    enum tableViewRowHeigh: CGFloat {
        case mainCard = 160
        case detailCard = 300
    }
    
//    var dataSource: [TripOrder]? {
//        didSet {
//            DispatchQueue.main.async(execute: {
//                self.tableViewShiper.reloadData()
//            })
//        }
//    }
    
    var dataSourceShiper = [TripOrder]() {
        didSet {
            dataSourceSender = dataSourceShiper // BUG: rmeove this line, for testing only
            DispatchQueue.main.async(execute: {
                self.tableViewShiper.reloadData()
            })
        }
    }
    var dataSourceSender = [TripOrder]() {
        didSet {
            DispatchQueue.main.async(execute: {
                self.tableViewSender.reloadData()
            })
        }
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupNavigationBar()
        setuptableViews()
        setupSwipeGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRequests()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        dataSourceShiper.removeAll()
        dataSourceSender.removeAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleDataSourceChanged(sender: UISegmentedControl) {
        if let category = TripCategory(rawValue: sender.selectedSegmentIndex) {
            listType = category
        }
    }
    
    private func setupNavigationBar(){
        title = "出行订单"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    private func setuptableViews(){
        tableViewShiper.separatorStyle = .none
        tableViewSender.separatorStyle = .none
    }
    
    private func setupSwipeGestureRecognizer(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(responToSwipe))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(responToSwipe))
        swipeRight.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }

    func responToSwipe(_ gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                animateListMoveRight()
                
            case .left:
                animateListMoveLeft()
                
            default:
                break
            }
        }
    }
    
    @IBAction func listButtonShiperTapped(_ sender: Any) {
        animateListMoveRight()
    }
    
    @IBAction func listButtonSenderTapped(_ sender: Any) {
        animateListMoveLeft()
    }
    
    private func animateListMoveRight(){
        if tableViewLeftConstraint.constant < 0 {
            tableViewLeftConstraint.constant = 0
            sliderBarCenterConstraint.constant = 0
            listType = .sender
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    private func animateListMoveLeft(){
        if tableViewLeftConstraint.constant == 0 {
            tableViewLeftConstraint.constant = -(self.view.bounds.width)
            sliderBarCenterConstraint.constant = listButtonShiper.bounds.width
            listType = .carrier
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    

    func fetchRequests() {
        
        guard isFetching == false else { return }
        
        let offset = (listType == .carrier) ? dataSourceShiper.count : dataSourceSender.count
        let page = 4
        
        isFetching = true
        ApiServers.shared.getUsersTrips(userType: listType, offset: offset, pageCount: page) { (tripOrders, error) in
            
            self.isFetching = false
            if let error = error {
                print("ApiServers.shared.getUsersTrips Error: \(error.localizedDescription)")
                return
            }
            
            if tripOrders == nil {
                let m = "您太久没有上线啦，或您的账号在其他设备登录过，为确保信息安全请重新登入。"
                self.displayGlobalAlert(title: "🤔登录已过期", message: m, action: "重新登录", completion: {
                    ProfileManager.shared.logoutUser()
                })
                return
            }
            
            if let tripOrders = tripOrders {
                if self.listType == .carrier {
                    self.dataSourceShiper.append(contentsOf: tripOrders)
                    //self.dataSource = self.dataSourceShiper
                } else {
                    self.dataSourceSender.append(contentsOf: tripOrders)
                    //self.dataSource = self.dataSourceSender
                }
            }
        }
    }
    
    
}

extension OrderListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0, let cell = tableViewShiper.dequeueReusableCell(withIdentifier: "OrderListCardShiperCell", for: indexPath) as? OrderListCardShiperCell {
//            let request = requests[indexPath.row].request
//            cell.request = request
//            cell.cellType = listType
//            request.printAllData()
            cell.selectionStyle = .none
            return cell
        }
        if tableView.tag == 1, let cell = tableViewSender.dequeueReusableCell(withIdentifier: "OrderListCardSenderCell", for: indexPath) as? OrderListCardSenderCell {
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return dataSourceShiper.count
        }
        if tableView.tag == 1 {
            return dataSourceSender.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let dataSource = listType == .carrier ? dataSourceShiper : dataSourceSender
        let currentPage = dataSource.count
        guard let currentItem = dataSource[currentPage - 1].requests?.count,
            !isFetching else {
            return
        }
        
        let section = indexPath.section
        if (section == currentPage - 1) && (indexPath.row == currentItem - 1) {
            fetchRequests()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedRowIndex.row == indexPath.row {
            return tableViewRowHeigh.mainCard.rawValue + tableViewRowHeigh.detailCard.rawValue
        }
        return tableViewRowHeigh.mainCard.rawValue
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRowIndex = (selectedRowIndex.row == indexPath.row) ? IndexPath(row: -1, section: 0) : indexPath
    }
    
    
}

extension OrderListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tableViewDefaultHeigh: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 400 : 600
        let offsetY = scrollView.contentOffset.y

        if offsetY > 0 { // moving up
            if tableViewHeightConstraint.constant < (view.bounds.height - 30) {
                tableViewHeightConstraint.constant = tableViewDefaultHeigh + offsetY
                animateImageForTableScrolling()
            }
        } else { // moving down
            if tableViewHeightConstraint.constant > tableViewDefaultHeigh {
                tableViewHeightConstraint.constant = tableViewHeightConstraint.constant + offsetY
                animateImageForTableScrolling()
            }
        }
    }
    
    fileprivate func animateImageForTableScrolling(){
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
