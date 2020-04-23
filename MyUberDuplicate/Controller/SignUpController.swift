//
//  SignUpController.swift
//  MyUberDuplicate
//
//  Created by Eric Grant on 22.04.2020.
//  Copyright © 2020 Eric Grant. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController {
    
    // MARK: - Properties
    
    private let tittleLabel: UILabel = {
           let label = UILabel()
           label.text = "UBER"
           label.font = UIFont(name: "Avenir-Light", size: 36)
           label.textColor = UIColor(white: 1, alpha: 0.8)
           return label
       }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var fullnameContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: fullnameTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var accountTypeContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_account_box_white_2x"),
                                               segmentedControl: accountTypeSegmentedControl)
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()
    
    private let emailTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Email",
                                       isSecureTextEntry: false)
    }()
    
    private let fullnameTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Fullname",
                                       isSecureTextEntry: false)
    }()
    
    private let passwordTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Password",
                                       isSecureTextEntry: true)
    }()
    
    private let accountTypeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Rider", "Driver"])
        sc.backgroundColor = .backgroundColor
        sc.tintColor = UIColor(white: 1, alpha: 0.87)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    private let signUpButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
           let button = UIButton(type: .system)
           let attributeTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSMutableAttributedString.Key.foregroundColor: UIColor.lightGray])
           
           attributeTitle.append(NSAttributedString(string: "Log In", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint]))
           
           button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
           
           button.setAttributedTitle(attributeTitle, for: .normal)
           
           return button
       }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        let accountTypeIndex = accountTypeSegmentedControl.selectedSegmentIndex
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Failed to register user with error \(error)")
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            let values = ["email": email,
                          "fullname": fullname,
                          "accountType": accountTypeIndex] as [String : Any]
            
            Database.database().reference().child("user").child(uid).updateChildValues(values) { (error, ref) in
                print("DEBUG: Successfully registered user and save data..")
            }
        }
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers Functions
    
    func configureUI() {
        
        view.backgroundColor = .backgroundColor
        
        view.addSubview(tittleLabel)
        tittleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        tittleLabel.centerX(inview: view)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   fullnameContainerView,
                                                   passwordContainerView,
                                                   accountTypeContainerView,
                                                   signUpButton])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: tittleLabel.bottomAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 40,
                     paddingLeft: 16,
                     paddingRight: 16)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inview: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                        height: 32)
    }
}
