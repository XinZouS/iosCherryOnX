//
//  OrdersRequestDetailViewController.swift
//  carryonex
//
//  Created by Xin Zou on 11/29/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import AlamofireImage
import JXPhotoBrowser

class OrdersRequestDetailViewController: UIViewController {
    
    @IBOutlet weak var blockerWidth: NSLayoutConstraint!
    weak var selectedCell: PhotoBrowserCollectionViewCell?
    @IBOutlet weak var phontobrowser: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var imageCountButton: UIButton!
    // trip info
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var dateDayLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var startAddressLabel: UILabel!
    @IBOutlet weak var endAddressLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    // request info
    @IBOutlet weak var senderPhoneButton: UIButton!
    @IBOutlet weak var senderImageButton: UIButton!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var senderScoreWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemValueLabel: UILabel!
    @IBOutlet weak var itemMessageTextView: UITextView!
    @IBOutlet weak var senderDescLabel: UILabel!
    
    // recipient info
    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var recipientPhoneLabel: UILabel!
    @IBOutlet weak var recipientAddressLabel: UILabel!
    @IBOutlet weak var recipientPhoneCallButton: UIButton!
    
    // done buttons
    @IBOutlet weak var finishButton: RequestTransactionButton!
    @IBOutlet weak var finishButton2: RequestTransactionButton!
    
    let toShipperViewSegue = "toOtherShipperView"
    let postRateSegue = "PostRateSegue"
    
    @IBAction func moreImageTapped(_ sender: Any) {
        
    }
    
