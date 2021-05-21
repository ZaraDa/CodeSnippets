//
//  Subscribable.swift
//  Traductor
//
//  Created by Zara Davtyan on 17.05.21.
//  Copyright © 2021 Traductor. All rights reserved.
//

import UIKit
import JGProgressHUD



class TextTranslatorVC: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       fetchDataForSubscription()
    }
}

extension TextTranslatorVC : Subscribable {
    var subscribeViewTag: Int {
        1000
    }
    
    var languageView: LanguageSwitchView {
        self.languageSwitchView
    }
    
    var translatorView: TranslatorView {
        self.translatorInputView
    }
}

protocol Subscribable where Self: UIViewController {
    func fetchDataForSubscription()
    var subscribeViewTag: Int { get }
    var languageView: LanguageSwitchView { get}
    var translatorView: TranslatorView { get}

}

extension Subscribable {
    
    func fetchDataForSubscription() {
        //let hud = JGProgressHUD(style: .dark)
        //hud.show(in: self.view)
        IAPManager.shared.verifyReceiptForAnySubscription(success: {[weak self] in
            //hud.dismiss()
            self?.removeSubscribeView()
        }, failure: {[weak self] in
            //hud.dismiss()
            self?.addSubscribeView()
        })
    }
    
  private func addSubscribeView() {
        if self.view.viewWithTag(subscribeViewTag) != nil {
            return
        }
        
        if let view = Bundle.main.loadNibNamed("SubscribeView", owner: nil, options: nil)?.first as? SubscribeView {
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            view.topAnchor.constraint(equalTo: languageView.bottomAnchor).isActive = true
            view.tag = subscribeViewTag
            view.onSubscribe = {[weak self] in
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubscribeViewController") as? SubscribeViewController {
                    self?.present(vc, animated: true, completion: nil)
                    vc.onPurchase = { [weak self] in
                        self?.removeSubscribeView()
                    }
                }
            }
            updateTranslatorInputView(showSubscription: true)
        }
    }
    
   private func updateTranslatorInputView(showSubscription: Bool) {
        if showSubscription {
            translatorView.speakerButton.alpha = 0.3
            translatorView.languageLabel.alpha = 0.3
            translatorView.clearBtn.alpha = 0.3
        } else {
            translatorView.speakerButton.alpha = 1
            translatorView.languageLabel.alpha = 1
            translatorView.clearBtn.alpha = 1
        }
    }
    
   private func removeSubscribeView() {
        if let view = self.view.viewWithTag(subscribeViewTag) {
            view.removeFromSuperview()
        }
    }
}
