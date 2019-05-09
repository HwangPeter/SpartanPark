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

class UserParkingInProgressVC: UIViewController, CLLocationManagerDelegate {
    
    var valetID = ""
    var valetImage = UIImage()
    var valetName = ""
    
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
    
    let statusTextView: UITextView = {
        
        let myText = UITextView(frame: CGRect.zero, textContainer: nil)
        myText.text = "The valet is currently parking your car."
        myText.backgroundColor = nil
        myText.textColor = UIColor.white
        myText.font = UIFont.systemFont(ofSize: 20)
        //myText.textColor = UIColor(red: 229/255.0, green: 168/255.0, blue: 35/255.0, alpha: 1)
        myText.textAlignment = .center
        myText.isEditable = false
        myText.isScrollEnabled = false
        
        myText.translatesAutoresizingMaskIntoConstraints = false
        return myText
        
    }()
    
    lazy var valetProfilePicView: UIImageView = {
        let profile = UIImage(named: "noProfilePhoto")
        let profileView = UIImageView(image: profile)
        let viewSize = self.view.frame.height * 0.15
        profileView.contentMode = .scaleAspectFit
        profileView.clipsToBounds = true
        profileView.frame = CGRect(x: 0, y: 0, width: viewSize, height: viewSize)
        profileView.layer.borderWidth = 3
        profileView.layer.borderColor = UIColor(red: 0/255.0, green: 85/255.0, blue: 162/255.0, alpha: 0.65).cgColor
        profileView.layer.cornerRadius = view.frame.width/8
        profileView.translatesAutoresizingMaskIntoConstraints = false
        return profileView
    }()
    
    lazy var valetNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "Loading valet information..."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        initializeMapView(){
            self.setupValetProfilePic(self.valetID) {
                self.showAndUpdateValetAnnotation()
                self.chargeUser()
                
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func initializeMapView(finished: @escaping () -> Void) {
        
        let regionRadius: CLLocationDistance = 500
        let coordinateRegion = MKCoordinateRegion(center: CLLocation(
            latitude: 37.3352, longitude: -121.8811).coordinate,
                                                  latitudinalMeters: regionRadius * 3.0,
                                                  longitudinalMeters: regionRadius * 3.0)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.delegate = self
        finished()
    }
    
    private func setupLayout() {
        view.backgroundColor = UIColor(red: 39/225.0, green: 74/225.0, blue: 110/225.0, alpha: 1)
        
        view.addSubview(centerContainerView)
        centerContainerView.addSubview(mapView)
        
        view.addSubview(statusTextView)
        view.addSubview(nameTextView)
        view.addSubview(valetProfilePicView)
        view.addSubview(valetNameLabel)
        
        NSLayoutConstraint.activate([
            nameTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nameTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nameTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
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
            statusTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5),
            statusTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            statusTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06)
            ])
        
        NSLayoutConstraint.activate([
            valetProfilePicView.topAnchor.constraint(equalTo: centerContainerView.bottomAnchor, constant: 5),
            valetProfilePicView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            valetProfilePicView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            valetProfilePicView.heightAnchor.constraint(equalTo: valetProfilePicView.widthAnchor)
            ])
        
        NSLayoutConstraint.activate([
            valetNameLabel.topAnchor.constraint(equalTo: valetProfilePicView.bottomAnchor),
            valetNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            valetNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
            ])
        
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
    
    fileprivate func setupValetProfilePic(_ valetID: String, finished: @escaping () -> Void) {
        self.valetProfilePicView.layer.cornerRadius = view.frame.width/8
        if self.valetName == "" {
            fetchProfilePhoto(uid: valetID, completion: { image, name in
                if let image = image {
                    //                let viewSize = self.view.frame.height * 0.08
                    //                self.valetProfilePicView.frame = CGRect(x: 15, y: self.view.frame.height-self.view.frame.height/3, width: viewSize, height: viewSize)
                    self.valetProfilePicView.image = image
                    self.valetNameLabel.text = name
                    finished()
                }
            })
        }
        else {
            self.valetProfilePicView.image = self.valetImage
            self.valetNameLabel.text = self.valetName
            finished()
        }
    }
    
    func chargeUser() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(valetID).child("stripeId").observeSingleEvent(of: .value) { (snapshot) in
            let valetStripeId = snapshot.value as! String? ?? ""
            Database.database().reference().child("ongoingRequests").child(uid!).updateChildValues(["payout": valetStripeId])
        }
    }
    
    func showAndUpdateValetAnnotation() {
        let uid = Auth.auth().currentUser?.uid
        let userDatabase = Database.database().reference().child("ongoingRequests").child(uid!)
        let regionRadius: CLLocationDistance = 500
        
        
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
                                        let coordinateRegion = MKCoordinateRegion(center: CLLocation(
                                            latitude: valetCoords.latitude, longitude: valetCoords.longitude).coordinate,
                                                                                  latitudinalMeters: regionRadius * 2.5,
                                                                                  longitudinalMeters: regionRadius * 2.5)
                                        self.mapView.setRegion(coordinateRegion, animated: true)
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

extension UserParkingInProgressVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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
            
        else {
            return nil
            
        }
    }
    
}
