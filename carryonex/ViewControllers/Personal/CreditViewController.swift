//
//  CreditViewController.swift
//  carryonex
//
//  Created by Xin Zou on 12/1/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

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
        AnalyticsManager.shared.trackCount(.cashOutCount)
        AnalyticsManager.shared.startTimeTrackingKey(.cashOutTime)
    }
    
    var wallet: Wallet? {
        didSet {
            if let wallet = wallet {
                self.dataSource = wallet.incomes + wallet.payments
                self.creditValueLabel.text = wallet.availableCredit()
                self.tableView.reloadData()
            }
        }
    }
    
    var dataSource = [Transaction]()
    
    let cellId = "CreditCell"
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        ProfileManager.shared.updateWallet(completion: nil)
        
        NotificationCenter.default.addObserver(forName: .WalletDidUpdate, object: nil, queue: nil) { [weak self] _ in
            self?.wallet = ProfileManager.shared.wallet
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // TODO: for now, no completion func for extract cash, so use it here when the view appear again:
        AnalyticsManager.shared.finishTimeTrackingKey(.cashOutTime)
    }
    
    private func setupNavigationBar(){ // TODO: not need this in testing phase;
        title = L("personal.ui.title.wallet")
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
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
        cell.transaction = dataSource[indexPath.row]
        
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
    
    var transaction: Transaction? {
        didSet{
            setupTransactionInfo()
        }
    }
    
    private func setupTransactionInfo(){
        guard let transaction = transaction else { return }
        self.dateLabel.text = transaction.getTransactionDate()
        self.transactionTypeLabel.text = transaction.statusString()
        self.valueLabel.text = transaction.amountString()
    }
}
