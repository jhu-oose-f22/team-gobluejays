//
//  LocationManager.swift
//  GoBlueJays
//
//  Created by 罗佳欣 on 12/4/22.
//
import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager ()
    
    let manager = CLLocationManager()
    
    var completion: ((CLLocation) -> Void)?
    
    public func getUserLocation (completion: @escaping ((CLLocation) -> Void)) {
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:
    [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        completion?(location)
        manager.stopUpdatingLocation()
    }
}