    @IBAction func senderPhoneButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func senderImageButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: toShipperViewSegue, sender: self)
    }
    
    @IBAction func recipientPhoneCallButtonTapped(_ sender: Any) {
    
    }
    
    @IBAction func PhoneButtonTapped(_ sender: Any) {        
        if let PhoneNumberUrl = recipientPhoneLabel.text,let url = URL(string:"tel://"+PhoneNumberUrl) {
            //根据iOS系统版本，分别处理
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func requestStatusButtonHandler(sender: RequestTransactionButton) {
        let transaction = sender.transaction
        print("Transaction tapped: \(transaction.displayString())")
        
        if transaction == .allowRating {
            performSegue(withIdentifier: postRateSegue, sender: nil)
            return
        }
        
        let tripId = trip.id
        let requestId = request.id
        let requestCategory = category
        displayAlertOkCancel(title: "确认操作", message: transaction.confirmDescString()) { [weak self] (style) in
            if style == .default {
                ApiServers.shared.postRequestTransaction(requestId: requestId,
                                                         tripId: tripId,
                                                         transaction: transaction,
                                                         completion: { (success, error, statusId) in
                                                            if (success) {
                                                                if let statusId = statusId {
                                                                    print("New status: \(statusId)")
                                                                    TripOrderDataStore.shared.pull(category: requestCategory, completion: {
                                                                        self?.reloadData()
                                                                    })
                                                                } else {
                                                                    debugPrint("No status found, bad call")
                                                                }
                                                            }
                })
            }
        }
    }
    
    // MARK: - Data models
    var trip: Trip = Trip()
    
    var request: Request!
    var category: TripCategory = .carrier
    
    var buttonsToShow: OrderButtonToShow = .noButtons {
        didSet {
            switch buttonsToShow {
            case .noButtons:
                finishButton.isHidden = true
                finishButton2.isHidden = true
            case .oneButton:
                finishButton.isHidden = false
                finishButton2.isHidden = true
            case .twoButtons:
                finishButton.isHidden = false
                finishButton2.isHidden = false
            }
        }
    }
    
    
    // MARK: - VC funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "订单详情"
        navigationController?.isNavigationBarHidden = false        
        setupScrollView()
        setupView()
        setupCollectionView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == postRateSegue, let viewController = segue.destination as? OrderCommentRateController {
            viewController.category = category
            if category == .carrier {
                viewController.commenteeId = request.ownerId
                viewController.commenteeRealName = request.ownerRealName ?? request.ownerUsername
                viewController.commenteeImage = request.ownerImageUrl
            } else {
                viewController.commenteeId = trip.carrierId
                viewController.commenteeRealName = trip.carrierRealName ?? trip.carrierUsername
                viewController.commenteeImage = trip.carrierImageUrl
            }
        }
    }
    
    private func setupCollectionView(){
        phontobrowser.register(PhotoBrowserCollectionViewCell.self, forCellWithReuseIdentifier: PhotoBrowserCollectionViewCell.defalutId)
    }

    private func setupScrollView(){
        scrollView.delegate = self
        scrollView.isDirectionalLockEnabled = true
        scrollView.alwaysBounceVertical = true
    }
    private func setupView() {
        updateRequestInfoAppearance(request: request)
        
        if let trip = TripOrderDataStore.shared.getTrip(category: category, id: request.tripId) {
            self.trip = trip
        }
        
        var profileImageString: String?
        
        if category == .carrier {
            profileImageString = request.ownerImageUrl
            senderNameLabel.text = request.ownerRealName
            senderDescLabel.text = "寄件人评分"
            recipientPhoneCallButton.isHidden = false
            senderScoreWidthConstraint.constant = CGFloat(request.ownerRating * 20) //*(100/5)
            
        } else {
            profileImageString = trip.carrierImageUrl
            senderNameLabel.text = trip.carrierRealName
            senderDescLabel.text = "出行人评分"
            recipientPhoneCallButton.isHidden = true
            senderScoreWidthConstraint.constant = CGFloat(trip.carrierRating * 20) //*(100/5)
        }
        
        if let urlString = profileImageString, let imgUrl = URL(string: urlString) {
            senderImageButton.af_setImage(for: .normal, url: imgUrl, placeholderImage: #imageLiteral(resourceName: "carryonex_UserInfo"), filter: nil, progress: nil, completion: nil)
        }else{
            senderImageButton.setImage(#imageLiteral(resourceName: "carryonex_UserInfo"), for: .normal)
        }
        
        incomeLabel.text = "$" + request.priceString()
        recipientNameLabel.text = request.endAddress?.recipientName
        recipientPhoneLabel.text = request.endAddress?.phoneNumber
        recipientAddressLabel.text = request.endAddress?.detailedAddress
        itemValueLabel.text = "$" + request.itemValue()
        itemMessageTextView.text = request.note
        
        dateMonthLabel.text = trip.getMonthString()
        dateDayLabel.text = trip.getDayString()
        startAddressLabel.text = trip.startAddress?.fullAddressString()
        endAddressLabel.text = trip.endAddress?.fullAddressString()
        blockerWidth.constant = UIScreen.main.bounds.width-150
        if request.images.count > 2{
            imageCountButton.setTitle("+\(request.images.count-2)", for: .normal)
        }else{
            imageCountButton.setTitle("", for: .normal)
        }
    }
    
    private func reloadData() {
        if let updatedRequest = TripOrderDataStore.shared.getRequest(category: category, requestId: self.request.id) {
            request = updatedRequest
            setupView()
        }
    }
}

extension OrdersRequestDetailViewController: OrderListCardCellProtocol {
    func updateButtonAppearance(status: RequestStatus) {
        if category == .carrier {
            switch status {
            case .waiting:
                buttonsToShow = .twoButtons
            case .accepted, .delivered, .paid, .inDelivery, .deliveryConfirmed: //.pendingRefund,
                buttonsToShow = .oneButton
            default:
                buttonsToShow = .noButtons
            }
            
            switch status {
            case .waiting:
                finishButton.transaction = .carrierAccept
                finishButton2.transaction = .carrierReject
            case .accepted:
                finishButton.transaction = .carrierCancel
            case .paid:
                finishButton.transaction = .carrierReceive
//            case .pendingRefund:
//                finishButton.transaction = .carrierReceive
            case .inDelivery:
                finishButton.transaction = .carrierShip
            case .delivered, .deliveryConfirmed:
                finishButton.transaction = .allowRating
            default:
                break
            }
            
        } else {
            //Carrier
            switch status {
            case .waiting, .accepted:
                buttonsToShow = .twoButtons
            case .delivered, .deliveryConfirmed:
                buttonsToShow = .oneButton
            default:
                buttonsToShow = .noButtons
            }
            
            switch status {
            case .waiting:
                finishButton.transaction = .shipperCancel
                finishButton2.transaction = .shipperPairing
            case .accepted:
                finishButton.transaction = .shipperPay
                finishButton2.transaction = .shipperCancel
            case .delivered:
                finishButton.transaction = .shipperConfirm
            case .deliveryConfirmed:
                finishButton.transaction = .allowRating
            default:
                break
            }
        }
    }
    
    func updateRequestInfoAppearance(request: Request) {
        //Override
        if let statusId = request.statusId, let status = RequestStatus(rawValue: statusId) {
            updateButtonAppearance(status: status)
            statusLabel.text = status.displayString()
            statusLabel.backgroundColor = status.displayColor(category: category)
        }
    }
}

extension OrdersRequestDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return request.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCollectionViewCell.defalutId, for: indexPath) as! PhotoBrowserCollectionViewCell
        cell.imageView.af_setImage(withURL: URL(string: request.images[indexPath.row].imageUrl)!)
        return cell
    }
}

