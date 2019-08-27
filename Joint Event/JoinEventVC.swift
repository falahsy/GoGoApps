//
//  JointEventVC.swift
//  cycle
//
//  Created by boy setiawan on 24/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit

class JoinEventVC: UIViewController{
    
    @IBOutlet weak var firstCode: UITextField!
    @IBOutlet weak var secondCode: UITextField!
    @IBOutlet weak var thirdCode: UITextField!
    @IBOutlet weak var fourthCode: UITextField!
    
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            submitButton.layer.cornerRadius = submitButton.frame.size.height/2
            submitButton.clipsToBounds = true
            
        }
    }
    
    @IBAction func submit(_ sender: UIButton) {
        let code = "\(firstCode.text!)\(secondCode.text!)\(thirdCode.text!)\(fourthCode.text!)".trimmingCharacters(in: .whitespacesAndNewlines)
       
        if code.isEmpty {
            firstCode.becomeFirstResponder()
        } else {
            let kegiatan = Activity()

            kegiatan.searchActivity(activityID: code) { (activities) in
                
                if activities.count > 0{
                    let defaults = UserDefaults.standard
                    defaults.set(code, forKey: "activity")
                    
                    let trackingVC = TrackingVC()
                    self.navigationController?.pushViewController(trackingVC, animated: true)
                }else{
                    let alert = UIAlertController(title: "Event",message: "Event doesn't exist",preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstCode.delegate = self
        self.firstCode.keyboardType = .numberPad
        self.secondCode.delegate = self
        self.secondCode.keyboardType = .numberPad
        self.thirdCode.delegate = self
        self.thirdCode.keyboardType = .numberPad
        self.fourthCode.delegate = self
        self.fourthCode.keyboardType = .numberPad
    }
}

extension JoinEventVC: UITextFieldDelegate{
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        
        if ((textField.text?.count)! < 1  && string.count > 0){
            if(textField == firstCode)
            {
                secondCode.becomeFirstResponder()
            }
            if(textField == secondCode)
            {
                thirdCode.becomeFirstResponder()
            }
            if(textField == thirdCode)
            {
                fourthCode.becomeFirstResponder()
            }
            
            textField.text = string
            return false
        }
       
        
        return string.rangeOfCharacter(from: invalidCharacters) == nil
    }
}
