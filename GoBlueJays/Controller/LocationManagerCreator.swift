//
//  LocationManagerCreator.swift
//  GoBlueJays
//
//  Created by Murphy Cheng on 2022/10/26.
//

import Foundation
import CoreLocation

class CLLocationManagerCreator {
    
    static var locationManager: CLLocationManager = CLLocationManager()
    
    static func getLocationManager() -> CLLocationManager {
        return self.locationManager;
    }
}
