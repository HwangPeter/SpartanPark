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

class ValetDirectionToPNRViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var locationLatitude = Double()
    var locationLongitude = Double()
    
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
        let attributedString1 = NSMutableAttributedString(string:"PARKING", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:"DIRECTION", attributes:attrs2)
        
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
        let avatar = UIImage(named: "car")
        let avatarView = UIImageView(image: avatar)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        
        //userInfoContainerView is constraint 90% to view width
        //imageContainerView is constraint 36% to userInfoContainerView
        //the image is constraint 90% to imageContainerView
        let myRadius = (screenWidth * 0.9 * 0.30 * 0.9)/2.0
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
        textField.placeholder = "Parking spot number: G225, B10, .."
        textField.borderStyle = UITextField.BorderStyle.none
        textField.backgroundColor = UIColor.white
        textField.textColor = UIColor(red: 57/255.0, green: 57/255.0, blue: 57/255.0, alpha: 1)
        textField.textAlignment = .left

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
    
    let gotKeyButton: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.backgroundColor = .white
        button.setTitle("PARKED IN P&R", for: .normal)
        button.setTitleColor(UIColor(red: 57/255.0, green: 57/255.0, blue: 57/255.0, alpha: 1), for: .normal)
        
        button.layer.cornerRadius = 5.0
        button.layer.shadowOpacity = 0.4
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 6.0
        
        button.showsTouchWhenHighlighted = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(parkedPNRClicked), for: .touchUpInside)
        return button
    }()
    
