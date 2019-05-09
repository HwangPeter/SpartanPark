//
//  RideHistoryViewController.swift
//  autolayout
//
//  Created by Hun Zaw on 5/7/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import UIKit
import Firebase

class RideHistoryViewController2: UIViewController, UITableViewDelegate, UITableViewDataSource {

//    private let rideHistory = RideHistoryAPI.getRides()
//    var rideHistoryArray: [RideHistory] = [RideHistory]{
//        let rides = [
//            RideHistory(dateTime: "2:00"),
//            RideHistory(dateTime: "17:00"),
//            RideHistory(dateTime: "24:00")
//        ]
//        return rides
//    }
    
    var rideHistoryArray: [RideHistory] = [RideHistory]()
//    var tableView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupLayout()
        
//        configureTableView()
        retrieveRideHistory()
    }
    
    let menuContainerView: UIView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let backButton: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.backgroundColor = nil
        button.setImage(UIImage(named: "back-button3"), for: .normal)
        button.showsTouchWhenHighlighted = true
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nameTextView: UITextView = {
        
        let textView = UITextView(frame: CGRect.zero)
        textView.backgroundColor = nil
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor(red: 0/255.0, green: 85/255.0, blue: 162/255.0, alpha: 1)]
        
        let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor(red: 57/255.0, green: 57/255.0, blue: 57/255.0, alpha: 1)]
        
        //let attributedString1 = NSMutableAttributedString(string:"SPTN", attributes:attrs1)
        let attributedString1 = NSMutableAttributedString(string:"RIDE ", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:"HISTORY", attributes:attrs2)
        
        attributedString1.append(attributedString2)
        textView.attributedText = attributedString1
        
        return textView
    }()
    
    @objc func backButtonClicked(){
        print("Back Button Clicked")
        //present(ViewController(), animated: true, completion: nil)
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .white
        tv.delegate = self
        tv.dataSource = self
        tv.separatorColor = .white
        tv.translatesAutoresizingMaskIntoConstraints = false

        tv.register(CustomTableViewCell.self, forCellReuseIdentifier: "customRideHistory")
        //tv.register(CustomRideHistoryTableViewCell.self, forCellReuseIdentifier: "customRideHistory")

        //retrieveRideHistory()
        return tv
    }()
    
    
    
    private func setupLayout() {
        view.backgroundColor = .white
        //view.backgroundColor = .green
        
        view.addSubview(menuContainerView)
        view.addSubview(tableView)
        //view.bringSubviewToFront(menuContainerView)
        
        menuContainerView.addSubview(backButton)
        menuContainerView.addSubview(nameTextView)
        
        NSLayoutConstraint.activate([
            menuContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12)
            ])
        
        NSLayoutConstraint.activate([
            backButton.centerYAnchor.constraint(equalTo: menuContainerView.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: menuContainerView.leadingAnchor),
            backButton.widthAnchor.constraint(equalTo: menuContainerView.widthAnchor, multiplier: 0.2),
            backButton.heightAnchor.constraint(equalTo: menuContainerView.heightAnchor, multiplier: 0.7)
            ])
        
        NSLayoutConstraint.activate([
            nameTextView.centerYAnchor.constraint(equalTo: menuContainerView.centerYAnchor),
            nameTextView.centerXAnchor.constraint(equalTo: menuContainerView.centerXAnchor)
            ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: menuContainerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.88)
            ])

        if (view.frame.width == 320) {
            
            nameTextView.font = UIFont(name: "AvenirNext-Bold", size: 20)
            
        } else if (view.frame.width == 375) {
            
            nameTextView.font = UIFont(name: "AvenirNext-Bold", size: 25)
            
        } else if (view.frame.width == 414) {
            
            nameTextView.font = UIFont(name: "AvenirNext-Bold", size: 30)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
        return rideHistoryArray.count
        //return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customRideHistory", for: indexPath)
        //as! CustomTableViewCell
        
        //cell.ride = rideHistory[indexPath.row]
        
//        cell.profileImage.image = rideHistoryArray[indexPath.row].profileImage
//        cell.nameLabel.text = rideHistoryArray[indexPath.row].name
//        cell.dateTimeLabel.text = rideHistoryArray[indexPath.row].dateTime
        //cell.textLabel?.text =  rideHistoryArray[indexPath.row].dateTime
//        cell.avatarImageView.image = rideHistoryArray[indexPath.row].profileImage
        //cell.nameTextField.text = "John Doe"
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    
//    func configureTableView() {
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 200.0
//    }
//
    func retrieveRideHistory() {

        let databaseRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("Ride History")
        databaseRef.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! [String: String]

            //let matchedValetID = snapshotValue["matchedValetID"]!

            let currentTime = snapshotValue["currentTime"]!
            let matchedValetID = snapshotValue["matchedValetID"]!
            
            print("the current time is \(currentTime)")
            var rideHistory = RideHistory()
            rideHistory.dateTime = currentTime
            

        
//            let database = Database.database().reference().child("users").child(matchedValetID)
//            database.observeSingleEvent(of: .value, with: { (snapshot) in
//                let val = snapshot.value as! [String: String]
//
//                let name = val["name"]!
//
//                var rideHistory = RideHistory()
//                rideHistory.name = name
//
//                let storage = Storage.storage()
//                var reference: StorageReference!
//
//                //grab the image url from firebase
//                let profileUrl = val["profileImageUrl"]!
//                reference = storage.reference(forURL: profileUrl)
//
//                reference.downloadURL { (url, error) in
//                    let data = NSData(contentsOf: url!)
//                    let image = UIImage(data: data! as Data)
//                    rideHistory.profileImage = image
//                }
//
//                self.rideHistoryArray.append(rideHistory)
//            })
            
            let database = Database.database().reference().child("users").child(matchedValetID)
            database.observeSingleEvent(of: .value, with: { (snapshot) in
                //let val = snapshot.value
                //print(val)
            })
            self.rideHistoryArray.append(rideHistory)

            
//            self.configureTableView()
            self.tableView.reloadData()
        }
    }
}
