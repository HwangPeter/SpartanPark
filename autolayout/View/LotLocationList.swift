//
//  File.swift
//  autolayout
//
//  Created by Peter Hwang on 4/21/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//
import UIKit

class LotLocationList: NSObject {
    var lot = [LotLocations]()
    override init(){
        lot += [LotLocations(name:"South Parking Garage",lat:37.333432,long:-121.879982)]
        lot += [LotLocations(name:"West Parking Garage",lat:37.332324,long: -121.882912 )]
        lot += [LotLocations(name:"Lot 4",lat:37.337764,long: -121.879425 )]
        lot += [LotLocations(name:"Clark Hall/Engineering Lot",lat:37.337132,long:-121.882696  )]
        lot += [LotLocations(name:"North Parking Garage",lat:37.339322,long:-121.880714  )]
    }
}
