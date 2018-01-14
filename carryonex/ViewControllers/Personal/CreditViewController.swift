//
//  CreditViewController.swift
//  carryonex
//
//  Created by Xin Zou on 12/1/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class CreditViewController: UIViewController {
    
    @IBOutlet weak var titleBackgroundView: UIView!
    @IBOutlet weak var creditTitleLabel: UILabel!
    @IBOutlet weak var creditValueLabel: UILabel!
    @IBOutlet weak var currencyTypeLabel: UILabel!
    @IBOutlet weak var faqButton: UIButton!
    @IBOutlet weak var extractCashButton: UIButton!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func faqButtonTapped(_ sender: Any) {
        let webVC = WebController()
        self.navigationController?.pushViewController(webVC, animated: true)
        webVC.title = L("personal.ui.title.wallet-question")
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
                self.dataSource = (wallet.incomes + wallet.payments).sorted{$0.timestamp > $1.timestamp}
                self.creditValueLabel.text = wallet.totalIncome()
                self.tableView.reloadData()
            }
        }
    }
    
    var dataSource = [Transaction]()
    
    let cellId = "CreditCell"
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorColor = colorTableCellSeparatorLightGray
        setupNavigationBar()
        setupViewContents()

        ProfileManager.shared.updateWallet(completion: nil)
        
        NotificationCenter.default.addObserver(forName: .WalletDidUpdate, object: nil, queue: nil) { [weak self] _ in
            self?.wallet = ProfileManager.shared.wallet
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // TODO: for now, no completion func for extract cash, so use it here when the view appear again:
        setupGradientLayer()
        AnalyticsManager.shared.finishTimeTrackingKey(.cashOutTime)
    }
    
    private func setupNavigationBar(){
        title = L("personal.ui.title.wallet")
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.shadowImage = colorTableCellSeparatorLightGray.as1ptImage()
    }
    
    private func setupGradientLayer(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = titleBackgroundView.bounds
        let beginColor = #colorLiteral(red: 0.1764705882, green: 0.1921568627, blue: 0.4431372549, alpha: 1) // 45 49 113
        let endColor = #colorLiteral(red: 0.2745098039, green: 0.3764705882, blue: 0.6470588235, alpha: 1)  // 70 96 165
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.colors = [beginColor.cgColor, endColor.cgColor]
        titleBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupViewContents() {
        creditTitleLabel.text = L("personal.ui.title.credit")
        currencyTypeLabel.text = L("personal.ui.title.currency-type")
        faqButton.setTitle(L("personal.ui.title.faq"), for: .normal)
        extractCashButton.setTitle(L("personal.ui.title.cash"), for: .normal)
        detailTitleLabel.text = L("personal.ui.title.detail")
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
        cell.selectionStyle = .none
        cell.transaction = dataSource[indexPath.row]
        
        return cell
    }
    
}

extension CreditViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}


class CreditCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var transactionTypeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var transaction: Transaction? {
        didSet{
            setupTransactionInfo()
        }
    }
    
    private func setupTransactionInfo() {
        guard let transaction = transaction else { return }
        self.dateLabel.text = transaction.getTransactionDate()
        self.transactionTypeLabel.text = transaction.transactionTypeString()
        self.statusLabel.text = transaction.statusString()
        
        //Amount
        self.valueLabel.text = transaction.amountString()
        self.valueLabel.textColor = transaction.transactionTypeColor()
    }
}
