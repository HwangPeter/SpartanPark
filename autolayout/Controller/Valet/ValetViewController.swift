//
//  UserSignUpViewController.swift
//  autolayout
//
//  Created by Hun Zaw on 3/19/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class ValetViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var rootVC = self
    
    let locationManager = CLLocationManager()
    let lots = LotLocationList().lot
    
    lazy var matchingView: ValetRequestedViewController = {
        let animation = ValetRequestedViewController()
        animation.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        return animation
    }()
    
    let menuContainerView: UIView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let userInfoContainerView: UIView = {
        
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.white
        
        view.layer.cornerRadius = 5.0
        view.layer.shadowOpacity = 0.4
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 9.0
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let hamburgerButton: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.backgroundColor = nil
        button.setImage(UIImage(named: "menuSliderBtn"), for: .normal)
        button.showsTouchWhenHighlighted = true
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(hamburgClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var hamburgerMenu: HamburgerMenu = {
        let menu = HamburgerMenu()
        menu.currentValetVC = self
        return menu
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
        let attributedString1 = NSMutableAttributedString(string:"SPARTAN", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:"PARK", attributes:attrs2)
        
        attributedString1.append(attributedString2)
        textView.attributedText = attributedString1
        
        return textView
    }()
    
    var profileImage: UIImageView = {
        
        let profile = UIImage(named: "noProfilePhoto")
        let profileView = UIImageView(image: profile)
        profileView.contentMode = .scaleAspectFit
        profileView.layer.cornerRadius = 19
        profileView.clipsToBounds = true
        
        profileView.translatesAutoresizingMaskIntoConstraints = false //enable autolayout for our image
        return profileView
    }()
    
    let centerMapButton: UIButton = {

        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.backgroundColor = nil
        button.setImage(UIImage(named: "centerMapBtn"), for: .normal)
        button.showsTouchWhenHighlighted = true
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(centerMapClicked), for: .touchUpInside)
        return button
    }()
    
    @objc func centerMapClicked(){
        let regionRadius: CLLocationDistance = 500
        let coordinateRegion = MKCoordinateRegion(center: CLLocation(
            latitude: 37.3352, longitude: -121.8811).coordinate,
                                                  latitudinalMeters: regionRadius * 2.0,
                                                  longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    let statusLabel: UILabel = {
        
        let label = UILabel(frame: CGRect.zero)
        label.backgroundColor = .white
        label.text = "You are offline."
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let goOnlineButton: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.backgroundColor = .white
        button.setTitle("GO ONLINE", for: .normal)
        button.setTitleColor(UIColor(red: 57/255.0, green: 57/255.0, blue: 57/255.0, alpha: 1), for: .normal)
        
        button.layer.cornerRadius = 5.0
        button.layer.shadowOpacity = 0.4
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 6.0
        
        button.showsTouchWhenHighlighted = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.isHidden = false
        
        button.addTarget(self, action: #selector(goOnlineClicked), for: .touchUpInside)
        return button
    }()
    
    let goOfflineButton: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.backgroundColor = .white
        button.setTitle("GO OFFLINE", for: .normal)
        button.setTitleColor(UIColor(red: 57/255.0, green: 57/255.0, blue: 57/255.0, alpha: 1), for: .normal)
        
        button.layer.cornerRadius = 5.0
        button.layer.shadowOpacity = 0.4
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 6.0
        
        button.showsTouchWhenHighlighted = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.isHidden = true
        
        button.addTarget(self, action: #selector(goOfflineClicked), for: .touchUpInside)
        return button
    }()
    
    let mapView: MKMapView = {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let maps = MKMapView(frame: CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height))
        maps.translatesAutoresizingMaskIntoConstraints = false
        return maps
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupLayout()
        fetchLicenseInfo()

        fetchSSNInfo()
        initializeMapView()
        fetchProfilePhoto()
        self.hideKeyboardWhenTappedAround() 
        
        getUserStatus() {
            self.handleUserStatus()
        }
        
//        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        getUserStatus() {
//            self.handleUserStatus()
//        }
        statusLabel.text = "You are offline."
        if (self.statusLabel.text == "You are online... accepting requests") {

            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                // Code you want to be delayed
                //self.dismiss(animated: true, completion: nil)
                self.checkForStatus();
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ValetRequestedViewController {
            
            destinationVC.prevVC = self
            
        }
    }
    
    var userStatus = ""
    var parkInPNR = ""
    var readyToValet = ""
    
    func getUserStatus(finished: @escaping () -> Void) {
        
        let databaseRef = Database.database().reference().child("ongoingRequests");
        databaseRef.observeSingleEvent(of: .value) { (DataSnapshot) in
            let key = DataSnapshot.children
            
            for case let rest as DataSnapshot in key {
                let snapshotValue = rest.value as! [String: String];
                
                let matchedValetID = snapshotValue["matchedValetID"]!;
                if matchedValetID == Auth.auth().currentUser!.uid {
                    self.userStatus = snapshotValue["status"]!
                    self.parkInPNR = snapshotValue["parkInPNR"]!
                    print("user status is: \(self.userStatus)")
                    finished()
                }
                
            }
        }
    }
    
    func handleUserStatus() {
        
        print("Inside Handle User Status")
        switch self.userStatus {
            case "requesting":
                print("Presenting Valet Requested")
                self.present(ValetRequestedViewController(), animated: true, completion: nil)
                break

            case "requestAccepted":
                self.present(ValetDirectionToUserViewController(), animated: true, completion: nil)
                break
            
            case "parkingInProgress":
                if(parkInPNR == "false"){
                    self.present(ValetDirectionToGarageViewController(), animated: true, completion: nil)
                    break
                }
                else if(parkInPNR == "true"){
                    self.present(ValetDirectionToPNRViewController(), animated: true, completion: nil)
                    break
                }
            
            case "DroppingOffKey":
                self.present(ValetDirectionToSCEViewController(), animated: true, completion: nil)
                break

            default:
                break
        }
    }
    
    func fetchLicenseInfo() {
        if Auth.auth().currentUser != nil && Auth.auth().currentUser!.isEmailVerified  {
            
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).child("License").observeSingleEvent(of: .value, with: { (snapshot) in
                
                //user model has name, email, and profileImageUrl, etc stored in database
                //fetch anything stored in the database in this if statement
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    //grab the stats from firebase
                    let licenseDOB = dictionary["licenseDOB"] as? String
                    let licenseExpiration = dictionary["licenseExpiration"] as? String
                    let licenseName = dictionary["licenseName"] as? String
                    let licenseNumber = dictionary["licenseNumber"] as? String
                    
                    if(licenseDOB != "" && licenseExpiration != "" && licenseName != "" && licenseNumber != ""){
                        self.readyToValet = "true"
                    }
                    else{
                        self.readyToValet = "false"
                    }
                    print(licenseNumber!)
                    print(licenseName!)
                    print(licenseExpiration!)
                    print(licenseDOB!)
                    print("HELOO!\(self.readyToValet)")
                    
                }
                
            }, withCancel: nil)
            
        }
    }
    
    func fetchSSNInfo() {
        
        print("HELOO2!!!!!)")
        if Auth.auth().currentUser != nil && Auth.auth().currentUser!.isEmailVerified  {
            
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).child("SSN").observeSingleEvent(of: .value, with: { (snapshot) in
                
                //user model has name, email, and profileImageUrl, etc stored in database
                //fetch anything stored in the database in this if statement
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    //grab the stats from firebase
                    let SSN = dictionary["SSN"] as? String
                    
                    if(SSN != ""){
                        self.readyToValet = "true"
                    }
                    else{
                        self.readyToValet = "false"
                    }
                    
                    print("printing SSN \(SSN ?? "0")")
                    print("HELOO2!\(self.readyToValet)")
                }
                
            }, withCancel: nil)
            
        }
    }
    
    private func setupLayout() {
        
        view.backgroundColor = .white
        
        view.addSubview(menuContainerView)
        view.addSubview(mapView)
        view.addSubview(centerMapButton)
        view.addSubview(goOnlineButton)
        view.addSubview(goOfflineButton)
        
        view.addSubview(userInfoContainerView)
        view.bringSubviewToFront(menuContainerView)
        view.bringSubviewToFront(userInfoContainerView)
        userInfoContainerView.addSubview(statusLabel)
        
        menuContainerView.addSubview(hamburgerButton)
        menuContainerView.addSubview(nameTextView)
        menuContainerView.addSubview(profileImage)
        
        NSLayoutConstraint.activate([
            menuContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12)
            ])
        
        NSLayoutConstraint.activate([
            userInfoContainerView.topAnchor.constraint(equalTo: menuContainerView.bottomAnchor, constant: -17),
            userInfoContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userInfoContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            userInfoContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.065)
            ])
        
        NSLayoutConstraint.activate([
            hamburgerButton.centerYAnchor.constraint(equalTo: menuContainerView.centerYAnchor),
            hamburgerButton.leadingAnchor.constraint(equalTo: menuContainerView.leadingAnchor),
            hamburgerButton.widthAnchor.constraint(equalTo: menuContainerView.widthAnchor, multiplier: 0.2),
            hamburgerButton.heightAnchor.constraint(equalTo: menuContainerView.heightAnchor, multiplier: 0.7)
            ])
        
        NSLayoutConstraint.activate([
            nameTextView.centerYAnchor.constraint(equalTo: menuContainerView.centerYAnchor),
            nameTextView.centerXAnchor.constraint(equalTo: menuContainerView.centerXAnchor)
            ])
        
        NSLayoutConstraint.activate([
            profileImage.trailingAnchor.constraint(equalTo: menuContainerView.trailingAnchor, constant: -20),
            profileImage.centerYAnchor.constraint(equalTo: menuContainerView.centerYAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 38),
            profileImage.heightAnchor.constraint(equalToConstant: 38)
            ])
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: menuContainerView.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.95)
            ])
        
        NSLayoutConstraint.activate([
            statusLabel.centerYAnchor.constraint(equalTo: userInfoContainerView.centerYAnchor),
            statusLabel.centerXAnchor.constraint(equalTo: userInfoContainerView.centerXAnchor),
            ])
        
        NSLayoutConstraint.activate([
            goOnlineButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            goOnlineButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goOnlineButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            goOnlineButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07)
            ])
        
        NSLayoutConstraint.activate([
            goOfflineButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            goOfflineButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goOfflineButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            goOfflineButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07)
            ])
        
        NSLayoutConstraint.activate([
            centerMapButton.bottomAnchor.constraint(equalTo: goOnlineButton.topAnchor, constant: -15),
            centerMapButton.trailingAnchor.constraint(equalTo: goOnlineButton.trailingAnchor, constant: -10),
            centerMapButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15),
            centerMapButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09)
            ])
        
        // iphone 5s,SE screen width 320
        // iphone 6,6s,7,etc width 375
        // iphone 7 plus, 8 plus, xs max,etc width 414
        
        if (view.frame.width == 320) {
            
            nameTextView.font = UIFont(name: "AvenirNext-Bold", size: 20)
            goOnlineButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 20)
            goOfflineButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 20)
            
        } else if (view.frame.width == 375) {
            
            nameTextView.font = UIFont(name: "AvenirNext-Bold", size: 25)
            goOnlineButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 25)
            goOfflineButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 25)
            
        } else if (view.frame.width == 414) {
            
            nameTextView.font = UIFont(name: "AvenirNext-Bold", size: 30)
            goOnlineButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 30)
            goOfflineButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 30)
        }
    }
    
    func initializeMapView() {
        
        let regionRadius: CLLocationDistance = 500
        let coordinateRegion = MKCoordinateRegion(center: CLLocation(
            latitude: 37.3352, longitude: -121.8811).coordinate,
                                                  latitudinalMeters: regionRadius * 2.0,
                                                  longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    func fetchProfilePhoto () {
        
        let storage = Storage.storage()
        var reference: StorageReference!
        let uid = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            //user model has name, email, and profileImageUrl, etc stored in database
            //fetch anything stored in the database in this if statement
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                //grab the image url from firebase
                let profileUrl = dictionary["profileImageUrl"] as? String
                reference = storage.reference(forURL: profileUrl!)
                
                reference.downloadURL { (url, error) in
                    let data = NSData(contentsOf: url!)
                    let image = UIImage(data: data! as Data)
                    self.profileImage.image = image
                }
            }
            
        }, withCancel: nil)
    }
    
    @objc func handleLogout() {
        
        do{
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        present(ViewController(), animated: true, completion: nil)
    }
    
    @objc func handleSetting() {
        present(SettingZeroViewController(), animated: true, completion: nil)
    }
    
    @objc func hamburgClicked() {
        //print("Hamburg clicked.")
        hamburgerMenu.showMenu()
    }
    
    @objc func handleRideHistory() {
        
        present(RideHistoryViewController(), animated: true, completion: nil)
    }
    
    @objc func goOnlineClicked(){
        
        if(readyToValet == "true"){
            self.goOnlineButton.isHidden = true
            self.goOnlineButton.isEnabled = false
        
            self.goOfflineButton.isHidden = false
            self.goOfflineButton.isEnabled = true
        
            statusLabel.text = "You are online... accepting requests"
        
            checkForStatus();
        }
        else if(readyToValet == "false"){
            handleEmptyDestination()
        }
        
    }
    
    @objc func goOfflineClicked(){
        self.goOfflineButton.isHidden = true
        self.goOfflineButton.isEnabled = false
        
        self.goOnlineButton.isHidden = false
        self.goOnlineButton.isEnabled = true
        
        statusLabel.text = "You are offline."
        
        Database.database().reference().child("ongoingRequests").removeAllObservers()
    }
    
    func checkForStatus() {
        let databaseRef = Database.database().reference().child("ongoingRequests")
        databaseRef.observe(.value) { (snapshot: DataSnapshot) in
            let key = snapshot.children;
            
            for case let rest as DataSnapshot in key {
                let snapshotValue = rest.value as! [String: String];
                
                let requestisAccepted = snapshotValue["requestIsAccepted"]!
                let matchedValetID = snapshotValue["matchedValetID"]!
                let canceledValetID = snapshotValue["canceledValetID"]!
                
                print(requestisAccepted, matchedValetID, canceledValetID);
                if (requestisAccepted == "false" && matchedValetID == "" && canceledValetID != Auth.auth().currentUser?.uid) {
                    let userID = rest.key;
                    
                    let database = Database.database().reference().child("ongoingRequests").child(userID)
                    database.updateChildValues(["matchedValetID": Auth.auth().currentUser?.uid as Any])
                    
                        self.present(ValetRequestedViewController(), animated: true, completion: nil)
                    
                     
                        print(rest.value!)
                    
                    //self.present(self.matchingView, animated: true, completion: nil)

                    
                }
            }
        }
            
    }
    
    func presentUser() {
        self.present(ValetDirectionToUserViewController(), animated: true, completion: nil)
    }
    
    func handleEmptyDestination() {
        let errorAlertVC = UIAlertController(title: "Error", message: "Please completely update your settings", preferredStyle: .alert)
        let errorAlertActionOkay = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        errorAlertVC.addAction(errorAlertActionOkay)
        self.present(errorAlertVC, animated: true, completion: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let databaseRef = Database.database().reference().child("ongoingRequests");
//        databaseRef.observe(.value) { (snapshot: DataSnapshot) in
//            let key = snapshot.children;
//
//            for case let rest as DataSnapshot in key {
//                let snapshotValue = rest.value as! [String: String]
//
//                //let requestisAccepted = snapshotValue["requestIsAccepted"]!
//                let matchedValetID = snapshotValue["matchedValetID"]!
//
//                //print(requestisAccepted, matchedValetID);
//                if (matchedValetID == Auth.auth().currentUser?.uid) {
//                    let userID = rest.key
//
//                    if let destinationVC = segue.destination as? ValetRequestedViewController {
//                        destinationVC.userID = userID
//                    }
//                }
//            }
//        }
//    }
    
    func handleRequestComplete () {
        
    }
    }



