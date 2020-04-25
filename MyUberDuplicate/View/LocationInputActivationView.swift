//
//  LocationInputActivationView.swift
//  MyUberDuplicate
//
//  Created by Eric Grant on 25.04.2020.
//  Copyright © 2020 Eric Grant. All rights reserved.
//

import UIKit

protocol LocationInputActivationViewDelegate: class {
    func presentLocationInputView()
}

class LocationInputActivationView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: LocationInputActivationViewDelegate?
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Where to?"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.45
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.masksToBounds = false
        
        addSubview(indicatorView)
        indicatorView.centerY(inview: self,
                              leftAnchor: leftAnchor,
                              paddingLeft: 16)
        indicatorView.setDimentions(height: 6, width: 6)
        
        addSubview(placeholderLabel)
        placeholderLabel.centerY(inview: self,
                                 leftAnchor: indicatorView.rightAnchor,
                                 paddingLeft: 20)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(presentShowLocationInputView))
        addGestureRecognizer(tap)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func presentShowLocationInputView() {
        delegate?.presentLocationInputView()
    }
}
