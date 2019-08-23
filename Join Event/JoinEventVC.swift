//
//  JoinEventVC.swift
//  cycle
//
//  Created by Azmi Muhammad on 22/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit

class JoinEventVC: UIViewController {
    
    @IBOutlet weak var pinView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var pin1TextField: UITextField!
    @IBOutlet weak var pin2TextField: UITextField!
    @IBOutlet weak var pin3TextField: UITextField!
    @IBOutlet weak var pin4TextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Event Code"
    }
    
    private func setupUI() {
        setupView()
        setupFields()
        registerHideKeyboard()
    }
    
    private func setupView() {
        pinView.setupRadius(type: .custom(12))
        submitButton.setupRadius(type: .custom(12))
    }
    
    private func setupFields() {
        pin1TextField.delegate = self
        pin2TextField.delegate = self
        pin3TextField.delegate = self
        pin4TextField.delegate = self
    }
    
    
}

extension JoinEventVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        if text.count < 1 && string.count > 0 {
            if textField == pin1TextField {
                pin2TextField.becomeFirstResponder()
            } else if textField == pin2TextField {
                pin3TextField.becomeFirstResponder()
            } else if textField == pin3TextField {
                pin4TextField.becomeFirstResponder()
            } else if textField == pin4TextField {
                pin4TextField.resignFirstResponder()
            }
            
            textField.text = string
            return false
        } else if text.count >= 1 && string.count <= 0 {
            if textField == pin1TextField {
                pin1TextField.resignFirstResponder()
            } else if textField == pin2TextField {
                pin1TextField.becomeFirstResponder()
            } else if textField == pin3TextField {
                pin2TextField.becomeFirstResponder()
            } else if textField == pin4TextField {
                pin3TextField.becomeFirstResponder()
            }
            
            textField.text = ""
            return false
        } else if text.count >= 1 {
            textField.text = string
            return false
        }
        
        return true
    }
}
