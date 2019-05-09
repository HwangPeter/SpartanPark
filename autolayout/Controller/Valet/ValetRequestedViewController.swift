//
//  ValetRequestedViewController.swift
//  autolayout
//
//  Created by Hun Zaw on 4/24/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class ValetRequestedViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let lots = LotLocationList().lot
    
    var prevVC: ValetViewController!
    
    var userID = String()
    
    let cancelButtonContainerView = containerView()
    //let cancelButton = buttonContainerEmpty(mytext: "Cancel", myColor: UIColor.white)
    
    let cancelButton: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.backgroundColor = nil
        button.setImage(UIImage(named: "back-button3"), for: .normal)
        button.showsTouchWhenHighlighted = true
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nameTextView: UITextView = {
        
        let myText = UITextView(frame: CGRect.zero, textContainer: nil)
        myText.text = "SPARTAN PARK"
        myText.backgroundColor = nil
        myText.textColor = UIColor.white
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
    
    let centerContainerView: UIView = {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        view.backgroundColor = UIColor.white
        
        //auto constraints in set up using 80% of screen width to make a square
        let myRadius = (0.84 * screenWidth)/2
        
        view.layer.cornerRadius = myRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let mapView: MKMapView = {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let maps = MKMapView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        
        let myRadius = (0.8 * screenWidth)/2
        maps.layer.cornerRadius = myRadius
        maps.clipsToBounds = true
        maps.translatesAutoresizingMaskIntoConstraints = false
        return maps
    }()
    
    let driveTextView: UITextView = {
        
        let myText = UITextView(frame: CGRect.zero, textContainer: nil)
        myText.text = "Would you like to meet up in this location?"
        myText.backgroundColor = nil
        myText.textColor = UIColor.white
        //myText.textColor = UIColor(red: 229/255.0, green: 168/255.0, blue: 35/255.0, alpha: 1)
        myText.textAlignment = .center
        myText.isEditable = false
        myText.isScrollEnabled = false
        
        myText.translatesAutoresizingMaskIntoConstraints = false
        return myText
        
    }()
    
    let acceptValetButton: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.backgroundColor = .white
        button.setTitle("ACCEPT TO VALET", for: .normal)
        button.setTitleColor(UIColor(red: 39/225.0, green: 74/225.0, blue: 110/225.0, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(acceptButtonClicked), for: .touchUpInside)
        
        button.layer.cornerRadius = 5.0
        button.layer.shadowOpacity = 0.4
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 6.0
        
        button.showsTouchWhenHighlighted = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 39/225.0, green: 74/225.0, blue: 110/225.0, alpha: 1)
        setupLayout()
        self.hideKeyboardWhenTappedAround() 
        //initializeMapView()
        // Do any additional setup after loading the view.
        
//        locationManager.delegate = self
//        //locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
//        mapView.showsUserLocation = true
        
        killPreviousObserver()
        
        self.mapView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUserRequestedValetLocation()
    }
    
    func killPreviousObserver() {
        Database.database().reference().child("ongoingRequests").removeAllObservers()
    }
    
    func getUserRequestedValetLocation() {
        
        let databaseRef = Database.database().reference().child("ongoingRequests")
        databaseRef.observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            let key = snapshot.children
            
            for case let rest as DataSnapshot in key {
                let snapshotValue = rest.value as! [String: String]
                
                let matchedValetID = snapshotValue["matchedValetID"]!
                
                if (matchedValetID == Auth.auth().currentUser?.uid) {
                    let meetupLot = snapshotValue["meetupLot"]!
                    
                    for lot in self.lots {
                        if (lot.title! == meetupLot) {
                            let lotLatitude = lot.coordinate.latitude
                            let lotLongitude = lot.coordinate.longitude
                            
                            let lotLocation = CLLocationCoordinate2D(latitude: lotLatitude, longitude: lotLongitude)
                            
                            let region = MKCoordinateRegion(center: lotLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
                            self.mapView.setRegion(region, animated: true)
                            
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = lotLocation
                            
                            self.mapView.addAnnotation(annotation)
                        }
                    }
                }
            }
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//
//        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), latitudinalMeters: 1000, longitudinalMeters: 1000)
//        self.mapView.setRegion(region, animated: true)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
//    }
    
    func initializeMapView() {
        
        let regionRadius: CLLocationDistance = 500
        let coordinateRegion = MKCoordinateRegion(center: CLLocation(
            latitude: 37.3352, longitude: -121.8811).coordinate,
                                                  latitudinalMeters: regionRadius * 2.0,
                                                  longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    private func setupLayout() {
        
        view.addSubview(cancelButtonContainerView)
        cancelButtonContainerView.addSubview(cancelButton)
        cancelButtonContainerView.addSubview(nameTextView)
        
        view.addSubview(centerContainerView)
        centerContainerView.addSubview(mapView)
        
        view.addSubview(driveTextView)
        view.addSubview(acceptValetButton)
        
        NSLayoutConstraint.activate([
            cancelButtonContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cancelButtonContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cancelButtonContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cancelButtonContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
            ])
        
        NSLayoutConstraint.activate([
            cancelButton.centerYAnchor.constraint(equalTo: cancelButtonContainerView.centerYAnchor),
            cancelButton.leftAnchor.constraint(equalTo: cancelButtonContainerView.leftAnchor),
            cancelButton.widthAnchor.constraint(equalTo: cancelButtonContainerView.widthAnchor, multiplier: 0.15),
            cancelButton.heightAnchor.constraint(equalTo: cancelButtonContainerView.heightAnchor, multiplier: 0.6)
            ])
        
        NSLayoutConstraint.activate([
            nameTextView.centerXAnchor.constraint(equalTo: cancelButtonContainerView.centerXAnchor),
            nameTextView.centerYAnchor.constraint(equalTo: cancelButtonContainerView.centerYAnchor)
            ])
        
        NSLayoutConstraint.activate([
            centerContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.84),
            centerContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            centerContainerView.heightAnchor.constraint(equalTo: centerContainerView.widthAnchor)
            ])
        
        NSLayoutConstraint.activate([
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80),
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mapView.heightAnchor.constraint(equalTo: mapView.widthAnchor)
            ])
        
        NSLayoutConstraint.activate([
            acceptValetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            acceptValetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            acceptValetButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            acceptValetButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07)
            ])
        
        NSLayoutConstraint.activate([
            driveTextView.bottomAnchor.constraint(equalTo: acceptValetButton.topAnchor),
            driveTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            driveTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            driveTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06)
            ])
        
        // iphone 5s,SE screen width 320
        // iphone 6,6s,7,etc width 375
        // iphone 7 plus, 8 plus, xs max,etc width 414
        if (view.frame.width == 320) {
            
            let font_320 = UIFont.systemFont(ofSize: 14)
            acceptValetButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 20)
            nameTextView.font = UIFont(name: "AvenirNext-heavy", size: 20)
            driveTextView.font = font_320
            
        } else if (view.frame.width == 375) {
            
            let font_375 = UIFont.systemFont(ofSize: 16)
            acceptValetButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 25)
            nameTextView.font = UIFont(name: "AvenirNext-heavy", size: 25)
            driveTextView.font = font_375
            
        } else if (view.frame.width == 414) {
            
            let font_414 = UIFont.systemFont(ofSize: 18)
            acceptValetButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 30)
            nameTextView.font = UIFont(name: "AvenirNext-heavy", size: 30)
            driveTextView.font = font_414
        }
    }
    
    @objc func cancelButtonClicked() {
        print("Cancel Clicked")
        
        let databaseRef = Database.database().reference().child("ongoingRequests");
        databaseRef.observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            let key = snapshot.children;
            
            for case let rest as DataSnapshot in key {
                let snapshotValue = rest.value as! [String: String];
                
                //let requestisAccepted = snapshotValue["requestIsAccepted"]!;
                let matchedValetID = snapshotValue["matchedValetID"]!;
                
                //print(requestisAccepted, matchedValetID);
                if (matchedValetID == Auth.auth().currentUser?.uid) {
                    let userID = rest.key;
                    
                    let database = Database.database().reference().child("ongoingRequests").child(userID)
                    database.updateChildValues(["matchedValetID": "", "canceledValetID": (Auth.auth().currentUser?.uid)!])
                    
                    self.dismiss(animated: true, completion: nil)
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    //                        // Code you want to be delayed
                    //                        self.dismiss(animated: true, completion: nil)
                    //                    }
                    
                }
            }
        
        
        }
    }
    
    @objc func acceptButtonClicked() {
        print("Accept Clicked")
        
        let databaseRef = Database.database().reference().child("ongoingRequests");
        databaseRef.observeSingleEvent(of: .value) { (DataSnapshot) in
            let key = DataSnapshot.children
            
            for case let rest as DataSnapshot in key {
                let snapshotValue = rest.value as! [String: String];
                
                let matchedValetID = snapshotValue["matchedValetID"]!;
                if matchedValetID == Auth.auth().currentUser!.uid {
                    
                    let userID = rest.key;
                    let database = Database.database().reference().child("ongoingRequests").child(userID)
                    database.updateChildValues(["requestIsAccepted": "true", "status": "requestAccepted"])
                    
                    //self.dismiss(animated: true, completion: nil)
                    self.present(ValetDirectionToUserViewController(), animated: true, completion: nil)
//
//                    , "valetLatitude": "\(self.locationManager.location?.coordinate.latitude ?? 0)", "valetLongitude": "\(self.locationManager.location?.coordinate.longitude ?? 0)"
        
                    //self.prevVC.dismiss(animated: false, completion: nil)

                }
            }
        }
    }
}
