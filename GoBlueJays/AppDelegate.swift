//
//  AppDelegate.swift
//  GoBlueJays
//
//  Created by Jessie Luo on 8/6/22.
//

import UIKit
import GooglePlaces
import RealmSwift


let configuration = AppConfiguration(
   baseURL: "https://realm.mongodb.com", // Custom base URL
   transport: nil, // Custom RLMNetworkTransportProtocol
   localAppName: "GoBlueJays",
   localAppVersion: nil,
   defaultRequestTimeoutMS: 30000
)
let app = App(id: "gobluejays-czowp", configuration: configuration)

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey("AIzaSyBFplEn_udrAH3qeqQR5DTfThprGEVSnbY")
        // test
        app.login(credentials: Credentials.anonymous) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("Login failed: \(error)")
                case .success(let user):
                    print("Login as \(user) succeeded!")
                }
            }
            let client = app.currentUser!.mongoClient("GoBlueJays")
            let database = client.database(named:"ios")
            let collection = database.collection(withName: "events")
            
            let event: Document = [
                "name": "OOSE",
                "location": "Hodson 210"
            ]
            collection.insertOne(event) {result in
                switch result {
                case .failure(let error):
                    print("Call to mongodb Failed")
                    return
                case .success(let objectIds):
                    print("Successfully inserted 1 object")
                }
            }
            
        }
        
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

