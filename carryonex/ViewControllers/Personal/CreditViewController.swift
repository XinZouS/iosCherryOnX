//
//  CreditViewController.swift
//  carryonex
//
//  Created by Xin Zou on 12/1/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit


enum TransactionType: String {
    case payment = "支付"
    case extract = "提现"
}

struct TransactionDetail {
    let date: TimeInterval
    let type: TransactionType
    let value: Double
    
    init(date: TimeInterval, type: TransactionType, value: Double) {
        self.date = date
        self.type = type
        self.value = value
    }
}


class CreditViewController: UIViewController {
    
    @IBOutlet weak var creditTitleLabel: UILabel!
    @IBOutlet weak var creditValueLabel: UILabel!
    @IBOutlet weak var faqButton: UIButton!
    @IBOutlet weak var extractCashButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func faqButtonTapped(_ sender: Any) {
        let webVC = WebController()
        self.navigationController?.pushViewController(webVC, animated: true)
        webVC.title = title
        if let url = URL(string: "\(ApiServers.shared.host)/doc_wallet_info") {
            webVC.url = url
        }
    }
    
    @IBAction func extractCashButtonTapped(_ sender: Any) {
        // TODO: extractCash button tapped;
    }
    
    var dataSource: [TransactionDetail] = []
    let cellId = "CreditCell"
    let dateFormatter = DateFormatter()
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "钱包"
        setupNavigationBar()
        loadTransactionInfo()
        setupDateFormatter()
    }
    
    private func setupNavigationBar(){ // TODO: not need this in testing phase;
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        //let btn = UIBarButtonItem(title: "付款方式", style: .plain, target: self, action: #selector(paymentTypeBarButtonTapped))
        //self.navigationItem.rightBarButtonItem = btn
    }
    
    private func loadTransactionInfo(){
        
        // TODO: use ApiServers to load from user account, now use fake data:
        
        let a = TransactionDetail(date: Date().timeIntervalSince1970, type: .payment, value: 66.33)
        let b = TransactionDetail(date: Date().timeIntervalSince1970 + 36000, type: .payment, value: 233.33)
        let c = TransactionDetail(date: Date().timeIntervalSince1970 + 72000, type: .extract, value: 600.00)
        self.dataSource = [a,b,c]
    }
    
    private func setupDateFormatter(){
        dateFormatter.dateFormat = "MM-dd-yyyy"
    }
    
    func paymentTypeBarButtonTapped(){
        //let paymentPage = PaymentController()
        //self.navigationController?.pushViewController(paymentPage, animated: true)
    }
    
}


extension CreditViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CreditCell else {
            return UITableViewCell()
        }
        cell.dateFormatter = self.dateFormatter
        cell.transactionDetail = dataSource[indexPath.row]
        
        return cell
    }
    
}

extension CreditViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}



class CreditCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var transactionTypeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    var dateFormatter: DateFormatter?
    var transactionDetail: TransactionDetail? {
        didSet{
            setupTransactionInfo()
        }
    }
    
    private func setupTransactionInfo(){
        let getDate = Date(timeIntervalSince1970: transactionDetail?.date ?? Date().timeIntervalSince1970)
        self.dateLabel.text = dateFormatter?.string(from: getDate) ?? "No date"
        self.transactionTypeLabel.text = transactionDetail?.type.rawValue ?? "No type"
        let v = String(format: "%.2f", transactionDetail?.value ?? 0.0)
        self.valueLabel.text = transactionDetail?.type == .payment ? "-\(v)" : "+\(v)"
    }
    
}
