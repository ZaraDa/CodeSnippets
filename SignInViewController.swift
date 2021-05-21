//
//  SignInViewController.swift
//  MyCircle
//
//  Created by Zara Davtyan on 5/18/20.
//  Copyright © 2020 cookiedev. All rights reserved.
//

import UIKit


class SignInViewController: ViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailField: TextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordField: TextField!
    @IBOutlet weak var signInButton: Button!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var noAccountLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    var presenter: SignInPresenter!
    weak var delegate: AuthWireframe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        setupTapGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailField.becomeFirstResponder()
    }
    
    func configureViews() {
        titleLabel.text = Verification.signInHello.localized
        titleLabel.textColor = .primaryPurple
        forgotPasswordButton.setTitle(Verification.forgotPassword.localized, for: .normal)
        emailField.viewConfig = .authorizationConfig
        emailField.viewConfig.placeholder = Verification.companyEmail.localized
        emailField.viewConfig.textContentType = .emailAddress
        emailField.viewConfig.keyboardType = .emailAddress
        emailField.viewConfig.returnKeyType = .next
        emailField.viewConfig.primaryTriggerTap = {[weak self] _ in
            self?.passwordField.becomeFirstResponder()
        }
        emailView.layer.borderColor = UIColor.borderEmptyGray.cgColor
        emailView.layer.borderWidth = 1.0
        emailView.layer.cornerRadius = 4.0
        emailField.viewConfig.onTextDidChange = {[weak self] textField in
            let text = textField.text ?? ""
            self?.emailView.layer.borderColor = text.count > 0 ? UIColor.borderGray.cgColor : UIColor.borderEmptyGray.cgColor
            self?.presenter.email = text
        }
        passwordField.viewConfig = .passwordConfig
        passwordField.viewConfig.placeholder = Verification.password.localized
        passwordField.viewConfig.returnKeyType = .go
        passwordField.viewConfig.primaryTriggerTap = { [weak self] _ in
            self?.presenter.validate()
        }
        passwordView.layer.borderColor = UIColor.borderEmptyGray.cgColor
        passwordView.layer.borderWidth = 1.0
        passwordView.layer.cornerRadius = 4.0
        passwordField.viewConfig.onTextDidChange = {[weak self] textField in
            let text = textField.text ?? ""
            self?.passwordView.layer.borderColor = text.count > 0 ? UIColor.borderGray.cgColor : UIColor.borderEmptyGray.cgColor
            self?.presenter.password = text
        }
        noAccountLabel.text = Title.dontHaveAnAccount.localized
        noAccountLabel.textColor = .primaryGray
        signInButton.viewConfig.textColor = .primaryBlack
        signInButton.viewConfig.text = Title.login.localized
        signUpButton.setTitleColor(.primaryPurple, for: .normal)
        signUpButton.setTitle(Title.signUp.localized, for: .normal)
    }
    
    
    @IBAction func signInAction(_ sender: Button) {
        presenter.validate()
    }
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        viewEndEditing(true)
        delegate?.flow(.forgotPass, from: self)
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        viewEndEditing(true)
        delegate?.flow(.signUp, from: self)
    }
    
    override func keyboardWillShow(_ notification: Notification) {
        super.keyboardWillShow(notification)
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            scrollView.contentInset = UIEdgeInsets(top: scrollView.contentInset.top, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        super.keyboardWillHide(notification)
        scrollView.contentInset = UIEdgeInsets(top: scrollView.contentInset.top, left: 0, bottom: 0, right: 0)
    }
}

extension SignInViewController: SignInView {
    func showPresenterError(_ error: INError) {
        handle(error: error)
    }
    
    func startAnimation(isActive: Bool) {
        isActive ? signInButton.startAnimation() : signInButton.stopAnimation()
    }
    
    func signIn() {
        delegate?.flow(.registered, from: self)
    }
}

extension SignInViewController: StoryboardInstance {
    static var storyboardName: StoryboardName = .signIn
}
