//
//  ValetAnnotation.swift
//  autolayout
//
//  Created by Peter Hwang on 4/29/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import Foundation
import MapKit

class ValetAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var key: String?
    
    init(key: String, coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.key = key
        super.init()
    }
    
    func update(annotationPosition annotation: ValetAnnotation, withCoordinate coordinate: CLLocationCoordinate2D) {
        var location = self.coordinate
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        UIView.animate(withDuration: 0.2) {
            self.coordinate = location
        }
    }
}
