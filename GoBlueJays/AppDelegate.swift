//
//  AppDelegate.swift
//  GoBlueJays
//
//  Created by Jessie Luo on 8/6/22.
//

import UIKit
//import GooglePlaces
import FirebaseCore
import FirebaseFirestore
import CoreLocation;

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // GMSPlacesClient.provideAPIKey("AIzaSyBFplEn_udrAH3qeqQR5DTfThprGEVSnbY")
        FirebaseApp.configure()
        
        // CLLocationManagerFactory.initialize()
        let locationManager = CLLocationManagerCreator.getLocationManager()
        locationManager.delegate = self
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

