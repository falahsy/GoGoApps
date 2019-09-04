//
//  ViewController.swift
//  cycle
//
//  Created by boy setiawan on 12/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit
import MapKit

class LoginVC: UIViewController, UITextFieldDelegate{
    
    var isLogin : Bool?
  
    @IBOutlet weak var welcomeLbl: UILabel!{
        didSet{
            welcomeLbl.text = "Welcome Back"
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
            logRegBtn.backgroundColor = GoGoColor.MAIN
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
    var isUpside : Bool?
   
    @IBOutlet weak var createViewBottomCons: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if isLogin == true{
            print(isLogin!)
            loginViewDisplay()
        }else{
            print(isLogin!)
            registerViewDisplay()
        }
        navigationController?.isNavigationBarHidden = true
        isUpside = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        createViewBottomCons.constant = 363
        self.view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = GoGoColor.MAIN
        self.navigationController?.navigationBar.barTintColor = GoGoColor.MAIN
        let userID = Preference.getString(forKey: .kUserEmail) ?? ""
        self.textBoxUserID.text = userID
        textBoxUserID.addTarget(self, action: #selector(userTextFieldClicked), for: .touchDown)
        textBoxPassword.addTarget(self, action: #selector(passTextFieldClicked), for: .touchDown)
        logRegBtn.addTarget(self, action: #selector(loginRegister), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(loginViewDisplay), for: .touchUpInside)
        signUpBtn.addTarget(self, action: #selector(registerViewDisplay), for: .touchUpInside)
        registerHideKeyboard()
        textBoxUserID.delegate = self
        textBoxPassword.delegate = self
    }
    
    @objc override func dismissKeyboard() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.4) {
            self.createViewBottomCons.constant = 363
            self.view.layoutIfNeeded()
        }
        isUpside = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.4) {
            self.createViewBottomCons.constant = 363
            self.view.layoutIfNeeded()
        }
        isUpside = false
        return true
    }
    
    @objc func userTextFieldClicked(){
        self.createAccView.layoutIfNeeded()
        if isUpside == false{
            UIView.animate(withDuration: 0.4) {
                self.createViewBottomCons.constant = 62
                self.view.layoutIfNeeded()
            }
            isUpside = true
        }
    }
    
    @objc func passTextFieldClicked(){
        self.createAccView.layoutIfNeeded()
        if isUpside == false{
            createViewBottomCons.constant = 62
            UIView.animate(withDuration: 0.4) {
                self.createViewBottomCons.constant = 62
                self.view.layoutIfNeeded()
            }
            isUpside = true
        }
    }
    
    func loginFirstViewDisplay(){
        print(isLogin!)
        welcomeLbl.text = "Welcome Back"
        accountInfoLbl.text = "Login to your account"
        logRegBtn.setTitle("Login", for: .normal)
        forgotPassBtn.isHidden = false
        dontHaveAccLbl.isHidden = false
        alrdyHaveAccLbl.isHidden = true
        loginBtn.isHidden = true
        signUpBtn.isHidden = false
    }
    func registerFirstViewDisplay(){
        print(isLogin!)
        welcomeLbl.text = "Welcome"
        accountInfoLbl.text = "Create a new account"
        logRegBtn.setTitle("Register", for: .normal)
        forgotPassBtn.isHidden = true
        dontHaveAccLbl.isHidden = true
        alrdyHaveAccLbl.isHidden = false
        loginBtn.isHidden = false
        signUpBtn.isHidden = true
    }
    @objc func loginViewDisplay(){
        print(isLogin!)
        isLogin = true
        welcomeLbl.text = "Welcome Back"
        accountInfoLbl.text = "Login to your account"
        logRegBtn.setTitle("Login", for: .normal)
        forgotPassBtn.isHidden = false
        dontHaveAccLbl.isHidden = false
        alrdyHaveAccLbl.isHidden = true
        loginBtn.isHidden = true
        signUpBtn.isHidden = false
         textBoxPassword.text = ""
    }
    @objc func registerViewDisplay(){
        print(isLogin!)
        isLogin = false
        welcomeLbl.text = "Welcome"
        accountInfoLbl.text = "Create a new account"
        logRegBtn.setTitle("Register", for: .normal)
        forgotPassBtn.isHidden = true
        dontHaveAccLbl.isHidden = true
        alrdyHaveAccLbl.isHidden = false
        loginBtn.isHidden = false
        signUpBtn.isHidden = true
        textBoxPassword.text = ""
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
            Preference.set(value: self.textBoxUserID.text?.trimmingCharacters(in: .whitespacesAndNewlines), forKey: .kUserEmail)
            let homeVC = HomeVC()
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Name"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }

    @objc func loginRegister() {
        if isLogin!{
            Login.loginAccount(email: textBoxUserID.text!.trimmingCharacters(in: .whitespacesAndNewlines), password: textBoxPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)) { (info,result) in
                print(info)
                print(result)
                if result{
                    Preference.set(value: self.textBoxUserID.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: .kUserEmail)
                    Preference.set(value: true, forKey: .kUserLogin)
                    let homeVC = HomeVC()
                    self.navigationController?.pushViewController(homeVC, animated: true)
                }else{
                    let alert = UIAlertController(title: "Login",message: info,preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
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
        
    }
    
}
