//
//  UpdateLocationService.swift
//  autolayout
//
//  Created by Peter Hwang on 4/26/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import MapKit

class updateLocationService {
    static var instance = updateLocationService()
    
    func updateUserLocation(withCoordinate coordinate: CLLocationCoordinate2D) {
        Database.database().reference().child("ongoingRequests").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild((Auth.auth().currentUser?.uid)!) {
                Database.database().reference().child("ongoingRequests").child(Auth.auth().currentUser!.uid).updateChildValues(["userLatitude": String(coordinate.latitude), "userLongitude":  String(coordinate.longitude)])
            }
        })
    }
    
}
