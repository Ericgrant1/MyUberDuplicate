//
//  LoginController.swift
//  MyUberDuplicate
//
//  Created by Eric Grant on 21.04.2020.
//  Copyright © 2020 Eric Grant. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    // MARK: - Properties
    
    private let tittleLabel: UILabel = {
        let label = UILabel()
        label.text = "UBER"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
        
        view.addSubview(tittleLabel)
        tittleLabel.translatesAutoresizingMaskIntoConstraints = false
        tittleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tittleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                         constant: 0).isActive = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