//    @objc func parkedPNRClicked() {
//        print("Parked PNR Clicked")
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
//                        database.updateChildValues(["status3": "isDroppingOffKey"])
//
//                        self.dismiss(animated: true, completion: nil)
//
//                }
//            }
//        }
//    }
    
    @objc func parkedPNRClicked() {
        print("p&r parked Clicked")
        
        if(parkingTextField.text == ""){
            handleEmptyDestination()
        }
        else{
        
            let databaseRef = Database.database().reference().child("ongoingRequests");
            databaseRef.observeSingleEvent(of: .value) { (DataSnapshot) in
                let key = DataSnapshot.children
                
                for case let rest as DataSnapshot in key {
                    let snapshotValue = rest.value as! [String: String];
                    
                    let matchedValetID = snapshotValue["matchedValetID"]!;
                    if matchedValetID == Auth.auth().currentUser!.uid {
                        
                        let userID = rest.key;
                        let database = Database.database().reference().child("ongoingRequests").child(userID)
                        database.updateChildValues(["parkingLot": "\(String(describing: self.parkingTextField.text!)), Park N Ride", "status": "DroppingOffKey"])
                        
                        self.present(ValetDirectionToSCEViewController(), animated: true, completion: nil)
                        
                        //self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func handleEmptyDestination() {
        let errorAlertVC = UIAlertController(title: "Error", message: "Please select an area to meet up by selecting any spartan pin on the map.", preferredStyle: .alert)
        let errorAlertActionOkay = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        errorAlertVC.addAction(errorAlertActionOkay)
        self.present(errorAlertVC, animated: true, completion: nil)
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
        self.hideKeyboardWhenTappedAround() 
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        getDirectionsToPnR()
        getUserInfo()
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
        
        view.addSubview(gotKeyButton)
        
        view.bringSubviewToFront(menuContainerView)
        view.bringSubviewToFront(userInfoContainerView)
        
        menuContainerView.addSubview(titleTextView)
        userInfoContainerView.addSubview(imageContainerView)
        userInfoContainerView.addSubview(nameContainerView)
        
        imageContainerView.addSubview(avatarImageView)
        nameContainerView.addSubview(nameTextField)
        nameContainerView.addSubview(firstLineContainerView)
        nameContainerView.addSubview(parkingTextField)
        
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
            userInfoContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.11)
            ])
        
        NSLayoutConstraint.activate([
            imageContainerView.leadingAnchor.constraint(equalTo: userInfoContainerView.leadingAnchor),
            imageContainerView.centerYAnchor.constraint(equalTo: userInfoContainerView.centerYAnchor),
            imageContainerView.widthAnchor.constraint(equalTo: userInfoContainerView.widthAnchor, multiplier: 0.36),
            imageContainerView.heightAnchor.constraint(equalTo: userInfoContainerView.heightAnchor)
            ])
        
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor, multiplier: 0.9),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor)
            ])
        
        NSLayoutConstraint.activate([
            nameContainerView.trailingAnchor.constraint(equalTo: userInfoContainerView.trailingAnchor),
            nameContainerView.centerYAnchor.constraint(equalTo: userInfoContainerView.centerYAnchor),
            nameContainerView.widthAnchor.constraint(equalTo: userInfoContainerView.widthAnchor, multiplier: 0.64),
            nameContainerView.heightAnchor.constraint(equalTo: userInfoContainerView.heightAnchor)
            ])
        
        NSLayoutConstraint.activate([
            firstLineContainerView.centerYAnchor.constraint(equalTo: nameContainerView.centerYAnchor),
            firstLineContainerView.widthAnchor.constraint(equalTo: nameContainerView.widthAnchor, multiplier: 0.9),
            firstLineContainerView.centerXAnchor.constraint(equalTo: nameContainerView.centerXAnchor),
            firstLineContainerView.heightAnchor.constraint(equalTo: nameContainerView.heightAnchor, multiplier: 0.01)
            ])
        
        NSLayoutConstraint.activate([
            nameTextField.bottomAnchor.constraint(equalTo: firstLineContainerView.topAnchor),
            nameTextField.widthAnchor.constraint(equalTo: nameContainerView.widthAnchor, multiplier: 0.9),
            nameTextField.centerXAnchor.constraint(equalTo: nameContainerView.centerXAnchor),
            nameTextField.heightAnchor.constraint(equalTo: nameContainerView.heightAnchor, multiplier: 0.47)
            ])
        
        NSLayoutConstraint.activate([
            parkingTextField.topAnchor.constraint(equalTo: firstLineContainerView.bottomAnchor),
            parkingTextField.widthAnchor.constraint(equalTo: nameContainerView.widthAnchor, multiplier: 0.9),
            parkingTextField.centerXAnchor.constraint(equalTo: nameContainerView.centerXAnchor),
            parkingTextField.heightAnchor.constraint(equalTo: nameContainerView.heightAnchor, multiplier: 0.47)
            ])
        
        NSLayoutConstraint.activate([
            gotKeyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            gotKeyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gotKeyButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            gotKeyButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07)
            ])
        
        NSLayoutConstraint.activate([
            centerMapButton.bottomAnchor.constraint(equalTo: gotKeyButton.topAnchor, constant: -15),
            centerMapButton.trailingAnchor.constraint(equalTo: gotKeyButton.trailingAnchor, constant: -10),
            centerMapButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15),
            centerMapButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09)
            ])
        
        // iphone 5s,SE screen width 320
        // iphone 6,6s,7,etc width 375
        // iphone 7 plus, 8 plus, xs max,etc width 414
        
        if (view.frame.width == 320) {
            
            titleTextView.font = UIFont(name: "AvenirNext-Bold", size: 20)
            gotKeyButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 20)
            nameTextField.font = UIFont(name: "AvenirNext", size: 14)
            //parkingTextField.font = UIFont(name: "AvenirNext", size: 14)
            parkingTextField.attributedPlaceholder = NSAttributedString(string: "Spot number: G225, B10, ..", attributes: [
                .foregroundColor: UIColor.lightGray,
                .font: UIFont.boldSystemFont(ofSize: 12.0)])
            
        } else if (view.frame.width == 375) {
            
            titleTextView.font = UIFont(name: "AvenirNext-Bold", size: 25)
            gotKeyButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 25)
            nameTextField.font = UIFont(name: "AvenirNext", size: 16)
            //parkingTextField.font = UIFont(name: "AvenirNext", size: 16)
            parkingTextField.attributedPlaceholder = NSAttributedString(string: "Spot number: G225, B10, ..", attributes: [
                .foregroundColor: UIColor.lightGray,
                .font: UIFont.boldSystemFont(ofSize: 14.0)])
            
        } else if (view.frame.width == 414) {
            
            titleTextView.font = UIFont(name: "AvenirNext-Bold", size: 30)
            gotKeyButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 30)
            nameTextField.font = UIFont(name: "AvenirNext", size: 18)
            //parkingTextField.font = UIFont(name: "AvenirNext", size: 18)
            parkingTextField.attributedPlaceholder = NSAttributedString(string: "Spot number: G225, B10, ..", attributes: [
                .foregroundColor: UIColor.lightGray,
                .font: UIFont.boldSystemFont(ofSize: 16.0)])
            
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        self.locationLatitude = location.coordinate.latitude
        self.locationLongitude = location.coordinate.longitude
        
        self.mapView.removeOverlays(self.mapView.overlays)
        getDirectionsToPnR()
    }
    
    func getDirectionsToPnR() {
        let pnrLocation = CLLocationCoordinate2D(latitude: 37.319006, longitude: -121.869740)
        let valetLocation = CLLocationCoordinate2D(latitude: self.locationLatitude, longitude: self.locationLongitude)
        
        let pnrAnnotation = MKPointAnnotation()
        pnrAnnotation.coordinate = pnrLocation
        
        self.mapView.addAnnotation(pnrAnnotation)
        
        let pnrPlacemark = MKPlacemark(coordinate: pnrLocation)
        let valetPlacemark = MKPlacemark(coordinate: valetLocation)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: valetPlacemark)
        directionRequest.destination = MKMapItem(placemark: pnrPlacemark)
        directionRequest.transportType = .automobile
        
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
    
    func getUserInfo() {
        let databaseRef = Database.database().reference().child("ongoingRequests")
        databaseRef.observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            let key = snapshot.children
            
            for case let rest as DataSnapshot in key {
                let snapshotValue = rest.value as! [String: String]
                
                let name = snapshotValue["name"]!
                
                self.nameTextField.text = name
            }
        }
    }
    
    //    func fetchProfilePhoto () {
    //
    //        let storage = Storage.storage()
    //        var reference: StorageReference!
    //        let uid = Auth.auth().currentUser?.uid
    //
    //        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
    //
    //            //user model has name, email, and profileImageUrl, etc stored in database
    //            //fetch anything stored in the database in this if statement
    //            if let dictionary = snapshot.value as? [String: AnyObject] {
    //
    //                //grab the image url from firebase
    //                let profileUrl = dictionary["profileImageUrl"] as? String
    //                reference = storage.reference(forURL: profileUrl!)
    //
    //                reference.downloadURL { (url, error) in
    //                    let data = NSData(contentsOf: url!)
    //                    let image = UIImage(data: data! as Data)
    //                    self.profileImage.image = image
    //                }
    //            }
    //
    //        }, withCancel: nil)
    //    }
}



