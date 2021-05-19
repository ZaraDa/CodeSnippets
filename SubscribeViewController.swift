//
//  SubscribeViewController.swift
//  Traductor
//
//  Created by Zara Davtyan on 13.05.21.
//  Copyright © 2021 Traductor. All rights reserved.
//

import UIKit
import JGProgressHUD

class SubscribeViewController: UIViewController {

    
    @IBOutlet weak var refundPolicyButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var termsofUseButton: UIButton!
    @IBOutlet weak var subscriptionView: UIView!
    @IBOutlet weak var yearlyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var saveLabel: UILabel!
    @IBOutlet weak var tryFreeButton: UIButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var phrasebookLbl: UILabel!
    @IBOutlet weak var offlineModeLbl: UILabel!
    @IBOutlet weak var voiceConvLbl: UILabel!
    @IBOutlet weak var imageTrLbl: UILabel!
    
    var onPurchase: (() -> Void)?
    
    
    var monthlyPrice = "5 US$"
    var yearlyPrice = "45 US$"
    let savePrice = "20 US$"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        
        IAPManager.shared.getPrices {[weak self] result in
            hud.dismiss()
            if let yearlyPrice = result[IAPManager.shared.yearlySbscrProductId] {
                self?.yearlyPrice = yearlyPrice
            }
            
            if let monthlyPrice = result[IAPManager.shared.monthlySbscrProductId] {
                self?.monthlyPrice = monthlyPrice
            }
            DispatchQueue.main.async { [weak self] in
                self?.setPrices()
            }
            
        }
    }
    
    func setupUI() {
        setTexts()
        subscriptionView.layer.cornerRadius = 5
        tryFreeButton.layer.borderWidth = 1
        tryFreeButton.layer.cornerRadius = 5
        tryFreeButton.layer.borderColor = UIColor(red: 0.0, green: 0.52, blue: 1.0, alpha: 1.0).cgColor
    }
    
    func setTexts() {
        refundPolicyButton.setTitle(NSLocalizedString("refund", comment: ""), for: .normal)
        privacyPolicyButton.setTitle(NSLocalizedString("privacy", comment: ""), for: .normal)
        termsofUseButton.setTitle(NSLocalizedString("terms", comment: ""), for: .normal)
        yearlyLabel.text = NSLocalizedString("yearly", comment: "")
        let saveText = NSLocalizedString("save", comment: "")
        let saveFullText =  "(".appending(saveText).appending(" \(savePrice))")
        saveLabel.text = saveFullText
        tryFreeButton.setTitle(NSLocalizedString("try_free", comment: ""), for: .normal)
        phrasebookLbl.text = NSLocalizedString("phrasebook", comment: "")
        offlineModeLbl.text = NSLocalizedString("offline_mode", comment: "")
        voiceConvLbl.text = NSLocalizedString("voice_tr", comment: "")
        imageTrLbl.text = NSLocalizedString("image_tr", comment: "")
        //setPrices()
    }
    
    func setPrices() {
        priceLabel.text = "\(yearlyPrice)"
        var textDesc = NSLocalizedString("trial_desc_1", comment: "")
        textDesc = textDesc.appending("\(monthlyPrice)").appending(NSLocalizedString("trial_desc_2", comment: ""))
        descriptionLbl.text = textDesc
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func monthlyPurchaseAction(_ sender: Any) {
        IAPManager.shared.purchaseMonthlySubsription {[weak self] in
            self?.onPurchase?()
            self?.dismiss(animated: true, completion: nil)
        } failure: {[weak self] error in
            self?.showAlert(error: error)
        }
    }
    
    
    @IBAction func yearlyPurchaseAction(_ sender: Any) {
        IAPManager.shared.purchaseYearlySubsription {[weak self] in
            self?.onPurchase?()
            self?.dismiss(animated: true, completion: nil)
        } failure: {[weak self] error in
            self?.showAlert(error: error)
        }
    }
    
}
