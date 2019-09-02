//
//  LoadingVC.swift
//  cycle
//
//  Created by Azmi Muhammad on 28/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit
import CloudKit

class LoadingVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonOk: UIButton! {
        didSet {
            buttonOk.setupRadius(type: .custom(16.0))
            buttonOk.isHidden = true
        }
    }
    
    var activity: Activity!
    var hasError: Bool! = false {
        didSet {
            setupView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pushNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Loading"
    }
    
    private func pushNotification() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.letsGo(eventId: activity.activityID) { [weak self] (_ , error) in
            guard let self = self else { return }
            if let _ = error {
                self.hasError = true
            } else {
                self.createNewRecord()
            }
            
        }
    }
    
    private func setupView() {
        if !hasError {
            DispatchQueue.main.async {
                self.infoView("Happy Cycling", "Please open Gogo on your Apple Watch so you can know how far you are from friends while cycling and quikly send emergency alert.", image: "Watch")
            }
        } else {
            DispatchQueue.main.async {
                self.infoView("Hold On!", "There's something wrong with our system. Try again", image: "cycling-2")
            }
        }
    }
    
    private func infoView(_ title: String, _ info: String, image: String) {
        titleLabel.text = title
        infoLabel.text = info
        imageView.image = UIImage(named: image)
        buttonOk.isHidden = false
        buttonOk.setTitle(hasError ? "Back" : "OK", for: .normal)
    }
    
    private func createNewRecord() {
        print("User: \(activity.adminID)")
        print("Activity Id: \(activity.activityID)")
        
        let record: CKRecord = CKRecord(recordType: "letsGo")
        let myContainer: CKContainer = CKContainer.default()
        
        record["eventId"] = activity.activityID
        record["userId"] = activity.adminID
        record["message"] = "Lets Gowes"
        
        let publicDatabase = myContainer.publicCloudDatabase
        
        publicDatabase.save(record, completionHandler: { recordX, error in
            if let _ = error {
                self.hasError = true
                return
            } else {
                self.hasError = false
            }
        })
    }
    
    private func moveToTrackingVC() {
        let vc = TrackingVC()
        vc.activityID = activity.activityID
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onNextTapped(_ sender: UIButton) {
        if hasError {
            navigationController?.dismiss(animated: true, completion: nil)
        } else {
            moveToTrackingVC()
        }
        
    }
}
