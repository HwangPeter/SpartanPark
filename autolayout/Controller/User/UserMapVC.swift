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

class UserMapVC: UIViewController, CLLocationManagerDelegate {
    
    var currentVC:UIViewController?
    var userStatus = ""
    
    var  locationManager = CLLocationManager()
    var route: MKRoute!
    
    let lots = LotLocationList().lot
    var priceGarage = 12, pricePNR = 10
    
    let lineContainerView = containerView()
    let greenLightContainerView = containerView()
    let gryLightContainerView = containerView()
    let segmentContainerView = containerView()
    
    let menuContainerView: UIView = {
        let view = GradientView()
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
        menu.currentVC = self
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
    
    let locationContainerView: UIView = {
        
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.white
        
        view.layer.cornerRadius = 5.0
        view.layer.shadowOpacity = 0.4
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 6.0
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let greenDot: UIView = {
        
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = .green
        view.layer.cornerRadius = 6
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor(red: 0/255.0, green: 100/255.0, blue: 0/255.0, alpha: 1).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let greyDot: UIView = {
        
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
        view.layer.cornerRadius = 6
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let currentLocationTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        textField.text = "Where should your car be Parked?"
        textField.borderStyle = UITextField.BorderStyle.none
        textField.backgroundColor = UIColor.white
        textField.textColor = UIColor(red: 57/255.0, green: 57/255.0, blue: 57/255.0, alpha: 1)
        textField.textAlignment = .left
        textField.isUserInteractionEnabled = false
        //textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let destinationTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
//        textField.attributedPlaceholder = NSAttributedString(string: "Where are you meeting?", attributes: [
//            .foregroundColor: UIColor.lightGray
//            //.font: UIFont.systemFont(ofSize: 25.0)
//          ])
        textField.placeholder = "Where are you meeting?"
        textField.borderStyle = UITextField.BorderStyle.none
        textField.backgroundColor = UIColor.white
        textField.textAlignment = .left
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.isUserInteractionEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let centerMapButton: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.backgroundColor = nil
        button.setImage(UIImage(named: "centerMapBtn"), for: .normal)
        button.showsTouchWhenHighlighted = true
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(centerMapOnCampus), for: .touchUpInside)
        return button
    }()
    
    @objc func centerMapOnCampus() {
        let regionRadius: CLLocationDistance = 500
        let coordinateRegion = MKCoordinateRegion(center: CLLocation(
            latitude: 37.3352, longitude: -121.8811).coordinate,
                                                  latitudinalMeters: regionRadius * 2.0,
                                                  longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    let requestValetButton: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.backgroundColor = .white
        button.setTitle("REQUEST VALET", for: .normal)
        button.setTitleColor(UIColor(red: 57/255.0, green: 57/255.0, blue: 57/255.0, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(requestValetPressed), for: .touchUpInside)
        
        button.layer.cornerRadius = 5.0
        button.layer.shadowOpacity = 0.4
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 6.0
        
        button.showsTouchWhenHighlighted = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotationView) {
        destinationTextField.text = annotation.annotation?.title ?? "Lot"
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let lineRenderer = MKPolylineRenderer(overlay: self.route.polyline)
        lineRenderer.strokeColor = UIColor(red: 0/255.0, green: 85/255.0, blue: 162/255.0, alpha: 0.75)
        lineRenderer.lineWidth = 5
        lineRenderer.lineCap = .round
        return lineRenderer
    }
    
    let mapView: MKMapView = {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let maps = MKMapView(frame: CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height))
        maps.translatesAutoresizingMaskIntoConstraints = false
        return maps
    }()
    
    lazy var parkingOptionSegmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Garages $\(priceGarage)", "Park & Ride $\(pricePNR)"])
        let font_414 = UIFont.systemFont(ofSize: 20)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor(red: 0/255.0, green: 85/255.0, blue: 162/255.0, alpha: 1)
        sc.selectedSegmentIndex = 0
        sc.setTitleTextAttributes([NSAttributedString.Key.font: font_414],
                                  for: .normal)
        return sc
    }()
    
    lazy var matchingAnimation: UserMatchingVC = {
        let animation = UserMatchingVC()
        animation.currentVC = self
        animation.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        return animation
    }()
    
    lazy var valetView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.white
        
        view.layer.cornerRadius = 5.0
        view.layer.shadowOpacity = 0.4
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -5)
        view.layer.shadowRadius = 6.0
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate func setupLocationManager() {
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupLayout()
        initializeMapView()
        let uid = Auth.auth().currentUser?.uid
        fetchProfilePhoto(uid: uid!, completion: { image, name in
            if let image = image {
                self.profileImage.image = image
            }
        })
        setupLocationManager()
        getUserStatus() {
            self.handleNewUserStatus()
        }
        observeUserStatus()
        
    }
    
    func observeUserStatus() {
        let uid = Auth.auth().currentUser!.uid
        Database.database().reference().child("ongoingRequests").child(uid).observe(.value) { (snapshot) in
            if let snapshotValue = snapshot.value as? [String: String] {
                if (self.userStatus != snapshotValue["status"] ?? "") {
                    self.userStatus = snapshotValue["status"] ?? ""
                    self.handleNewUserStatus()
                }
            }
        }
    }
    
    
    func getUserStatus(finished: @escaping () -> Void) {
        Database.database().reference().child("ongoingRequests").child(Auth.auth().currentUser!.uid).child("status").observeSingleEvent(of: .value) { (snapshot) in
            
            self.userStatus = snapshot.value as? String ?? "";
            self.currentVC = self
            finished()
        }
    }
    
    func handleNewUserStatus() {
        switch self.userStatus {
            
        case "requesting":
            if self.currentVC != matchingAnimation {
                self.present(matchingAnimation, animated: true, completion: {self.currentVC = self.matchingAnimation})
                waitingForDriverAction()
            }
            break
            
        case "requestAccepted":
            matchingAnimation.matchFound()
            Database.database().reference().child("ongoingRequests").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { (snapshot) in
                
                if let snapshotValue = snapshot.value as? [String: String] {
                    let valetUID = snapshotValue["matchedValetID"] ?? ""
                    self.handleMatched(valetUID)
                }
            }
            break
            
        case "parkingInProgress":
            Database.database().reference().child("ongoingRequests").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { (snapshot) in
                
                if let snapshotValue = snapshot.value as? [String: String] {
                    let valetUID = snapshotValue["matchedValetID"] ?? ""
                    let parkingVC = UserParkingInProgressVC()
                    parkingVC.valetImage = self.valetProfilePicView.image ?? UIImage()
                    parkingVC.valetName = self.valetNameLabel.text ?? ""
                    parkingVC.valetID = valetUID
                    self.present(parkingVC, animated: true, completion: {self.currentVC = parkingVC})
                }
            }
            //TODO: Finish adding more cases.
            break
            
        case "parkingComplete":
            if self.currentVC != self {
                self.currentVC?.dismiss(animated: true, completion: {
                    let parkingCompleteVC = UserParkingCompleteVC()
                    parkingCompleteVC.parentVC = self
                    self.present(parkingCompleteVC, animated: true, completion: { self.currentVC = parkingCompleteVC})
                })
            }
            else {
                let parkingCompleteVC = UserParkingCompleteVC()
                parkingCompleteVC.parentVC = self
                self.present(parkingCompleteVC, animated: true, completion: { self.currentVC = parkingCompleteVC})
            }
            break
            
        case "finished":
            print("Case is finished.")
            let requestRef = Database.database().reference().child("ongoingRequests").child((Auth.auth().currentUser?.uid)!)
            requestRef.removeAllObservers()
            requestRef.removeValue()
            self.dismiss(animated: true, completion: nil)
            break
            
        default:
            break
        }
    }
    
    func setupLayout() {
        
        view.backgroundColor = .white
        
        view.addSubview(menuContainerView)
        view.addSubview(locationContainerView)
        view.addSubview(mapView)
        view.addSubview(centerMapButton)
        view.addSubview(requestValetButton)
        
        view.bringSubviewToFront(menuContainerView)
        view.bringSubviewToFront(locationContainerView)
        
        menuContainerView.addSubview(hamburgerButton)
        menuContainerView.addSubview(nameTextView)
        menuContainerView.addSubview(profileImage)
        
        locationContainerView.addSubview(currentLocationTextField)
        locationContainerView.addSubview(destinationTextField)
        locationContainerView.addSubview(segmentContainerView)
        segmentContainerView.addSubview(parkingOptionSegmentControl)
        
        locationContainerView.addSubview(greenLightContainerView)
        greenLightContainerView.addSubview(greenDot)
        
        locationContainerView.addSubview(gryLightContainerView)
        gryLightContainerView.addSubview(greyDot)
        
        locationContainerView.addSubview(lineContainerView)
        lineContainerView.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)

        
        NSLayoutConstraint.activate([
            menuContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12)
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
            locationContainerView.topAnchor.constraint(equalTo: menuContainerView.bottomAnchor, constant: -17),
            locationContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            locationContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.16)
            ])
        
        NSLayoutConstraint.activate([
            destinationTextField.topAnchor.constraint(equalTo: locationContainerView.topAnchor),
            destinationTextField.trailingAnchor.constraint(equalTo: locationContainerView.trailingAnchor, constant: -6),
            destinationTextField.widthAnchor.constraint(equalTo: locationContainerView.widthAnchor, multiplier: 0.835),
            destinationTextField.heightAnchor.constraint(equalTo: locationContainerView.heightAnchor, multiplier: 0.28)
            ])
        
        NSLayoutConstraint.activate([
            lineContainerView.topAnchor.constraint(equalTo: destinationTextField.bottomAnchor),
            lineContainerView.centerXAnchor.constraint(equalTo: locationContainerView.centerXAnchor),
            lineContainerView.widthAnchor.constraint(equalTo: locationContainerView.widthAnchor, multiplier: 0.85),
            lineContainerView.heightAnchor.constraint(equalTo: locationContainerView.heightAnchor, multiplier: 0.01)
            ])
        
        
        NSLayoutConstraint.activate([
            currentLocationTextField.topAnchor.constraint(equalTo: lineContainerView.bottomAnchor),
            currentLocationTextField.trailingAnchor.constraint(equalTo: locationContainerView.trailingAnchor, constant: -6),
            currentLocationTextField.widthAnchor.constraint(equalTo: locationContainerView.widthAnchor, multiplier: 0.835),
            currentLocationTextField.heightAnchor.constraint(equalTo: locationContainerView.heightAnchor, multiplier: 0.28)
            ])
        
        NSLayoutConstraint.activate([
            segmentContainerView.topAnchor.constraint(equalTo: currentLocationTextField.bottomAnchor),
            segmentContainerView.bottomAnchor.constraint(equalTo: locationContainerView.bottomAnchor),
            segmentContainerView.leadingAnchor.constraint(equalTo: locationContainerView.leadingAnchor),
            segmentContainerView.trailingAnchor.constraint(equalTo: locationContainerView.trailingAnchor)
            ])
        
        NSLayoutConstraint.activate([
            parkingOptionSegmentControl.centerXAnchor.constraint(equalTo: segmentContainerView.centerXAnchor),
            parkingOptionSegmentControl.centerYAnchor.constraint(equalTo: segmentContainerView.centerYAnchor),
            parkingOptionSegmentControl.heightAnchor.constraint(equalTo: segmentContainerView.heightAnchor, multiplier: 0.82),
            parkingOptionSegmentControl.widthAnchor.constraint(equalTo: segmentContainerView.widthAnchor, multiplier: 0.94)
            ])
        
        
        NSLayoutConstraint.activate([
            greenLightContainerView.centerYAnchor.constraint(equalTo: currentLocationTextField.centerYAnchor),
            greenLightContainerView.trailingAnchor.constraint(equalTo: currentLocationTextField.leadingAnchor),
            greenLightContainerView.heightAnchor.constraint(equalTo: locationContainerView.heightAnchor, multiplier: 0.495),
            greenLightContainerView.widthAnchor.constraint(equalTo: locationContainerView.widthAnchor, multiplier: 0.13)
            ])
        
        NSLayoutConstraint.activate([
            greenDot.centerXAnchor.constraint(equalTo: greenLightContainerView.centerXAnchor),
            greenDot.centerYAnchor.constraint(equalTo: greenLightContainerView.centerYAnchor),
            greenDot.widthAnchor.constraint(equalToConstant: 12),
            greenDot.heightAnchor.constraint(equalToConstant: 12)
            ])
        
        NSLayoutConstraint.activate([
            gryLightContainerView.centerYAnchor.constraint(equalTo: destinationTextField.centerYAnchor),
            gryLightContainerView.trailingAnchor.constraint(equalTo: destinationTextField.leadingAnchor),
            gryLightContainerView.heightAnchor.constraint(equalTo: locationContainerView.heightAnchor, multiplier: 0.495),
            gryLightContainerView.widthAnchor.constraint(equalTo: locationContainerView.widthAnchor, multiplier: 0.13)
            ])
        
        NSLayoutConstraint.activate([
            greyDot.centerXAnchor.constraint(equalTo: gryLightContainerView.centerXAnchor),
            greyDot.centerYAnchor.constraint(equalTo: gryLightContainerView.centerYAnchor),
            greyDot.widthAnchor.constraint(equalToConstant: 12),
            greyDot.heightAnchor.constraint(equalToConstant: 12)
            ])
        
        NSLayoutConstraint.activate([
            requestValetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            requestValetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            requestValetButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            requestValetButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07)
            ])
        
        NSLayoutConstraint.activate([
            centerMapButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -95),
            centerMapButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            centerMapButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15),
            centerMapButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15)
            ])
        
        
        // iphone 5s,SE screen width 320
        // iphone 6,6s,7,etc width 375
        // iphone 7 plus, 8 plus, xs max,etc width 414
        
        if (view.frame.width == 320) {
            
            nameTextView.font = UIFont(name: "AvenirNext-Bold", size: 20)
            requestValetButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 20)
            currentLocationTextField.font = UIFont(name: "AvenirNext", size: 12)
            destinationTextField.font = UIFont(name: "AvenirNext", size: 12)
            
        } else if (view.frame.width == 375) {
            
            nameTextView.font = UIFont(name: "AvenirNext-Bold", size: 25)
            requestValetButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 25)
            currentLocationTextField.font = UIFont(name: "AvenirNext", size: 14)
            //destinationTextField.font = UIFont(name: "AvenirNext", size: 14)
            destinationTextField.attributedPlaceholder = NSAttributedString(string: "Tap on the drop pins.", attributes: [
                .foregroundColor: UIColor.lightGray,
                .font: UIFont.boldSystemFont(ofSize: 16.0)])
            parkingOptionSegmentControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], for: .normal)
            
        } else if (view.frame.width == 414) {
            
            nameTextView.font = UIFont(name: "AvenirNext-Bold", size: 30)
            requestValetButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 30)
            currentLocationTextField.font = UIFont(name: "AvenirNext", size: 20)
            //destinationTextField.font = UIFont(name: "AvenirNext", size: 16)
            destinationTextField.attributedPlaceholder = NSAttributedString(string: "Tap on the drop pins.", attributes: [
                .foregroundColor: UIColor.lightGray,
                .font: UIFont.boldSystemFont(ofSize: 18.0)])
            parkingOptionSegmentControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)], for: .normal)
        }
    }
    
    func initializeMapView() {
        
        let regionRadius: CLLocationDistance = 500
        let coordinateRegion = MKCoordinateRegion(center: CLLocation(
            latitude: 37.3352, longitude: -121.8811).coordinate,
                                                  latitudinalMeters: regionRadius * 2.0,
                                                  longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotations(lots)
        mapView.delegate = self
    }
    
    func fetchProfilePhoto(uid: String, completion: @escaping (UIImage?, String)->()) {
        
        let storage = Storage.storage()
        var reference: StorageReference!
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            //user model has name, email, and profileImageUrl, etc stored in database
            //fetch anything stored in the database in this if statement
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                //grab the image url from firebase
                let profileUrl = dictionary["profileImageUrl"] as? String
                let name = dictionary["name"] as? String
                
                reference = storage.reference(forURL: profileUrl!)
                
                reference.downloadURL { (url, error) in
                    let data = NSData(contentsOf: url!)
                    let image = UIImage(data: data! as Data)
                    completion(image, name ?? "")
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
    
    @objc func hamburgClicked() {
        hamburgerMenu.showMenu()
    }
    
    @objc func handleSetting() {
        present(SettingZeroViewController(), animated: true, completion: nil)
    }
    
    @objc func handleRideHistory() {
        
        present(RideHistoryViewController(), animated: true, completion: nil)
    }
    
    @objc func requestValetPressed() {
        let meetupLot = destinationTextField.text!
        let parkInGarage = String(Bool(truncating: parkingOptionSegmentControl.selectedSegmentIndex as NSNumber))
        if meetupLot == "" {
            handleEmptyDestination()
        }
        else {
            self.present(matchingAnimation, animated: true, completion: {
                self.currentVC = self.matchingAnimation
                self.userStatus = "requesting"
                self.enterRequestIntoDatabase(meetupLot: meetupLot, parkInGarage: parkInGarage) {
                    self.waitingForDriverAction()
                }
            })
        }
        
        
    }
    
    
    func handleEmptyDestination() {
        let errorAlertVC = UIAlertController(title: "Error", message: "Please select an area to meet up by selecting any spartan pin on the map.", preferredStyle: .alert)
        let errorAlertActionOkay = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        errorAlertVC.addAction(errorAlertActionOkay)
        self.present(errorAlertVC, animated: true, completion: nil)
    }
    
    func enterRequestIntoDatabase(meetupLot: String, parkInGarage: String, finished: @escaping () -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let dateInFormat = dateFormatter.string(from: NSDate() as Date)
        let uid = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(uid!).child("Car").observeSingleEvent(of: .value) { (snapshot) in
            var carInfo = ""
            let snapshotValue = snapshot.value as! [String:String]
            carInfo.append(snapshotValue["carMake"]!)
            carInfo.append(" ")
            carInfo.append(snapshotValue["carModel"]!)
            carInfo.append(", ")
            carInfo.append(snapshotValue["carColor"]!)
            carInfo.append(" ")
            carInfo.append(snapshotValue["carYear"]!)
            
            Database.database().reference().child("users").child(uid!).child("profileImageUrl").observeSingleEvent(of: .value) { (snapshot) in
                let profileUrl = snapshot.value as! String
                
                Database.database().reference().child("users").child(uid!).child("name").observeSingleEvent(of: .value) { (snapshot) in
                    let snapshotValue = snapshot.value as! String;
                    let name = snapshotValue
                    Database.database().reference().child("ongoingRequests").child(uid!).updateChildValues(["status": "requesting", "meetupLot": meetupLot, "parkInPNR": parkInGarage, "requestIsAccepted": "false", "currentTime": dateInFormat, "matchedValetID": "", "name": name, "carInfo": carInfo, "profileImageUrl": profileUrl, "canceledValetID": "", "userLatitude": "\(self.locationManager.location?.coordinate.latitude ?? 0)" , "userLongitude": "\(self.locationManager.location?.coordinate.longitude ?? 0)"  ])
                    finished()
                }
            }
        }
    }
    
    fileprivate func removeViewsAfterMatchFound(finished: @escaping () -> Void) {
        self.matchingAnimation.matchFound()
        UIView.animate(withDuration: 0.35, delay: 0.4, options: .curveEaseIn, animations: {
            self.locationContainerView.center = CGPoint(x: self.view.center.x, y: -200)
            self.locationContainerView.alpha = 0
            self.requestValetButton.center = CGPoint(x: self.view.center.x, y: self.view.frame.height + 200)
            self.requestValetButton.alpha = 0
        }) { _ in
            self.requestValetButton.removeFromSuperview()
            self.locationContainerView.removeFromSuperview()
            finished()
        }
        
    }
    
    fileprivate func startNavigation() {
        Database.database().reference().child("ongoingRequests").child((Auth.auth().currentUser?.uid)!).child("meetupLot").observeSingleEvent(of: .value) { (snapshot) in
            let meetupLot = snapshot.value as! String
            
            for lot in self.lots[0...self.lots.count-1] {
                if(lot.title == meetupLot) {
                    let lat = lot.coordinate.latitude
                    let long = lot.coordinate.longitude
                    let regionRadius: CLLocationDistance = 500
                    let lotLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let centerOfUserAndLot = self.middleLocationWith(location: lotLocation, location2: (self.locationManager.location?.coordinate) ?? lotLocation)
                    let coordinateRegion = MKCoordinateRegion(center: centerOfUserAndLot,
                                                              latitudinalMeters: regionRadius * 2,
                                                              longitudinalMeters: regionRadius * 2)
                    self.mapView.setRegion(coordinateRegion, animated: true)
                    let lotPlacemark = MKPlacemark(coordinate: lot.coordinate)
                    self.drawPolylineContinuously(forMapItem: MKMapItem(placemark: lotPlacemark))
                }
            }
        }
    }
    
    func middleLocationWith(location:CLLocationCoordinate2D, location2:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
        let lon1 = location.longitude * .pi / 180
        let lon2 = location2.longitude * .pi / 180
        let lat1 = location.latitude * .pi / 180
        let lat2 = location2.latitude * .pi / 180
        let dLon = lon2 - lon1
        let x = cos(lat2) * cos(dLon)
        let y = cos(lat2) * sin(dLon)
        
        let lat3 = atan2( sin(lat1) + sin(lat2), sqrt((cos(lat1) + x) * (cos(lat1) + x) + y * y) )
        let lon3 = lon1 + atan2(y, cos(lat1) + x)
        
        let center:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat3 * 180 / .pi, lon3 * 180 / .pi)
        return center
    }
    
    
    func userCloseToDestination(mapItem: MKMapItem ) -> Bool{
        let lotLocation = CLLocation(latitude: mapItem.placemark.coordinate.latitude, longitude: mapItem.placemark.coordinate.longitude)
        let distance = locationManager.location?.distance(from: lotLocation)
        return (Int(distance ?? 0) < 125)
    }
    
    func drawPolylineContinuously(forMapItem mapItem: MKMapItem) {
        let request = MKDirections.Request()
        request.destination = mapItem
        request.transportType = MKDirectionsTransportType.automobile
        request.requestsAlternateRoutes = true
        
        request.source = MKMapItem.forCurrentLocation()
        let directions = MKDirections(request: request)
        
        directions.calculate { (response, error) in
            guard let response = response else {
//                let errorAlertVC = UIAlertController(title: "Error", message: error.debugDescription, preferredStyle: .alert)
//                let errorAlertActionOkay = UIAlertAction(title: "Okay", style: .default, handler: nil)
//
//                errorAlertVC.addAction(errorAlertActionOkay)
//                self.present(errorAlertVC, animated: true, completion: nil)
                return
            }
            self.route = response.routes[0]
            self.mapView.addOverlay(self.route!.polyline)
            
            Timer.scheduledTimer(withTimeInterval: 3, repeats: true){ t in
                if(self.userCloseToDestination(mapItem: mapItem)) {
                    self.mapView.removeOverlays(self.mapView.overlays)
                    t.invalidate()
                }
                request.source = MKMapItem.forCurrentLocation()
                let directions = MKDirections(request: request)
                
                directions.calculate { (response, error) in
                    guard let response = response else {
//                        let errorAlertVC = UIAlertController(title: "Error", message: error.debugDescription, preferredStyle: .alert)
//                        let errorAlertActionOkay = UIAlertAction(title: "Okay", style: .default, handler: nil)
//
//                        errorAlertVC.addAction(errorAlertActionOkay)
//                        self.present(errorAlertVC, animated: true, completion: nil)
                        return
                    }
                    
                    self.route = response.routes[0]
                    self.mapView.removeOverlays(self.mapView.overlays)
                    self.mapView.addOverlay(self.route!.polyline)
                }
            }
            
        }
    }
    
    fileprivate func handleMatched(_ valetUID: String) {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("ongoingRequests").child(uid!).updateChildValues(["status": "requestAccepted"])
        self.userStatus = "requestAccepted"
        self.currentVC = self
        self.removeViewsAfterMatchFound {
            self.startNavigation()
            self.setupValetView(valetID: valetUID) {
                self.showValetView()
                self.showAndUpdateValetAnnotation()
            }
        }
    }
    
    func waitingForDriverAction() {
        
        let uid = Auth.auth().currentUser?.uid
        let userDatabase = Database.database().reference().child("ongoingRequests").child(uid!).child("requestIsAccepted")
        userDatabase.observe(.value) { (snapshot) in
            if (snapshot.exists()) {
                let snapshotValue = snapshot.value as! String
                
                
                if (snapshotValue == "true") {
                    Database.database().reference().child("ongoingRequests").child(uid!).child("matchedValetID").observeSingleEvent(of: .value) { (snapshot) in
                        let valetUID = snapshot.value as! String
                        self.handleMatched(valetUID)
                        userDatabase.removeAllObservers()
                    }
                }
            }
        }
    }
    
    lazy var valetProfilePicView: UIImageView = {
        let profile = UIImage(named: "noProfilePhoto")
        let profileView = UIImageView(image: profile)
        let viewSize = self.view.frame.height * 0.08
        profileView.contentMode = .scaleAspectFit
        profileView.layer.cornerRadius = viewSize/2
        profileView.clipsToBounds = true
        profileView.frame = CGRect(x: 15, y: 10, width: viewSize, height: viewSize)
        profileView.layer.borderWidth = 3
        profileView.layer.borderColor = UIColor(red: 0/255.0, green: 85/255.0, blue: 162/255.0, alpha: 0.65).cgColor
        return profileView
    }()
    
    lazy var valetNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    fileprivate func setupValetProfilePic(_ valetID: String, _ viewSize: CGFloat, finished: @escaping () -> Void) {
        fetchProfilePhoto(uid: valetID, completion: { image, name in
            if let image = image {
                self.valetProfilePicView.image = image
                self.valetProfilePicView.frame = CGRect(x: 15, y: (self.valetView.frame.height/2) - (viewSize/2), width: viewSize, height: viewSize)
                self.setupValetLabel(name: name)
                self.valetView.addSubview(self.valetProfilePicView)
                finished()
            }
        })
    }
    
    func setupValetLabel(name: String) {
        self.valetNameLabel.frame = CGRect(x: self.valetProfilePicView.frame.width + 30, y: (self.valetView.frame.height/2) - 15, width: self.view.frame.width, height: 30)
        self.valetNameLabel.text = name
        self.valetView.addSubview(self.valetNameLabel)
    }
    
    func setupValetView(valetID: String, finished: @escaping () -> Void) {
        self.view.addSubview(self.valetView)
        let viewSize = self.view.frame.height * 0.08
        self.valetView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height * 0.15)
        self.valetView.alpha = 0
        setupValetProfilePic(valetID, viewSize) {
            finished()
        }
    }
    
    func showValetView() {
        UIView.animate(withDuration: 0.4, delay: 1, options: .curveEaseIn, animations: {
            self.valetView.frame = CGRect(x: 0, y: self.view.frame.height * 0.85, width: self.view.frame.width, height: self.view.frame.height * 0.15)
            self.valetView.alpha = 1
        }){ _ in
        }
    }
    
    func showAndUpdateValetAnnotation() {
        let uid = Auth.auth().currentUser?.uid
        let userDatabase = Database.database().reference().child("ongoingRequests").child(uid!)
        
        
        
        userDatabase.observeSingleEvent(of: .value) { (snapshot) in
            if (snapshot.exists()) {
                let snapshotValue = snapshot.value as! [String: String];
                
                if let valetLatitude = Double(snapshotValue["valetLatitude"]!) {
                    if let valetLongitude = Double(snapshotValue["valetLongitude"]!) {
                        let valetCoords = CLLocationCoordinate2D(latitude: valetLatitude, longitude: valetLongitude)
                        let valetAnnotation = ValetAnnotation(key: "driver", coordinate: valetCoords)
                        self.mapView.addAnnotation(valetAnnotation)
                        
                        userDatabase.observe(.value) { (snapshot) in
                            if (snapshot.exists()) {
                                let snapshotValue = snapshot.value as! [String: String];
                                
                                if let valetLatitude = Double(snapshotValue["valetLatitude"]!) {
                                    if let valetLongitude = Double(snapshotValue["valetLongitude"]!) {
                                        let valetCoords = CLLocationCoordinate2D(latitude: valetLatitude, longitude: valetLongitude)
                                        valetAnnotation.update(annotationPosition: valetAnnotation, withCoordinate: valetCoords)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        }
    }
}

extension UserMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        updateLocationService.instance.updateUserLocation(withCoordinate: userLocation.coordinate)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view : MKMarkerAnnotationView
        if let annotation = annotation as? ValetAnnotation {
            let identifier = "valet"
            var valetView: MKAnnotationView
            valetView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            imageView.image = self.valetProfilePicView.image
            imageView.layer.cornerRadius = imageView.layer.frame.size.width / 2
            imageView.layer.masksToBounds = true
            valetView.addSubview(imageView)
            return valetView
        }
        else if let annotation = annotation as? LotLocations {
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.identifier) as? MKMarkerAnnotationView {
                view = dequeuedView
            }else { //make a new view
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
            }
            view.markerTintColor = UIColor(red: 0/255.0, green: 85/255.0, blue: 162/255.0, alpha: 1)
            view.glyphImage = UIImage(named: "spartan_spirit.png")
            return view
        }
        else {
            return nil
            
        }
    }
}
