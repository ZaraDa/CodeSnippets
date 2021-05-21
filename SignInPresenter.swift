//
//  SignInPresenter.swift
//  MyCircle
//
//  Created by Zara Davtyan on 5/18/20.
//  Copyright © 2020 cookiedev. All rights reserved.
//

import Foundation

protocol SignInView: class {
    func showPresenterError(_ error: INError)
    func startAnimation(isActive: Bool)
    func viewEndEditing(_ force: Bool)
    func signIn()
}

protocol SignInViewPresenter {
    init(view: SignInView)
    func validate()
}

class SignInPresenter: SignInViewPresenter {
    
    private let authService: AuthenticationService
    weak var view: SignInView?
    var email: String = ""
    var password: String = ""
    
    required init(view: SignInView) {
        self.view = view
        self.authService = AuthenticationService()
    }
    
    func validate() {
        let credential = LoginCredentials(email: self.email, password: self.password)
        authService.validateCredentials(credential) {[weak self] (error) in
            guard let self = self else {return}
            if let error = error {
                self.view?.showPresenterError(error)
            } else {
                self.view?.startAnimation(isActive: true)
                self.authService.login(with: credential) {[weak self] (result) in
                    guard let self = self else {return}
                    self.view?.startAnimation(isActive: false)
                    switch result {
                    case .failure(let error):
                        self.view?.showPresenterError(error)
                    case .success(let user):
                        UserDefault.user = user
                        self.view?.viewEndEditing(true)
                        self.view?.signIn()
                    }
                }
            }
        }
    }
}
