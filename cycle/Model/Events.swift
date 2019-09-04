//
//  Events.swift
//  cycle
//
//  Created by boy setiawan on 28/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import Foundation
import MapKit
import Firebase

struct Events {
    
    private static var dbRef: DatabaseReference = Database.database().reference()
    var activityID:String
    var userID:String
    var date:Int
    var distance:Double
    var eta:Int
    var destination:String
    let ref: DatabaseReference?
    private var key: String
    
    init(id: String, user: String, key: String = "",date:Date,distance:Double, eta:Int, destination:String) {
        self.activityID = id
        self.ref = nil
        self.key = key
        self.userID = user
        self.distance = distance
        self.eta = eta
        self.destination = destination
        // convert Date to TimeInterval (typealias for Double)
        let timeInterval = date.timeIntervalSince1970
        
        // convert to Integer
        let convertedDate = Int(timeInterval)
        self.date = convertedDate
        
    }
    
    init(){
        self.activityID = ""
        self.ref = nil
        self.key = ""
        self.userID = ""
        self.distance = 0.0
        self.eta = 0
        self.destination = ""
        // convert Date to TimeInterval (typealias for Double)
        let date = Date()
        let timeInterval = date.timeIntervalSince1970
        
        // convert to Integer
        let convertedDate = Int(timeInterval)
        self.date = convertedDate
    }
    
    init?(snapshot: DataSnapshot) {
        
        
        guard
            let value = snapshot.value as? [String: AnyObject],
            let activityID = value["activityID"] as? String,
            let user = value["userID"] as? String,
            let date = value["date"] as? Int,
            let distance = value["distance"] as? Double,
            let eta = value["eta"] as? Int,
            let destination = value["destination"] as? String
            else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.activityID = activityID
        self.userID = user
        self.date = date
        self.distance = distance
        self.eta = eta
        self.destination = destination
        
    }
    
    func toAnyObject() -> Any {
        
        return [
            "activityID": activityID,
            "userID": userID,
            "date": date,
            "distance": distance,
            "eta": eta,
            "destination": destination
            
        ]
    }
    
    func insertData(callback: @escaping (String) -> Void) {
        
        Events.dbRef.child("events").childByAutoId().setValue(self.toAnyObject()) { (error, databaseReference) in
            
            if error == nil{
                callback("Operation Successful")
            }else{
                callback(error.debugDescription)
            }
            
        }
    }
    
    func deleteData(callback: (String) -> Void) {
        
        if ref != nil{
            ref?.removeValue()
            callback("Delete Successful")
            
        }else{
            callback("Delete Failed")
            
        }
        
    }
    
    func searchActivity(activityID:String, callback: @escaping ([Events]) -> Void){
        
        
        Events.dbRef.child("events").queryOrdered(byChild:  "activityID").queryStarting(atValue: activityID).queryEnding(atValue: activityID + "\u{f8ff}").observeSingleEvent(of: .value, with: { (snapshot) in
            
            var eventsList:[Events] = []
            for item in snapshot.children{
                let event = item as! DataSnapshot
                
                guard let cyclistEvents = Events(snapshot: event) else {return}
                eventsList.append(cyclistEvents)
            }
            
            callback(eventsList)
            
            
        })
        
    }
    
    func searchUser(userID:String, callback: @escaping ([Events]) -> Void){
        Events.dbRef.child("events").queryOrdered(byChild:  "userID").queryStarting(atValue: userID).queryEnding(atValue: userID + "\u{f8ff}").observeSingleEvent(of: .value, with: { (snapshot) in
            var eventsList:[Events] = []
            for item in snapshot.children{
                let event = item as! DataSnapshot
                guard let cyclistEvents = Events(snapshot: event) else {return}
                eventsList.append(cyclistEvents)
            }
            callback(eventsList)
        })
        
    }
}




