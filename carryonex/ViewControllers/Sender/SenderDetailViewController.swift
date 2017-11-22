//
//  SenderDetailViewController.swift
//  carryonex
//
//  Created by Xin Zou on 11/20/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import Photos
import AWSCognito
import AWSCore
import AWSS3
import ALCameraViewController


class SenderDetailViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    // master info card
    @IBOutlet weak var shiperInfoCardView: UIView!
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var dateDayLabel: UILabel!
    @IBOutlet weak var youxiangCodeLabel: UILabel!
    @IBOutlet weak var senderProfileImageButton: UIButton!
    @IBOutlet weak var startAddressLabel: UILabel!
    @IBOutlet weak var endAddressLabel: UILabel!
    // detail info card
    @IBOutlet weak var senderInfoCardView: UIView!
    @IBOutlet weak var nameTextField: UITextField!      // 0
    @IBOutlet weak var phoneTextField: UITextField!     // 1
    @IBOutlet weak var addressTextField: UITextField!   // 2
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageTextField: UITextField!   // 3
    // price contents
    @IBOutlet weak var priceValueTitleLabel: UILabel!
    @IBOutlet weak var priceValueTextField: UITextField! // 4
    @IBOutlet weak var priceValueTextFieldLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var currencyTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var priceMinLabel: UILabel!
    @IBOutlet weak var priceMidLabel: UILabel!
    @IBOutlet weak var priceMaxLabel: UILabel!
    @IBOutlet weak var priceSlider: UISlider!
    @IBOutlet weak var priceFinalLabel: UILabel!
    @IBOutlet weak var priceFinalHintLabel: UILabel!
    // DONE!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - actions forcontents
    
    @IBAction func senderProfileImageButtonTapped(_ sender: Any) {
        //TODO:
    }
    
    @IBAction func currencyTypeSegmentValueChanged(_ sender: Any) {
        currencyType = currencyTypeSegmentControl.selectedSegmentIndex == 0 ? .USD : .CNY
        updatePriceContentsFor(newPrice: priceFinal)
    }
    
    @IBAction func priceSliderValueChanged(_ sender: Any) {
        priceFinal = Double(priceSlider.value)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        handleSubmissionButton()
    }
    
    
    // MARK: - model properties
    
    var trip: Trip?
    var offerPrice: Double = 0
    
    let cellId = "ItemImageCollectionCell"
    var imageUploadingSet: Set<String> = []
    var imageUploadSequence: [String : URL] = [:]
    
    var images : [ImageNamePair] = [] {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    struct ImageNamePair {
        var name : String?
        var image: UIImage?
        
        init(name: String, image: UIImage) {
            self.name = name
            self.image = image
        }
    }

    var currencyType: CurrencyType = .USD
    var priceFinal: Double = 5 {
        didSet {
            priceFinalLabel.text = currencyType.rawValue + String(format: "%.2f", priceFinal)
        }
    }
    enum textFieldTag: Int {
        case name = 0
        case phone = 1
        case address = 2
        case message = 3
        case price = 4
    }
    
    var activityIndicator: UIActivityIndicatorCustomizeView! // UIActivityIndicatorView!
    var keyboardHeight: CGFloat = 160
    
    //MARK: - Methods Start Here
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "寄件"
        scrollView.delegate = self
        setupCollectionView()
        setupTextFields()
        setupActivityIndicator()
    }
    
    private func setupCollectionView(){
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = .white
    }
    
    private func setupTextFields(){
        nameTextField.delegate = self
        phoneTextField.delegate = self
        addressTextField.delegate = self
        messageTextField.delegate = self
        priceValueTextField.delegate = self
        priceValueTextField.addTarget(self, action: #selector(priceValueTextFieldDidChange), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    private func setupActivityIndicator(){
        activityIndicator = UIActivityIndicatorCustomizeView() // UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.center = view.center
        activityIndicator.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        view.addSubview(activityIndicator)
    }

    @objc fileprivate func handleSubmissionButton() {
        guard let trip = trip else {
            print("error: get trip = nil in SenderDetailViewController... aborad...")
            return
        }
        let t = "‼️您还没填完信息"
        let ok = "朕知道了"
        guard let destAddress = addressTextField.text, addressTextField.text != "" else {
            let m = "请从地图上选择您的快件寄送【收货地址】，我们将为您找到帮您送件的客户。"
            displayGlobalAlert(title: t, message: m, action: ok, completion: nil)
            return
        }
        guard imageUploadingSet.count != 0 else {
            displayAlert(title: t, message: "请拍摄您的物品照片，便于出行人了解详情。", action: ok)
            return
        }
        
        uploadImagesToAwsAndGetUrls { (urls, error) in
            if let err = error {
                let m = "上传照片失败啦，错误信息：\(err.localizedDescription)"
                self.displayGlobalAlert(title: "哎呀", message: m, action: "稍后再试一次", completion: nil)
                return
            }
            // TODO: use new api for postRequest!!!
//            if let urls = urls,
//                let totalValueString = self.cellTotalValue?.textField.text,
//                let totalValue = Double(totalValueString),
//                let costString = self.cell07Cost?.textField.text,
//                let cost = Double(costString),
//                let trip = self.trip {
//
//                //TODO: Put in description.
//                ApiServers.shared.postRequest(totalValue: totalValue,
//                                              cost: cost,
//                                              destination: destAddress,
//                                              trip: trip,
//                                              imageUrls: urls,
//                                              description: "",
//                                              completion: { (success, error) in
//                                                if let error = error {
//                                                    print("Post Request Error: \(error.localizedDescription)")
//                                                    return
//                                                }
//                                                print("Post request success!")
//                })
//
//            }
            
            
        }
    }

    
    
}

