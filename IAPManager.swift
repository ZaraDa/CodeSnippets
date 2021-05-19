//
//  IAPManager.swift
//  Traductor
//
//  Created by Zara Davtyan on 15.05.21.
//  Copyright © 2021 Traductor. All rights reserved.
//

import UIKit
import SwiftyStoreKit

class IAPManager {
    
    
    let monthlySbscrProductId = "143213"
    let yearlySbscrProductId = "345324"
    
    let sharedSecret = "635e3fb5e8064ee8991f928f52bbcc3d"
    
    var receipt: ReceiptInfo?
    
    static let shared = IAPManager()
    
    private init() {}
    
    
    func verifyReceiptForAnySubscription(success: @escaping (() -> Void), failure: @escaping (() -> Void)) {
        
        if let receipt = self.receipt {
            if verifyReceipt(receipt: receipt) {
                success()
            } else {
                failure()
            }
        } else {
            fetchReceipt {[weak self] receipt in
                guard let self = self else {return}
                if self.verifyReceipt(receipt: receipt) {
                    success()
                } else {
                    failure()
                }
            } failure: {
                failure()
            }

        }
    }
        
        func fetchReceipt(success: @escaping (ReceiptInfo) -> Void, failure: @escaping () -> Void) {
            let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
            
            SwiftyStoreKit.verifyReceipt(using: appleValidator) {[weak self] result in
                guard let self = self else {return}
                
                switch result {
                case .success(let receipt):
                    self.receipt = receipt
                    success(receipt)
                case .error(let error):
                    print("Receipt verification failed: \(error)")
                    failure()
                }
        }
            
          
}
    
    func purchaseForReciept( receipt: ReceiptInfo, productId: String) -> Bool {

        let purchaseResult = SwiftyStoreKit.verifySubscription(
            ofType: .autoRenewable,
            productId: productId,
            inReceipt: receipt)
            
        switch purchaseResult {
        case .purchased(let expiryDate, let items):
            print("\(productId) is valid until \(expiryDate)\n\(items)\n")
            if expiryDate > Date() {
                return true
            }
        case .expired(let expiryDate, let items):
            print("\(productId) is expired since \(expiryDate)\n\(items)\n")
            return false
        case .notPurchased:
            print("The user has never purchased \(productId)")
            return false
        }
        return false
    }
    
    func verifyReceipt(receipt: ReceiptInfo) -> Bool {
        if self.purchaseForReciept(receipt: receipt, productId: self.monthlySbscrProductId) == true {
            return true
        } else if self.purchaseForReciept(receipt: receipt, productId: self.yearlySbscrProductId) == true {
            return true
        } else {
            return false
        }
    }

}


extension IAPManager { // purchase
    
    func purchaseYearlySubsription(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        SwiftyStoreKit.purchaseProduct(yearlySbscrProductId, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                success()
            case .error(let error):
                failure(error)
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }
    }
    
    func purchaseMonthlySubsription(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        SwiftyStoreKit.purchaseProduct(monthlySbscrProductId, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                success()
            case .error(let error):
                failure(error)
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }
    }
}

extension IAPManager { //price
    
    func getPrices(completion: @escaping ([String : String]) -> Void) {
        
        SwiftyStoreKit.retrieveProductsInfo([self.monthlySbscrProductId, self.yearlySbscrProductId]) { result in
            var prices = [String : String]()
            for  product in result.retrievedProducts {
                prices[product.productIdentifier] = product.localizedPrice
                print("Product: \(product.localizedDescription), price: \(String(describing: product.localizedPrice))")
            }
            completion(prices)
        }
        
    }
}
