//
//  ActivityVC.swift
//  GoBlueJays
//
//  Created by 刘忻岩 on 10/7/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import CoreLocation

protocol activityTableDelegate: AnyObject {
    func cellButtonPressed(actID: String)
}

class ActivityVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, activityTableDelegate {

    @IBOutlet weak var PageView: UIPageControl!
    @IBOutlet weak var recomCollection: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var timer = Timer()
    var counter = 0
    
    var activities: [Activity] = []
    var filteredActivities: [Activity] = []
    var recact: [Activity] = [
        Activity(title: "Activity 1", time: "October 20 2022", location: "Malone Hall 201", image:"athletics", likes:false, id:"act001"),
        Activity(title: "Activity 2", time: "October 21 2022", location: "Malone Hall 202", image:"academics", likes:false, id:"act002"),
        Activity(title: "Activity 3", time: "October 22 2022", location: "Malone Hall 203", image:"housing", likes:false, id:"act003"),
//        Activity(title: "Activity 4", time: "October 23 2022", location: "Malone Hall 204", image:"frontpage", likes:false),
//        Activity(title: "Activity 5", time: "October 24 2022", location: "Malone Hall 205", image:"Nolans", likes:false),
//        Activity(title: "Activity 6", time: "October 25 2022", location: "Malone Hall 206", image:"social media", likes:false),
//        Activity(title: "Activity 7", time: "October 26 2022", location: "Malone Hall 207", image:"social media", likes:false),
    ]
    
    var recommendActivities: [Activity] = []
    var sortedActivites: [Activity] = []
    
    var buildingLocations: [BuildingLocation] = []
    var latitude: CLLocationDegrees = 0.0;
    var longitude: CLLocationDegrees = 0.0;
    let activityRecommend: Int = 5;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Explore"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName:"ActivityCell", bundle: .main), forCellReuseIdentifier: "ActivityCell")
        tableView.separatorStyle = .none

        searchBar.delegate = self
        