// MARK: -
extension SenderDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    // number of images = [1,6]
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(images.count + 1, 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ItemImageCollectionCell else {
            return UICollectionViewCell()
        }
        cell.parentVC = self
        cell.backgroundColor = .white
        // number of images = [1,6]
        if indexPath.item < images.count || (images.count == 6) {
            cell.imageFileName = images[indexPath.item].name!
            cell.imageView.image = images[indexPath.item].image!
            cell.cancelButton.isHidden = false
            cell.cancelButton.isEnabled = true
        } else {
            cell.cancelButton.isHidden = true
            cell.cancelButton.isEnabled = false
            cell.imageView.image = #imageLiteral(resourceName: "CarryonEx_UploadID") // upload ID image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let s : CGFloat = (collectionView.bounds.width - 20) / (UIDevice.current.userInterfaceIdiom == .phone ? 3 : 6)
        return CGSize(width: s, height: s)
    }

    
}

extension SenderDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == images.count { // adding image cell tapped
            openALCameraController()
        }
    }
    
    func removeImagePairOfName(imgName: String) {
        for i in 0..<images.count {
            print("get imageName = \(images[i].name!), target name = \(imgName), trying to remove it...")
            if images[i].name! == imgName {
                images.remove(at: i)
                imageUploadingSet.remove(imgName)
                imageUploadSequence.removeValue(forKey: imgName)
                print("OK, remove file success: \(imgName)")
                return
            }
        }
    }
    
    
}


/// MARK: - image operation in local and uploading to AWS

extension SenderDetailViewController {
    
    func openALCameraController(){
        let corpingParms = CroppingParameters(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: CGSize(width: 200, height: 200))
        let cameraViewController = CameraViewController(croppingParameters: corpingParms, allowsLibraryAccess: true, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: true, completion: { (getImg, phAsset) in
            if let img = getImg {
                let formatter = DateFormatter()
                formatter.timeZone = TimeZone.current
                formatter.dateFormat = "yyyy_MM_dd_hhmmss"
                let imgName = "\(formatter.string(from: Date())).JPG"
                self.presentImageIntoCellCollectionView(img, imageName: imgName)
            }
            self.dismiss(animated: true, completion: nil)
        })
        self.present(cameraViewController, animated: true, completion: nil)
    }
    
    private func presentImageIntoCellCollectionView(_ image: UIImage, imageName: String){
        let localFileUrl = self.saveImageToDocumentDirectory(img: image, name: imageName)
        self.imageUploadSequence[imageName] = localFileUrl
        self.imageUploadingSet.insert(imageName)
        self.images.append(ImageNamePair(name: imageName, image: image))
    }
    
    internal func uploadImagesToAwsAndGetUrls(completion: @escaping([String]?, Error?) -> Void) {
        
        var urls = [String]()
        
        for pair in imageUploadSequence {
            let imageName = pair.key
            
            if let url = imageUploadSequence[imageName] {
                AwsServerManager.shared.uploadFile(fileName: imageName, imgIdType: .requestImages, localUrl: url, completion: { (err, getUrl) in
                    
                    if let err = err {
                        print("error in uploadImagesToAwsAndGetUrls(): err = \(err.localizedDescription)")
                        completion(nil, err)
                        return
                    }
                    
                    if let getUrl = getUrl {
                        urls.append(getUrl.absoluteString)
                        
                        if urls.count == self.imageUploadSequence.count {
                            urls.sort {$0 < $1}
                            // TODO: upload urls dictionary to our Server;
                            //                            print("\n\n search this senten to locate in code to get dictionary - Xin")
                            //                            print("get dictionary ready for uploading to Server = ")
                            //                            for pair in imageUrlsDictionary {
                            //                                print("key = \(pair.key), val = \(pair.value)")
                            //                            }
                            
                            completion(urls, nil)
                            // then remove the images from cache
                            self.removeAllImageFromLocal()
                        }
                        
                    } else {
                        completion(nil, nil)
                    }
                })
                
            } else {
                print("error in uploadImagesToAwsAndGetUrls(): can not get imageUploadSequence[fileName] url !!!!!!")
                completion(nil, nil)
            }
        }
    }
    
