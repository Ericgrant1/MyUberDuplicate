//
//  DriverAnnotation.swift
//  MyUberDuplicate
//
//  Created by Eric Grant on 27.04.2020.
//  Copyright © 2020 Eric Grant. All rights reserved.
//

import MapKit

class DriverAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var uid: String
    
    init(uid: String, coordinate: CLLocationCoordinate2D) {
        self.uid = uid
        self.coordinate = coordinate
    }
}

