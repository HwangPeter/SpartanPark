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

class ValetDirectionToSCEViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    let menuContainerView: UIView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleTextView: UITextView = {
        
        let textView = UITextView(frame: CGRect.zero)
        textView.backgroundColor = nil
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor(red: 0/255.0, green: 85/255.0, blue: 162/255.0, alpha: 1)]
        
        let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor(red: 57/255.0, green: 57/255.0, blue: 57/255.0, alpha: 1)]
        
        //let attributedString1 = NSMutableAttributedString(string:"SPTN", attributes:attrs1)
        let attributedString1 = NSMutableAttributedString(string:"GO TO SCE ", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:"ENGR 294", attributes:attrs2)
        
        attributedString1.append(attributedString2)
        textView.attributedText = attributedString1
        
        return textView
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
    
    let imageContainerView: UIView = {
        
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = nil
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameContainerView: UIView = {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        view.backgroundColor = nil
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var avatarImageView: UIImageView = {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //let avatar = UIImage(named: "avatar_icon")
        let avatar = UIImage(named: "noProfilePhoto3")
        let avatarView = UIImageView(image: avatar)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        
        //userInfoContainerView is constraint 90% to view width
        //imageContainerView is constraint 36% to userInfoContainerView
        //the image is constraint 90% to imageContainerView
        let myRadius = (screenHeight * 0.9 * 0.15 * 0.9)/2.0
        avatarView.layer.cornerRadius = myRadius
        avatarView.clipsToBounds = true
        avatarView.contentMode = .scaleAspectFit
        
        return avatarView
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        textField.text = "First Last"
        textField.borderStyle = UITextField.BorderStyle.none
        textField.backgroundColor = UIColor.white
        textField.textColor = UIColor(red: 57/255.0, green: 57/255.0, blue: 57/255.0, alpha: 1)
        textField.textAlignment = .left
        textField.isUserInteractionEnabled = false
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let parkingTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        textField.text = "Garage / Park & Ride"
        textField.borderStyle = UITextField.BorderStyle.none
        textField.backgroundColor = UIColor.white
        textField.textColor = UIColor(red: 57/255.0, green: 57/255.0, blue: 57/255.0, alpha: 1)
        textField.textAlignment = .left
        textField.isUserInteractionEnabled = false
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let carInfoTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        textField.text = "Mercedes Benz, White"
        textField.borderStyle = UITextField.BorderStyle.none
        textField.backgroundColor = UIColor.white
        textField.textColor = UIColor(red: 57/255.0, green: 57/255.0, blue: 57/255.0, alpha: 1)
        textField.textAlignment = .left
        textField.isUserInteractionEnabled = false
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let firstLineContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
        return view
    }()
    
    let secondLineContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
        return view
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
    
    let dropOffKeyButton: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.backgroundColor = .white
        button.setTitle("DROP OFF KEY", for: .normal)
        button.setTitleColor(UIColor(red: 57/255.0, green: 57/255.0, blue: 57/255.0, alpha: 1), for: .normal)
        
        button.layer.cornerRadius = 5.0
        button.layer.shadowOpacity = 0.4
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 6.0
        
        button.showsTouchWhenHighlighted = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(dropOffKeyClicked), for: .touchUpInside)
        return button
    }()
    
    //    @objc func dropOffKeyClicked() {
    //        print("drop off key Clicked")
    //        //self.dismiss(animated: true, completion: nil)
    //
    //        let databaseRef = Database.database().reference().child("ongoingRequests");
    //        databaseRef.observe(.value) { (snapshot: DataSnapshot) in
    //            let key = snapshot.children;
    //
    //            for case let rest as DataSnapshot in key {
    //                let snapshotValue = rest.value as! [String: String];
    //
    //                //let requestisAccepted = snapshotValue["requestIsAccepted"]!;
    //                let matchedValetID = snapshotValue["matchedValetID"]!;
    //
    //                //print(requestisAccepted, matchedValetID);
    //                if (matchedValetID == Auth.auth().currentUser?.uid) {
    //                    let userID = rest.key;
    //
    //                    let database = Database.database().reference().child("ongoingRequests").child(userID)
    //                    database.updateChildValues(["status3": ""])
    //
    //                    self.dismiss(animated: true, completion: nil)
    //
    //                }
    //            }
    //        }
    //    }
    
    @objc func dropOffKeyClicked() {
        
        let databaseRef = Database.database().reference().child("ongoingRequests");
        databaseRef.observeSingleEvent(of: .value) { (DataSnapshot) in
            let key = DataSnapshot.children
            
            for case let rest as DataSnapshot in key {
                let snapshotValue = rest.value as! [String: String];
                
                let matchedValetID = snapshotValue["matchedValetID"]!;
                if matchedValetID == Auth.auth().currentUser!.uid {
                    
                    let name = snapshotValue["name"]!
                    let profileImageUrl = snapshotValue["profileImageUrl"]!
                    let currentTime = snapshotValue["currentTime"]!
                    let carInfo = snapshotValue["carInfo"]!
                    
                    let userID = rest.key;
                    let database = Database.database().reference().child("ongoingRequests").child(userID)
                    database.updateChildValues(["status": "parkingComplete"])
                    
                    let db = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("Valet Ride History")
                    db.childByAutoId().setValue(["userName": name, "userProfileImageUrl": profileImageUrl, "currentTime": currentTime, "carInfo": carInfo])
                    
                    Database.database().reference().child("ongoingRequests").removeAllObservers()
                    
                    //self.present(ViewController(), animated: true, completion: nil)
                    self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    let mapView: MKMapView = {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let maps = MKMapView(frame: CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height))
        maps.translatesAutoresizingMaskIntoConstraints = false
        return maps
    }()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupLayout()
        initializeMapView()
        getUserInfo()
        self.hideKeyboardWhenTappedAround()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        createPolyline()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    }
    
    private func setupLayout() {
        
        view.backgroundColor = .white
        
        view.addSubview(menuContainerView)
        view.addSubview(userInfoContainerView)
        view.addSubview(mapView)
        view.addSubview(centerMapButton)
        
        view.addSubview(dropOffKeyButton)
        
        view.bringSubviewToFront(menuContainerView)
        view.bringSubviewToFront(userInfoContainerView)
        
        menuContainerView.addSubview(titleTextView)
        userInfoContainerView.addSubview(imageContainerView)
        userInfoContainerView.addSubview(nameContainerView)
        
        imageContainerView.addSubview(avatarImageView)
        nameContainerView.addSubview(nameTextField)
        nameContainerView.addSubview(firstLineContainerView)
        nameContainerView.addSubview(parkingTextField)
        nameContainerView.addSubview(secondLineContainerView)
        nameContainerView.addSubview(carInfoTextField)
        
        NSLayoutConstraint.activate([
            menuContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12)
            ])
        
        NSLayoutConstraint.activate([
            titleTextView.centerYAnchor.constraint(equalTo: menuContainerView.centerYAnchor),
            titleTextView.centerXAnchor.constraint(equalTo: menuContainerView.centerXAnchor)
            ])
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: menuContainerView.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.95)
            ])
        
        NSLayoutConstraint.activate([
            userInfoContainerView.topAnchor.constraint(equalTo: menuContainerView.bottomAnchor, constant: -17),
            userInfoContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userInfoContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            userInfoContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15)
            ])
        
        NSLayoutConstraint.activate([
            imageContainerView.leadingAnchor.constraint(equalTo: userInfoContainerView.leadingAnchor),
            imageContainerView.centerYAnchor.constraint(equalTo: userInfoContainerView.centerYAnchor),
            imageContainerView.heightAnchor.constraint(equalTo: userInfoContainerView.heightAnchor, multiplier: 0.9),
            imageContainerView.widthAnchor.constraint(equalTo: imageContainerView.heightAnchor)
            ])
        
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            avatarImageView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 0.9),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor)
            ])
        
        NSLayoutConstraint.activate([
            nameContainerView.trailingAnchor.constraint(equalTo: userInfoContainerView.trailingAnchor),
            nameContainerView.leadingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            nameContainerView.centerYAnchor.constraint(equalTo: userInfoContainerView.centerYAnchor),
            nameContainerView.heightAnchor.constraint(equalTo: userInfoContainerView.heightAnchor)
            ])
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameContainerView.topAnchor),
            nameTextField.widthAnchor.constraint(equalTo: nameContainerView.widthAnchor, multiplier: 0.9),
            nameTextField.centerXAnchor.constraint(equalTo: nameContainerView.centerXAnchor),
            nameTextField.heightAnchor.constraint(equalTo: nameContainerView.heightAnchor, multiplier: 0.3233333333)
            ])
        
        NSLayoutConstraint.activate([
            firstLineContainerView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            firstLineContainerView.widthAnchor.constraint(equalTo: nameContainerView.widthAnchor, multiplier: 0.9),
            firstLineContainerView.centerXAnchor.constraint(equalTo: nameContainerView.centerXAnchor),
            firstLineContainerView.heightAnchor.constraint(equalTo: nameContainerView.heightAnchor, multiplier: 0.01)
            ])
        
        NSLayoutConstraint.activate([
            parkingTextField.topAnchor.constraint(equalTo: firstLineContainerView.bottomAnchor),
            parkingTextField.widthAnchor.constraint(equalTo: nameContainerView.widthAnchor, multiplier: 0.9),
            parkingTextField.centerXAnchor.constraint(equalTo: nameContainerView.centerXAnchor),
            parkingTextField.heightAnchor.constraint(equalTo: nameContainerView.heightAnchor, multiplier: 0.3233333333)
            ])
        
        NSLayoutConstraint.activate([
            secondLineContainerView.topAnchor.constraint(equalTo: parkingTextField.bottomAnchor),
            secondLineContainerView.widthAnchor.constraint(equalTo: nameContainerView.widthAnchor, multiplier: 0.9),
            secondLineContainerView.centerXAnchor.constraint(equalTo: nameContainerView.centerXAnchor),
            secondLineContainerView.heightAnchor.constraint(equalTo: nameContainerView.heightAnchor, multiplier: 0.01)
            ])
        
        NSLayoutConstraint.activate([
            carInfoTextField.topAnchor.constraint(equalTo: secondLineContainerView.bottomAnchor),
            carInfoTextField.widthAnchor.constraint(equalTo: nameContainerView.widthAnchor, multiplier: 0.9),
            carInfoTextField.centerXAnchor.constraint(equalTo: nameContainerView.centerXAnchor),
            carInfoTextField.heightAnchor.constraint(equalTo: nameContainerView.heightAnchor, multiplier: 0.3233333333)
            ])
        
        NSLayoutConstraint.activate([
            dropOffKeyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            dropOffKeyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dropOffKeyButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            dropOffKeyButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07)
            ])
        
        NSLayoutConstraint.activate([
            centerMapButton.bottomAnchor.constraint(equalTo: dropOffKeyButton.topAnchor, constant: -15),
            centerMapButton.trailingAnchor.constraint(equalTo: dropOffKeyButton.trailingAnchor, constant: -10),
            centerMapButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15),
            centerMapButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09)
            ])
        
        // iphone 5s,SE screen width 320
        // iphone 6,6s,7,etc width 375
        // iphone 7 plus, 8 plus, xs max,etc width 414
        
        if (view.frame.width == 320) {
            
            titleTextView.font = UIFont(name: "AvenirNext-Bold", size: 20)
            dropOffKeyButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 20)
            nameTextField.font = UIFont(name: "AvenirNext", size: 14)
            parkingTextField.font = UIFont(name: "AvenirNext", size: 14)
            
        } else if (view.frame.width == 375) {
            
            titleTextView.font = UIFont(name: "AvenirNext-Bold", size: 25)
            dropOffKeyButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 25)
            nameTextField.font = UIFont(name: "AvenirNext", size: 16)
            parkingTextField.font = UIFont(name: "AvenirNext", size: 16)
            
        } else if (view.frame.width == 414) {
            
            titleTextView.font = UIFont(name: "AvenirNext-Bold", size: 30)
            dropOffKeyButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 30)
            nameTextField.font = UIFont(name: "AvenirNext", size: 18)
            parkingTextField.font = UIFont(name: "AvenirNext", size: 18)
        }
    }
    
    func getUserInfo() {
        
        let databaseRef = Database.database().reference().child("ongoingRequests");
        databaseRef.observeSingleEvent(of: .value) { (DataSnapshot) in
            let key = DataSnapshot.children
            
            for case let rest as DataSnapshot in key {
                let snapshotValue = rest.value as! [String: String];
                
                let matchedValetID = snapshotValue["matchedValetID"]!;
                if matchedValetID == Auth.auth().currentUser!.uid {
                    
                    let userName = snapshotValue["name"]!
                    let carInfo = snapshotValue["carInfo"]!
                    let parkInPNR = snapshotValue["parkInPNR"]!
                    
                    self.nameTextField.text = userName
                    self.carInfoTextField.text = carInfo
                    
                    if (parkInPNR == "false"){
                        self.parkingTextField.text = "Garage"
                    }
                    else if (parkInPNR == "true"){
                        self.parkingTextField.text = "Park & Ride"
                    }
                    
                    let storage = Storage.storage()
                    var reference: StorageReference!
                    
                    //grab the image url from firebase
                    let profileUrl = snapshotValue["profileImageUrl"]!
                    reference = storage.reference(forURL: profileUrl)
                    
                    reference.downloadURL { (url, error) in
                        let data = NSData(contentsOf: url!)
                        let image = UIImage(data: data! as Data)
                        self.avatarImageView.image = image
                    }
                    
                    
                }
            }
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
    
    func createPolyline() {
        
        let sceLocation = CLLocationCoordinate2D(latitude: 37.338076, longitude: -121.882323)
        let valetLocation = CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
        
        let sceAnnotation = MKPointAnnotation()
        sceAnnotation.coordinate = sceLocation
        
        self.mapView.addAnnotation(sceAnnotation)
        
        let garagePlacemark = MKPlacemark(coordinate: sceLocation)
        let valetPlacemark = MKPlacemark(coordinate: valetLocation)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: valetPlacemark)
        directionRequest.destination = MKMapItem(placemark: garagePlacemark)
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResponse = response else {
                if let err = error {
                    print(err)
                }
                return
            }
            let route = directionResponse.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
        }
        self.mapView.delegate = self
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 3.0
        
        return renderer
    }
    
}