    func removeAllImageFromLocal(){
        for itemName in imageUploadingSet {
            removeImageWithUrlInLocalFileDirectory(fileName: itemName)
            imageUploadSequence.removeValue(forKey: itemName)
        }
        if imageUploadSequence.count == 0 {
            imageUploadingSet.removeAll()
        }
    }
    
    func removeImageWithUrlInLocalFileDirectory(fileName: String){
        let fileType = fileName.components(separatedBy: ".").first!
        if fileType == ImageTypeOfID.profile.rawValue { return }
        
        let fileManager = FileManager.default
        let documentUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        
        guard let filePath = documentUrl.path else { return }
        print("try to remove file from path: \(filePath), fileExistsAtPath==\(fileManager.fileExists(atPath: filePath))")
        do {
            try fileManager.removeItem(atPath: "\(filePath)/\(fileName)")
            print("OK remove file at path: \(filePath), fileName = \(fileName)")
        }catch let err {
            print("error : when trying to move file: \(fileName), from path = \(filePath), get err = \(err)")
        }
    }
    
    func saveImageToDocumentDirectory(img : UIImage, name: String) -> URL {
        let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = name //"\(name).JPG"
        let profileImgLocalUrl = documentUrl.appendingPathComponent(fileName)
        if let imgData = UIImageJPEGRepresentation(img, imageCompress) {
            try? imgData.write(to: profileImgLocalUrl, options: .atomic)
        }
        print("save image to DocumentDirectory: \(profileImgLocalUrl)")
        return profileImgLocalUrl
    }

    
    
}


// MARK: -
extension SenderDetailViewController: UITextFieldDelegate {
    
    public func priceValueTextFieldDidChange(){
        if let v = priceValueTextField.text {
            let d = Double(v) ?? 5
            updatePriceContentsFor(newPrice: d)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == textFieldTag.price.rawValue {
            //scrollViewAnimateToBottom()
            priceValueTextFieldLeftConstraint.constant = priceValueTitleLabel.bounds.width
            animateUIifNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (priceValueTextField.text == nil || priceValueTextField.text == ""), textField.tag == textFieldTag.price.rawValue {
            priceValueTextFieldLeftConstraint.constant = 0
            animateUIifNeeded()
        }
    }
    
    fileprivate func updatePriceContentsFor(newPrice: Double) {
        priceValueTitleLabel.text = "物品价值: " + currencyType.rawValue
        let r: Double = 1.1
        let pMin: Double = newPrice < 5.0 ? 5 : newPrice
        let pMax: Double = newPrice < 5.0 ? pMin * r : newPrice * r
        let pMid: Double = (pMax + pMin) / 2.0
        priceMinLabel.text = currencyType.rawValue + String(format: "%.2f", pMin)
        priceMidLabel.text = currencyType.rawValue + String(format: "%.2f", pMid)
        priceMaxLabel.text = currencyType.rawValue + String(format: "%.2f", pMax)
        
        priceSlider.minimumValue = Float(pMin)
        priceSlider.value = Float(pMid)
        priceSlider.maximumValue = Float(pMax)
        priceFinal = Double(priceSlider.value)
    }
    
    private func scrollViewAnimateToBottom(){
        var offset = scrollView.contentOffset
        let expOffset = scrollView.bounds.height - view.bounds.height
        if offset.y < expOffset {
            offset.y = expOffset
        }
        offset.y += keyboardHeight
        scrollView.setContentOffset(offset, animated: true)
    }
    
    public func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        keyboardHeight = frame.cgRectValue.height
    }
    
    public func keyboardWillHide(_ notification: Notification) {
//        var offset = scrollView.contentOffset
//        if offset.y < 40 {
//            return
//        }
//        offset.y -= keyboardHeight
//        scrollView.setContentOffset(offset, animated: true)
    }
    
    fileprivate func keyboardDismiss(){
        addressTextField.resignFirstResponder()
        priceValueTextField.resignFirstResponder()
    }

    fileprivate func animateUIifNeeded(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1.6, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
}

extension SenderDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        keyboardDismiss()
    }
}



// MARK: -
class ItemImageCollectionCell: UICollectionViewCell {
    
    var parentVC: SenderDetailViewController?
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var imageFileName = ""
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        removeLocalImageWithFileName()
        removeLocalImageInCollectionView()
    }
    
    private func removeLocalImageWithFileName(){
        parentVC?.removeImageWithUrlInLocalFileDirectory(fileName: imageFileName)
    }
    
    private func removeLocalImageInCollectionView(){
        parentVC?.removeImagePairOfName(imgName: imageFileName)
    }
    
    
}






