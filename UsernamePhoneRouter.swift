//
//  ResetPasswordRouter.swift
//  Veedup
//
//  Created by Zaruhi Davtyan on 07/28/20.
//  Copyright © 2020 VarmTech. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum UsernamePhoneSegue {
    case newPassword
    case showCountries
    case goBack
}

protocol UsernamePhoneRoutable: Routable where SegueType == UsernamePhoneSegue, SourceType == UsernamePhoneViewController {

}

class UsernamePhoneRouter: UsernamePhoneRoutable {
    func perform(_ segue: UsernamePhoneSegue, from source: UsernamePhoneViewController) {
        switch segue {
        case .goBack:
            if source.presentingViewController != nil {
                source.dismiss(animated: true, completion: nil)
            } else {
                source.navigationController?.popViewController(animated: false)
            }
        case .newPassword:
            if source.viewModel.isVerified {
                let vc = NewPasswordRouter.createNewPasswordViewController(auth: source.viewModel.auth)
                source.navigationController?.pushViewController(vc, animated: true)
            }
        default: break
        }
    }
    func perform(_ segue: UsernamePhoneSegue, from source: UsernamePhoneViewController, selectedCounty: BehaviorRelay<Country?>) {
        switch segue {
        case .showCountries:
            let vc = CountryTableRouter.createCountryTableViewController(selectedCounty)
            if #available(iOS 13.0, *) {
                vc.presentationController?.delegate = source
                source.isModalInPresentation = true
            }
            source.present(vc, animated: true, completion: nil)
        default: break
        }
    }
}

extension UsernamePhoneRouter {
    class func createResetPasswordViewController() -> UsernamePhoneViewController {
        let vc = UsernamePhoneViewController()
        vc.viewModel = UsernamePhoneViewModel()
        vc.router = UsernamePhoneRouter()
        return vc
    }
}
