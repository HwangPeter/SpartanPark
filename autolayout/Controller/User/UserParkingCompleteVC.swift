//
//  ParkingCompleteVC.swift
//  autolayout
//
//  Created by Peter Hwang on 5/6/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import Stripe

class UserParkingCompleteVC: UIViewController {
    
    var carLocation = ""
    var parentVC:UserMapVC?
    
    let nameTextView: UITextView = {
        
        let myText = UITextView(frame: CGRect.zero, textContainer: nil)
        myText.text = "SPARTAN PARK"
        myText.backgroundColor = nil
        myText.textColor = UIColor.white
        myText.font = UIFont(name: "AvenirNext-heavy", size: 30)
        //myText.textColor = UIColor(red: 229/255.0, green: 168/255.0, blue: 35/255.0, alpha: 1)
        myText.textAlignment = .center
        myText.isEditable = false
        myText.isScrollEnabled = false
        
        myText.layer.shadowOpacity = 0.4
        myText.layer.shadowColor = UIColor.darkGray.cgColor
        myText.layer.shadowOffset = CGSize(width: 0, height: 5)
        myText.layer.shadowRadius = 6.0
        
        myText.translatesAutoresizingMaskIntoConstraints = false
        return myText
        
    }()
    
    let statusTextView: UITextView = {
        
        let myText = UITextView(frame: CGRect.zero, textContainer: nil)
        myText.text = "Parking Complete!\n Your car is located at:\n"
        myText.backgroundColor = nil
        myText.textColor = UIColor.white
        myText.font = UIFont.systemFont(ofSize: 26)
        //myText.textColor = UIColor(red: 229/255.0, green: 168/255.0, blue: 35/255.0, alpha: 1)
        myText.textAlignment = .center
        myText.isEditable = false
        myText.isScrollEnabled = false
        
        myText.translatesAutoresizingMaskIntoConstraints = false
        return myText
    }()
    
    let carLocationTextView: UITextView = {
        
        let myText = UITextView(frame: CGRect.zero, textContainer: nil)
        myText.text = ""
        myText.backgroundColor = nil
        myText.textColor = UIColor.white
        myText.font = UIFont.boldSystemFont(ofSize: 26)
        //myText.textColor = UIColor(red: 229/255.0, green: 168/255.0, blue: 35/255.0, alpha: 1)
        myText.textAlignment = .center
        myText.isEditable = false
        myText.isScrollEnabled = false
        
        myText.translatesAutoresizingMaskIntoConstraints = false
        return myText
    }()
    
    let gotItButton: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.backgroundColor = .white
        button.setTitle("OKAY GOT IT", for: .normal)
        button.setTitleColor(UIColor(red: 57/255.0, green: 57/255.0, blue: 57/255.0, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(gotItPressed), for: .touchUpInside)
        
        button.layer.cornerRadius = 5.0
        button.layer.shadowOpacity = 0.4
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 6.0
        button.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 25)
        
        button.showsTouchWhenHighlighted = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCarLocation() {
            self.displayCarLocation()
        }
        setupLayout()
        
    }
    
    private func setupLayout() {
        view.backgroundColor = UIColor(red: 39/225.0, green: 74/225.0, blue: 110/225.0, alpha: 1)
        
        view.addSubview(nameTextView)
        view.addSubview(statusTextView)
        view.addSubview(carLocationTextView)
        view.addSubview(gotItButton)
        
        NSLayoutConstraint.activate([
            nameTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nameTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nameTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            
            statusTextView.topAnchor.constraint(equalTo: nameTextView.bottomAnchor),
            statusTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            carLocationTextView.topAnchor.constraint(equalTo: statusTextView.bottomAnchor),
            carLocationTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            gotItButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            gotItButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gotItButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            gotItButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07)
            ])
    }
    
    private func getCarLocation(finished: @escaping () -> Void) {
        Database.database().reference().child("ongoingRequests").child(Auth.auth().currentUser!.uid).child("parkingLot").observeSingleEvent(of: .value) { (snapshot) in
            
            self.carLocation = snapshot.value as? String ?? ""
            finished()
        }
    }
    
    private func displayCarLocation() {
        self.carLocationTextView.text = self.carLocation
    }
    
    @objc func gotItPressed() {
        let uid = Auth.auth().currentUser?.uid
        
        let requestRef = Database.database().reference().child("ongoingRequests").child(uid!)
        requestRef.observeSingleEvent(of: .value) { (snapshot) in
            let snapshotValue = snapshot.value as! [String :String]
            
            let currentTime = snapshotValue["currentTime"]!
            let valetName = snapshotValue["valetName"]!
            let carInfo = snapshotValue["carInfo"]!
            let valetProfileImageUrl = snapshotValue["valetProfileImageUrl"]!
            let database = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("Ride History")
            database.childByAutoId().setValue(["currentTime": currentTime, "valetName": valetName, "valetProfileImageUrl": valetProfileImageUrl, "carInfo": carInfo])
//            database.updateChildValues(["currentTime": currentTime, "matchedValetID": matchedValetID])
        }
        
        let mapVC = parentVC
        mapVC?.currentVC = mapVC
        
        
        
        dismiss(animated: true, completion: {requestRef.updateChildValues(["status": "finished"])})
    }
    
    
    
    // Do any additional setup after loading the view.
}