        recomCollection.delegate = self
        recomCollection.dataSource = self
        PageView.numberOfPages = recact.count
        PageView.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.recChange), userInfo: nil, repeats: true)
        }
        
        let db = Firestore.firestore()
        db.collection("activity").getDocuments(){ [self]
            (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in QuerySnapshot!.documents {
                    let data = document.data()
                    print(data)
                    let act:Activity = Activity(title: data["title"] as! String,
                                                time: data["time"] as! String,
                                                location: data["location"] as! String,
                                                image: data["image"] as! String,
                                                likes: data["likes"] as! Bool,
                                                id: document.documentID)
                    self.activities.append(act)
                }
            }
            filteredActivities = activities
            print("reload")
            self.reloadData()
        }
        
        // hard-code building locations
        buildingLocations = [
            BuildingLocation(name: "hodson hall", location: CLLocationCoordinate2D(latitude: 39.32749022560959, longitude: -76.62227881124888)),
            BuildingLocation(name: "hackerman hall", location: CLLocationCoordinate2D(latitude: 39.32691271415686, longitude: -76.62090191636538)),
            BuildingLocation(name: "malone hall", location: CLLocationCoordinate2D(latitude: 39.32623759589481, longitude: -76.62080273393454)),
            BuildingLocation(name: "maryland hall", location: CLLocationCoordinate2D(latitude: 39.328045703864206, longitude: -76.6198668018716)),
            BuildingLocation(name: "levering hall", location: CLLocationCoordinate2D(latitude: 39.32809140048764, longitude: -76.62189940022438)),
            BuildingLocation(name: "krieger hall", location: CLLocationCoordinate2D(latitude: 39.32865204939853, longitude: -76.6199681981623)),
            BuildingLocation(name: "wyman park building", location: CLLocationCoordinate2D(latitude: 39.32517737353952, longitude: -76.62289381377747)),
            BuildingLocation(name: "clark hall", location: CLLocationCoordinate2D(latitude: 39.32693374517105, longitude: -76.62225083148367)),
            BuildingLocation(name: "latrobe hall", location: CLLocationCoordinate2D(latitude: 39.32789328034753, longitude: -76.62075340116824)),
            BuildingLocation(name: "croft hall", location: CLLocationCoordinate2D(latitude: 39.32733683893719, longitude: -76.61957309112006)),
            BuildingLocation(name: "mason hall", location: CLLocationCoordinate2D(latitude: 39.325861985523076, longitude: -76.62151281118587)),
            BuildingLocation(name: "shiver hall", location: CLLocationCoordinate2D(latitude: 39.32642389924464, longitude:  -76.62025109761828)),
            BuildingLocation(name: "gilman hall", location: CLLocationCoordinate2D(latitude: 39.32893189373731, longitude: -76.62157898877807)),
            BuildingLocation(name: "mergenthaler hall", location: CLLocationCoordinate2D(latitude: 39.329652795301435, longitude: -76.62063640452014)),
            BuildingLocation(name: "remsen hall", location: CLLocationCoordinate2D(latitude: 39.32953968324859, longitude: -76.62002418197157)),
            BuildingLocation(name: "mudd hall", location: CLLocationCoordinate2D(latitude: 39.33096989515415, longitude: -76.62054267311402)),
            BuildingLocation(name: "macaulay hall", location: CLLocationCoordinate2D(latitude: 39.33021214342024, longitude: -76.62078368915385)),
            BuildingLocation(name: "dunning hall", location: CLLocationCoordinate2D(latitude: 39.33027356644766, longitude: -76.62001903445636)),
            BuildingLocation(name: "wyman quad", location: CLLocationCoordinate2D(latitude: 39.327531421428056, longitude: -76.62036598718512)),
            BuildingLocation(name: "decker quad", location: CLLocationCoordinate2D(latitude: 39.32650901050207, longitude: -76.6215549382646)),
            BuildingLocation(name: "milton s eisenhower library", location: CLLocationCoordinate2D(latitude: 39.32916209697434, longitude: -76.61924558793446)),
            BuildingLocation(name: "imagine center", location: CLLocationCoordinate2D(latitude: 39.334745943668445, longitude: -76.62137203136315)),
            BuildingLocation(name: "homewood field", location: CLLocationCoordinate2D(latitude: 39.33357420852676, longitude: -76.62079601541275)),
            BuildingLocation(name: "homewood museum", location: CLLocationCoordinate2D(latitude: 39.32987674911344, longitude: -76.61893090882971)),
            BuildingLocation(name: "hopkins cafe", location: CLLocationCoordinate2D(latitude: 39.331613285972054, longitude: -76.61963798082502)),
            BuildingLocation(name: "bloomberg center for physics and astronomy", location: CLLocationCoordinate2D(latitude: 39.33391493367228, longitude: -76.62396509512084)),
            BuildingLocation(name: "freshman quad", location: CLLocationCoordinate2D(latitude: 39.33071041942408, longitude: -76.61942234313949)),
            BuildingLocation(name: "the beach", location: CLLocationCoordinate2D(latitude: 39.32900089341375, longitude: -76.61837410006774))
        ]
        activity_recommendation()
        print(sortedActivites)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (filteredActivities.count % 2 == 0){
            return filteredActivities.count/2
        } else {
            return filteredActivities.count/2 + 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ActivityCell", for:indexPath) as! ActivityCell
        cell.delegate = self
        
        let ind1 = indexPath.row * 2
        let ind2 = indexPath.row * 2 + 1
        var ids : [String] = []
        
        cell.location.text = filteredActivities[ind1].location
        cell.Title.text = filteredActivities[ind1].title
        cell.time.text = filteredActivities[ind1].time
        cell.ActivityImage.image = UIImage(named: filteredActivities[ind1].image)
        cell.button_configure(likes: filteredActivities[ind1].likes, but: 1)
        ids.append(filteredActivities[ind1].id)
        
        if (ind2 <= filteredActivities.count-1) {
            cell.ActivityBlock2.isHidden = false
            cell.location2.text = filteredActivities[ind2].location
            cell.Title2.text = filteredActivities[ind2].title
            cell.time2.text = filteredActivities[ind2].time
            cell.ActivityImage2.image = UIImage(named: filteredActivities[ind2].image)
            cell.button_configure(likes: filteredActivities[ind2].likes, but: 2)
            ids.append(filteredActivities[ind2].id)
        }
        else {
            cell.ActivityBlock2.isHidden = true
        }
        cell.assign_ID(ids: ids)
        cell.configure()
        return cell
    }
    
    func cellButtonPressed(actID: String) {
        print("delegate here")
        for (index, activity) in self.activities.enumerated() {
            if activity.id == actID {
                self.activities[index].likes = !self.activities[index].likes
            }
        }
        for (index, activity) in self.filteredActivities.enumerated() {
            if activity.id == actID {
                self.filteredActivities[index].likes = !self.filteredActivities[index].likes
            }
        }
        self.reloadData()
//        print("reloaded!")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getPlaceLocationFromName(place: String) -> CLLocationCoordinate2D {
        let name = place.lowercased()
        for buildingLocation in buildingLocations {
            if name.hasPrefix(buildingLocation.name) {
                return buildingLocation.location
            }
        }
        
        var returnLocation = CLLocationCoordinate2D()
        // request to Google Map: payment method needed
        /*
        let request =  URL(string:"https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=\(name)&inputtype=textquery&fields=geometry&key=AIzaSyDmH0diWsSMIhNsb3G2HIEG8g4p62rCgCI")!
        
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let f = JSONSerialization.jsonObject(with: data)
            returnLocation.latitude = f["candidates"]["geometry"]["location"]["lat"]
            returnLocation.longitude = f["candidates"]["geometry"]["location"]["lng"]}
        
        task.resume()
         */
        return returnLocation
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Failed to get location")
        latitude = -1.0
        longitude = -1.0
    }
    
    func distance(lo: CLLocationDegrees, la: CLLocationDegrees) -> Double {
        return (lo - longitude) * (lo - longitude) + (la - latitude) * (la - latitude)
    }
    
    func activity_recommendation() {
        if !CLLocationManager.headingAvailable() {
            print("Warning: Location is not available")
            return
        }
        
        let locationManager = CLLocationManagerCreator.getLocationManager()
        
        locationManager.requestWhenInUseAuthorization()
        
        if latitude == -1.0 && longitude == -1.0 {
            return
        }
        var filtered_activities: [sortActivity] = []
        
        for activity in activities {
            filtered_activities.append(sortActivity(activity: activity, location: getPlaceLocationFromName(place: activity.location)))
        }
        
        filtered_activities = filtered_activities.sorted(by: {
            return distance(lo: $0.location.longitude, la: $0.location.latitude) < distance(lo: $1.location.longitude, la: $1.location.longitude)
        })
        
        for activity in filtered_activities {
            sortedActivites.append(activity.activity)
        }
        
        for i in 1...activityRecommend {
            recommendActivities.append(filtered_activities[i].activity)
        }
        
        assert(recommendActivities.count > 0)
        
    }

    
    // MARK: Search Bar Config
    // whenever there is text in the search bar, run the following code
    func searchBar(_ searchBar:UISearchBar, textDidChange searchText: String) {
        
        self.filteredActivities = []
        
        if searchText == "" {
            self.filteredActivities = self.activities
        } else {
            for activity in self.activities {
                if activity.title.lowercased().contains(searchText.lowercased()) || activity.location.lowercased().contains(searchText.lowercased()) {
                    filteredActivities.append(activity)
                }
            }
        }
        print("reload!")
        self.reloadData()
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    @objc func recChange() {
        if counter < recact.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.recomCollection.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            PageView.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.recomCollection.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            PageView.currentPage = counter
            counter = 1
        }
    }

}

extension ActivityVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recact.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecomCell", for: indexPath) as! RecomCell
        let index = indexPath.row
        
        cell.configure()
        cell.location.text = recact[index].location
        cell.title.text = recact[index].title
        cell.time.text = recact[index].time
        cell.image.image = UIImage(named: recact[index].image)
        cell.rectext.text = "Near you!"
        
        return cell
    }
}

extension ActivityVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = recomCollection.frame.size
        return CGSize(width: size.width, height: size.height-10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
