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
            if dataSourceCarrier.count == 0 || dataSourceSender.count == 0 {
                fetchRequests()
            }
        }
    }
    
    var isFetching = false
    
    @IBOutlet weak var tableViewShiper: UITableView!
    @IBOutlet weak var tableViewSender: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint! // default == 400
    @IBOutlet weak var tableViewLeftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var listButtonShiper: UIButton!
    @IBOutlet weak var listButtonSender: UIButton!
    @IBOutlet weak var sliderBar: UIView!
    @IBOutlet weak var sliderBarCenterConstraint: NSLayoutConstraint!
    
    var selectedIndexPath: IndexPath?
    enum tableViewRowHeight: CGFloat {
        case mainCard = 160
        case detailCard = 300
    }
    
    var dataSourceCarrier = [TripOrder]() {
        didSet {
            self.tableViewShiper.reloadData()
        }
    }
    
    var dataSourceSender = [TripOrder]() {
        didSet {
            self.tableViewSender.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //setupNavigationBar()
        setupSwipeGestureRecognizer()
        listType = .carrier
        fetchRequests()
        setupTableViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dataSourceCarrier.removeAll()
        dataSourceSender.removeAll()
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
    
    private func setupTableViews(){
        tableViewShiper.separatorStyle = .none
        tableViewSender.separatorStyle = .none
    }
    
    private func setupSwipeGestureRecognizer(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipe))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipe))
        swipeRight.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }

    func respondToSwipe(_ gesture: UIGestureRecognizer){
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
        
        let offset = (listType == .carrier) ? dataSourceCarrier.count : dataSourceSender.count
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
                    self.dataSourceCarrier.append(contentsOf: tripOrders)
                    //self.dataSource = self.dataSourceCarrier
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
        if tableView.tag == TripCategory.carrier.rawValue {
            guard let cell = tableViewShiper.dequeueReusableCell(withIdentifier: "OrderListCardShiperCell", for: indexPath) as? OrderListCardShiperCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            let tripOrder = dataSourceCarrier[indexPath.section]
            if let tripRequest = tripOrder.requests?[indexPath.row] {
                cell.request = tripRequest.request
                cell.indexPath = indexPath
                cell.delegate = self
                cell.carrierDelegate = self
                if let startCountry = tripOrder.trip.startAddress?.country?.rawValue,let startState = tripOrder.trip.startAddress?.state,let startCity = tripOrder.trip.startAddress?.city{
                    cell.startAddressLabel.text = startCountry+" "+startState+" "+startCity
                }
                if let endCountry = tripOrder.trip.endAddress?.country?.rawValue,let endState = tripOrder.trip.endAddress?.state,let endCity = tripOrder.trip.endAddress?.city{
                    cell.endAddressLabel.text = endCountry+" "+endState+" "+endCity
                }
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            guard let cell = tableViewSender.dequeueReusableCell(withIdentifier: "OrderListCardSenderCell", for: indexPath) as? OrderListCardSenderCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            let tripOrder = dataSourceSender[indexPath.section]
            if let tripRequest = tripOrder.requests?[indexPath.row] {
                cell.request = tripRequest.request
                cell.indexPath = indexPath
                cell.delegate = self
                cell.senderDelegate = self
                if let startCountry = tripOrder.trip.startAddress?.country?.rawValue,let startState = tripOrder.trip.startAddress?.state,let startCity = tripOrder.trip.startAddress?.city{
                    cell.startAddressLabel.text = startCountry+" "+startState+" "+startCity
                }
                if let endCountry = tripOrder.trip.endAddress?.country?.rawValue,let endState = tripOrder.trip.endAddress?.state,let endCity = tripOrder.trip.endAddress?.city{
                    cell.endAddressLabel.text = endCountry+" "+endState+" "+endCity
                }
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == TripCategory.carrier.rawValue {
            return self.dataSourceCarrier.count
        } else {
            return self.dataSourceSender.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == TripCategory.carrier.rawValue {
            let tripOrder = dataSourceCarrier[section]
            return tripOrder.requests?.count ?? 0
        } else {
            let tripOrder = dataSourceSender[section]
            return tripOrder.requests?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let dataSource = listType == .carrier ? dataSourceCarrier : dataSourceSender
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
        if selectedIndexPath == indexPath {
            return tableViewRowHeight.mainCard.rawValue + tableViewRowHeight.detailCard.rawValue
        }
        return tableViewRowHeight.mainCard.rawValue
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndexPath != indexPath {
            selectedIndexPath = indexPath
        } else {
            selectedIndexPath = nil
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

extension OrderListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tableViewDefaultHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 400 : 600
        let offsetY = scrollView.contentOffset.y

        if offsetY > 0 { // moving up
            if tableViewHeightConstraint.constant < (view.bounds.height - 30) {
                tableViewHeightConstraint.constant = tableViewDefaultHeight + offsetY
                animateImageForTableScrolling()
            }
        } else { // moving down
            if tableViewHeightConstraint.constant > tableViewDefaultHeight {
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

extension OrderListViewController: OrderListCellDelegate {
    
    func orderCellButtonTapped(request: Request, category: TripCategory, transaction: RequestTransaction, indexPath: IndexPath) {
        //let tableView = (category == .carrier) ? tableViewShiper : tableViewSender
        print("Transaction tapped: \(transaction.displayString())")
    }
    
}

extension OrderListViewController: OrderListCarrierCellDelegate {
    
    func orderListCarrierSenderProfileTapped() {
        print("Carrier Sender Profile Tapped")
    }
    
    func orderListCarrierSenderPhoneTapped() {
        print("Carrier Sender Phone Tapped")
    }
    
    func orderListCarrierMoreImagesTapped() {
        print("Carrier More Images Tapped")
    }
    
    func orderListCarrierCodeShareTapped() {
        print("Carrier Share Tapped")
    }
}

extension OrderListViewController: OrderListSenderCellDelegate {
    
    func orderListSenderItemImageTapped() {
        print("Sender Item Image Tapped")
    }
    
    func orderListSenderCarrierProfileImageTapped() {
        print("Sender Carrier Profile Image Tapped")
    }
    
    func orderListSenderCarrierPhoneTapped() {
        print("Sender Carrier Phone Tapped")
    }
}

