//
//  LotLocations.swift
//  autolayout
//
//  Created by Peter Hwang on 4/21/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class LotLocations: NSObject, MKAnnotation {
    var identifier = "lot location"
    var title: String?
    var coordinate: CLLocationCoordinate2D
    init(name:String, lat:CLLocationDegrees, long:CLLocationDegrees) {
        title = name
        coordinate = CLLocationCoordinate2DMake(lat, long)
    }
}
