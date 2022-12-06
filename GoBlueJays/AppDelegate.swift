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
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // GMSPlacesClient.provideAPIKey("AIzaSyBFplEn_udrAH3qeqQR5DTfThprGEVSnbY")
        FirebaseApp.configure()
        
        // CLLocationManagerFactory.initialize()
        let locationManager = CLLocationManagerCreator.getLocationManager()
        locationManager.delegate = self
        
        //test
//        let db = Firestore.firestore()
//        var ref: DocumentReference? = nil
//        ref = db.collection("calendarCourse").addDocument(data: [
//            "courseName": "IP",
//            "prof": "Joanne",
//            "courseNum": "EN.510.220",
//            "date": "21/10/2022",
//            "location": "Maryland 310",
//            "startTime": 16,
//            "duration": 1.0,
//            "locationURL":"https://jhu-oose-f22.github.io/cs421/",
//            "gradescopeURL":"https://jhu-oose-f22.github.io/cs421/",
//            "webURL":"https://pl.cs.jhu.edu/fpse/dateline.html",
//            "syllabus":["40% - Assignments","60% - Project"]
//        ]) {
//            err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID:\(ref!.documentID)")
//            }
//        }
//        ref = db.collection("events").addDocument(data: [
//            "name": "OOSE",
//            "location": "Hodson 210"
//        ]) {
//            err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID:\(ref!.documentID)")
//            }
//        }
//        ref = db.collection("events").addDocument(data: [
//            "name": "Free lunch",
//            "location": "East gate"
//        ]) {
//            err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID:\(ref!.documentID)")
//            }
//        }
//
//        db.collection("events").getDocuments(){
//            (QuerySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in QuerySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                }
//            }
//        }

       
        
//        db.collection("calendarCourse").getDocuments(){
//            (QuerySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in QuerySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                }
//            }
//        }
        
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

