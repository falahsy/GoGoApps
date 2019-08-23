//
//  ViewController.swift
//  cycle
//
//  Created by boy setiawan on 12/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit
import MapKit

class LoginVC: UIViewController {
    
    var isLogin = true
  
    @IBOutlet weak var welcomeLbl: UILabel!{
        didSet{
            welcomeLbl.text = "WelcomeBack"
        }
    }
    
    @IBOutlet weak var accountInfoLbl: UILabel!{
        didSet{
            accountInfoLbl.text = "Login to your account"
        }
    }
    @IBOutlet weak var logRegBtn: UIButton!{
        didSet{
            logRegBtn.layer.cornerRadius = logRegBtn.frame.size.height/2
            logRegBtn.clipsToBounds = true
            logRegBtn.setTitle("Login", for: .normal)
        }
    }
    @IBOutlet weak var createAccView: UIView!{
        didSet{
            createAccView.layer.cornerRadius = 15
            createAccView.clipsToBounds = true
        }
    }
    @IBOutlet weak var forgotPassBtn: UIButton!{
        didSet{
            forgotPassBtn.isHidden = false
        }
    }
    @IBOutlet weak var dontHaveAccLbl: UILabel!{
        didSet{
            dontHaveAccLbl.isHidden = false
        }
    }
    @IBOutlet weak var signUpBtn: UIButton!{
        didSet{
            signUpBtn.isHidden = false
        }
    }
    @IBOutlet weak var alrdyHaveAccLbl: UILabel!{
        didSet{
            alrdyHaveAccLbl.isHidden = true
        }
    }
    @IBOutlet weak var loginBtn: UIButton!{
        didSet{
            loginBtn.isHidden = true
        }
    }
    
    
    @IBOutlet weak var textBoxUserID: UITextField!
    @IBOutlet weak var textBoxPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = GoGoColor.MAIN
        let defaults = UserDefaults.standard
        let userID = defaults.string(forKey: "email")
        self.textBoxUserID.text = userID
        loginViewDisplay()
        if isLogin == true{
            logRegBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        }else{
            logRegBtn.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        }
        loginBtn.addTarget(self, action: #selector(loginViewDisplay), for: .touchUpInside)
        signUpBtn.addTarget(self, action: #selector(registerViewDisplay), for: .touchUpInside)
    }
    @objc func loginViewDisplay(){
        isLogin = true
        welcomeLbl.text = "Welcome Back"
        accountInfoLbl.text = "Login to your account"
        logRegBtn.setTitle("Login", for: .normal)
        forgotPassBtn.isHidden = false
        dontHaveAccLbl.isHidden = false
        alrdyHaveAccLbl.isHidden = true
        loginBtn.isHidden = true
        signUpBtn.isHidden = false
    }
    @objc func registerViewDisplay(){
        isLogin = false
        welcomeLbl.text = "Welcome"
        accountInfoLbl.text = "Create a new account"
        logRegBtn.setTitle("Register", for: .normal)
        forgotPassBtn.isHidden = true
        dontHaveAccLbl.isHidden = true
        alrdyHaveAccLbl.isHidden = false
        loginBtn.isHidden = false
        signUpBtn.isHidden = true
    }
    
    @objc func signIn() {
        
        Login.createAccount(email: textBoxUserID.text!.trimmingCharacters(in: .whitespacesAndNewlines), password: textBoxPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)) { (info,status) in
            
            
            if status{
                self.showInputDialog()
                
            }else{
                
                let alert = UIAlertController(title: "Welcome",message: info,preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    func showInputDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Enter Name", message: "Enter your name", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            
            //getting the input values from user
            let name = alertController.textFields?[0].text
            let user = User(id: self.textBoxUserID.text!.trimmingCharacters(in: .whitespacesAndNewlines), fullName: name ?? self.textBoxUserID.text!.trimmingCharacters(in: .whitespacesAndNewlines), activity: "", location: CLLocationCoordinate2D(latitude:0.0 , longitude: 0.0))
            user.insertData { (info) in
                print(info)
            }
            let defaults = UserDefaults.standard
            defaults.set(self.textBoxUserID.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "email")
            self.performSegue(withIdentifier: "showMap", sender: nil )
        }
        
        //        //the cancel action doing nothing
        //        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
        //
        //
        //        }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Name"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        //alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    @objc func login() {
        
        Login.loginAccount(email: textBoxUserID.text!.trimmingCharacters(in: .whitespacesAndNewlines), password: textBoxPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)) { (info,result) in
            
            if result{
                let defaults = UserDefaults.standard
                defaults.set(self.textBoxUserID.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "email")
                //let homeVC = HomeVC()
                let homeVC = CreateEventVC()
                self.navigationController?.pushViewController(homeVC, animated: true)
            }else{
                let alert = UIAlertController(title: "Login",message: info,preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
            
            
        }
    }
    
}
