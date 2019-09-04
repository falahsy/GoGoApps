//
//  JointEventVC.swift
//  cycle
//
//  Created by boy setiawan on 24/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit

class JoinEventVC: UIViewController{
    
    @IBOutlet weak var pin1TextField: UITextField!
    @IBOutlet weak var pin2TextField: UITextField!
    @IBOutlet weak var pin3TextField: UITextField!
    @IBOutlet weak var pin4TextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            submitButton.layer.cornerRadius = submitButton.frame.size.height/2
            submitButton.clipsToBounds = true
        }
    }
    
    @IBAction func submit(_ sender: UIButton) {
        guard let text1 = pin1TextField.text,
            let text2 = pin2TextField.text,
            let text3 = pin3TextField.text,
            let text4 = pin4TextField.text
            else { return }
        let code = "\(text1)\(text2)\(text3)\(text4)".trimmingCharacters(in: .whitespacesAndNewlines)
        
        let kegiatan = Activity()
        
        kegiatan.searchActivity(activityID: code) { (activities) in
            if activities.count > 0 {
                Preference.set(value: code, forKey: .kUserActivity)
                
                let userID = Preference.getString(forKey: .kUserEmail) ?? ""
                
                let activity = activities.first!
                let intervalDate = Double(activity.date)
                let eventDate = Date(timeIntervalSince1970: intervalDate)
                
                let event = Events()
                
                event.searchActivity(activityID: activity.activityID, callback: { (events) in
                    let result = events.allSatisfy {
                         $0.userID != userID
                    }
                    if result {
                        event.searchActivity(activityID: activity.activityID, callback: { (events) in
                            let firstEvent = events.first!
                            
                            let jointEvent = Events(id: firstEvent.activityID, user: userID, date: eventDate, distance: firstEvent.distance, eta: firstEvent.eta, destination: firstEvent.destination)
                            
                            jointEvent.insertData(callback: { (info) in
                                print(info)
                            })
                            
                        })
                        
                        let trackingVC = DetailEventVC()
                        trackingVC.activityId = activity.activityID
                        self.navigationController?.pushViewController(trackingVC, animated: true)
                    }else{
                        let alert = UIAlertController(title: "Event",message: "You're already registered to this event",preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
                
                
            } else {
                let alert = UIAlertController(title: "Event",message: "Event doesn't exist",preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFields()
    }
    
    private func setupFields() {
        pin1TextField.delegate = self
        pin2TextField.delegate = self
        pin3TextField.delegate = self
        pin4TextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = "Join Event"
        setupLargeTitle(prefLargeTitle: false)
    }
    
}

extension JoinEventVC: UITextFieldDelegate{
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
