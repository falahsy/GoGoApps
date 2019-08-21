//
//  LoginVC.swift
//  cycle
//
//  Created by Azmi Muhammad on 21/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit
import MapKit

class LoginVC: UIViewController {

    @IBOutlet weak var textBoxPassword: UITextField!
    @IBOutlet weak var textBoxUserID: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let userID = defaults.string(forKey: "email") ?? ""
        self.textBoxUserID.text = userID
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        
        Login.createAccount(email: textBoxUserID.text!.trimmingCharacters(in: .whitespacesAndNewlines), password: textBoxPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)) { (info,status) in
            if status{
                self.showInputDialog()
            } else {
                let alert = UIAlertController(title: "Welcome",message: info,preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    func showInputDialog() {
        let alertController = UIAlertController(title: "Enter Name", message: "Enter your name", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            
            let name = alertController.textFields?[0].text
            let user = User(id: self.textBoxUserID.text!.trimmingCharacters(in: .whitespacesAndNewlines), fullName: name ?? self.textBoxUserID.text!.trimmingCharacters(in: .whitespacesAndNewlines), activity: "", location: CLLocationCoordinate2D(latitude:0.0 , longitude: 0.0))
            user.insertData { (info) in
                print(info)
            }
            let defaults = UserDefaults.standard
            defaults.set(self.textBoxUserID.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "email")
            self.moveToMap()
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Name"
        }
        
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func login(_ sender: UIButton) {
        
        Login.loginAccount(email: textBoxUserID.text!.trimmingCharacters(in: .whitespacesAndNewlines), password: textBoxPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)) { (info,result) in
            
            if result {
                let defaults = UserDefaults.standard
                defaults.set(self.textBoxUserID.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "email")
                self.moveToMap()
            } else {
                let alert = UIAlertController(title: "Login",message: info,preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
            
            
        }
    }
    
    private func moveToMap() {
        let mapVC = MapVC()
        self.navigationController?.pushViewController(mapVC, animated: true)
    }

}
