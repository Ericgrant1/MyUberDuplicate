//
//  LocationInputView.swift
//  MyUberDuplicate
//
//  Created by Eric Grant on 25.04.2020.
//  Copyright © 2020 Eric Grant. All rights reserved.
//

import UIKit

protocol LocationInputViewDelegate: class {
    func dismissLocationInputView()
}

class LocationInputView: UIView {

    // MARK: - Properties
    
    weak var delegate: LocationInputViewDelegate?
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp-1").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Eric Grant"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let startLocationIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let linkingView: UIView = {
           let view = UIView()
           view.backgroundColor = .darkGray
           return view
       }()
    
    private let destinationIndicatorView: UIView = {
           let view = UIView()
           view.backgroundColor = .black
           return view
       }()
    
    private lazy var startingLocationTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Current Location"
        tf.backgroundColor = .systemGroupedBackground
        tf.isEnabled = false
        tf.font = UIFont.systemFont(ofSize: 14)
        
        let paddingView = UIView()
        paddingView.setDimentions(height: 30, width: 8)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        return tf
    }()
    
    private lazy var destinationLocationTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter a destination.."
        tf.backgroundColor = .lightGray
        tf.returnKeyType = .search
        tf.font = UIFont.systemFont(ofSize: 14)
        
        let paddingView = UIView()
        paddingView.setDimentions(height: 30, width: 8)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        return tf
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addShadow()
        
        backgroundColor = .white
        
        addSubview(backButton)
        backButton.anchor(top: topAnchor,
                          left: leftAnchor,
                          paddingTop: 44,
                          paddingLeft: 12,
                          width: 24,
                          height: 24)
        
        addSubview(titleLabel)
        titleLabel.centerY(inview: backButton)
        titleLabel.centerX(inview: self)
        
        addSubview(startingLocationTextField)
        startingLocationTextField.anchor(top: backButton.bottomAnchor,
                                         left: leftAnchor,
                                         right: rightAnchor,
                                         paddingTop: 4,
                                         paddingLeft: 40,
                                         paddingRight: 40,
                                         height: 30)
        
        addSubview(destinationLocationTextField)
        destinationLocationTextField.anchor(top: startingLocationTextField.bottomAnchor,
                                            left: leftAnchor,
                                            right: rightAnchor,
                                            paddingTop: 12,
                                            paddingLeft: 40,
                                            paddingRight: 40,
                                            height: 30)
        
        addSubview(startLocationIndicatorView)
        startLocationIndicatorView.centerY(inview: startingLocationTextField,
                                           leftAnchor: leftAnchor,
                                           paddingLeft: 20)
        startLocationIndicatorView.setDimentions(height: 6, width: 6)
        startLocationIndicatorView.layer.cornerRadius = 6 / 2
        
        addSubview(destinationIndicatorView)
        destinationIndicatorView.centerY(inview: destinationLocationTextField,
                                         leftAnchor: leftAnchor,
                                         paddingLeft: 20)
        destinationIndicatorView.setDimentions(height: 6, width: 6)
        
        addSubview(linkingView)
        linkingView.centerX(inview: startLocationIndicatorView)
        linkingView.anchor(top: startLocationIndicatorView.bottomAnchor,
                           bottom: destinationIndicatorView.topAnchor,
                           paddingTop: 4,
                           paddingBottom: 4,
                           width: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleBackTapped() {
        delegate?.dismissLocationInputView()
    }
}
