//
//  activity_load.swift
//  GoBlueJays
//
//  Created by 刘忻岩 on 10/18/22.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class activity_load {
    init() {}
    
    static func load_all() -> [Activity] {
        var activities: [Activity] = []
        let db = Firestore.firestore()
        db.collection("activity").getDocuments(){
            (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in QuerySnapshot!.documents {
                    let data = document.data()
                    let act:Activity = Activity(title: data["title"] as! String,
                                                time: data["time"] as! String,
                                                location: data["location"] as! String,
                                                image: data["image"] as! String,
                                                likes: data["likes"] as! Bool,
                                                id: document.documentID)
//                    print("reading document")
//                    print(act)
                    activities.append(act)
                    print("loading")
//                    print(activities)
                }
            }
            print("load all docs")
            print(activities)
        }
        return activities
    }
    
}