extension OrdersRequestDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoBrowserCollectionViewCell else {
            return
        }
        selectedCell = cell
        // 调起图片浏览器
        let vc = PhotoBrowser(showByViewController: self, delegate: self)
        // 装配PageControl，提供了两种PageControl实现，若需要其它样式，可参照着自由定制
        if arc4random_uniform(2) % 2 == 0 {
            vc.pageControlDelegate = PhotoBrowserDefaultPageControlDelegate(numberOfPages: request.images.count)
        } else {
            vc.pageControlDelegate = PhotoBrowserNumberPageControlDelegate(numberOfPages: request.images.count)
        }
        vc.show(index: indexPath.item)
    }
}
// 实现浏览器代理协议
extension OrdersRequestDetailViewController: PhotoBrowserDelegate {
    func numberOfPhotos(in photoBrowser: PhotoBrowser) -> Int {
        return request.images.count
    }
    
    /// 缩放起始视图
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailViewForIndex index: Int) -> UIView? {
        return phontobrowser?.cellForItem(at: IndexPath(item: index, section: 0))
    }
    
    /// 图片加载前的placeholder
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailImageForIndex index: Int) -> UIImage? {
        let cell = phontobrowser?.cellForItem(at: IndexPath(item: index, section: 0)) as? PhotoBrowserCollectionViewCell
        // 取thumbnailImage
        return cell?.imageView.image
    }
    
    
    /// 最高清图，原图。（需要时可实现本方法）
    /*
     func photoBrowser(_ photoBrowser: PhotoBrowser, rawUrlForIndex index: Int) -> URL? {
     return nil
     // 测试
     return index == 2 ? URL(string: "https://b-ssl.duitang.com/uploads/item/201501/28/20150128173439_RK4XS.jpeg") : nil
     }*/
    
    /// 长按图片
    func photoBrowser(_ photoBrowser: PhotoBrowser, didLongPressForIndex index: Int, image: UIImage) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let saveImageAction = UIAlertAction(title: "保存图片", style: .default) { (_) in
            print("保存图片：\(image)")
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        actionSheet.addAction(saveImageAction)
        actionSheet.addAction(cancelAction)
        photoBrowser.present(actionSheet, animated: true, completion: nil)
    }
}


extension OrdersRequestDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let y = scrollView.contentOffset.y
        let maxY = scrollView.contentSize.height - self.view.bounds.height + 100
        if x != 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: false)
        }
        if y < 0 || y > maxY {
            return
        }
        scrollView.setContentOffset(CGPoint(x:0, y: y), animated: false)
    }
  
}
