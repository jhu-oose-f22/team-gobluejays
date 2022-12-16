//
//  ActivityVC.swift
//  GoBlueJays
//
//  Created by Heed Liu on 10/7/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import CoreLocation
import SwiftUI
import Kingfisher
import SwiftSoup

protocol activityTableDelegate: AnyObject {
    func cellButtonPressed(actID: String)
    func cellTapped(act: ActivityDetailModel, actID: String)
}

class ActivityVC: UIViewController{
    // Interface variables
    @IBOutlet weak var category_btn: UIButton!
    @IBOutlet weak var nearby: UIButton!
    @IBOutlet weak var upcoming: UIButton!
    @IBOutlet weak var PageView: UIPageControl!
    @IBOutlet weak var recomCollection: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var top_btn: UIButton!
    @IBOutlet weak var filter_btn: UIButton!
    
    // General variables
    let searchController = UISearchController(searchResultsController: nil)
    var timer = Timer()
    var counter = 0
    var buildingLocations: [BuildingLocation] = []
    var latitude: CLLocationDegrees = 39.0;
    var longitude: CLLocationDegrees = -76.0;
    var default_images = [
        "https://static1.campusgroups.com/upload/jhu/2022/r3_image_upload_1382318_gilman360x240jpg_62919654.jpeg",
        "https://static1.campusgroups.com/upload/jhu/2020/r2_image_upload_1367200_JHU_Frontjpg_7162189.jpeg",
        "https://static1.campusgroups.com/upload/jhu/2021/r3_image_upload_1918390_Apple_thumbnail_117213433.png"
    ]

    // Display and search variables
    var collect_ids: [String] = []
    var activities: [Activity] = []
    var filteredActivities: [Activity] = []
    var filterInfo = [String]()
    var searchKeyword = ""
    
    // Filter variables
    var allCategories: [String] = []
    var currentFilterCategory = "Choose a category"
    var currentFilterRank = "Rank by ..."
    var sortedActivites: [Activity] = []
    var sortedAct2: [Activity] = []
    
    // Recommendation variables
    var recact: [Activity] = []
    var recact_slogan: [String] = []
    let activityRecommend_dist_max: Int = 3;
    var recommendActivities_dist: [Activity] = []
    let activityRecommend_type_max: Int = 3;
    var recommendActivities_type: [Activity] = []
    var likes_tags: [String] = []
    
    
    // Load page
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Explore"

        // Interface set up
        top_config()
        filter_config()
        table_config()
        search_bar_config()
        rec_config()

        // Pull activities from database
        let db = Firestore.firestore()
        db.collection(CurrentLoginName.name).document("activity").collection("act").getDocuments(){ [self]
            (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                collect_ids = []
                likes_tags = []
                for document in QuerySnapshot!.documents {
                    if (document.documentID.count > 6) {
                        let data = document.data()
                        collect_ids.append(document.documentID)
                        likes_tags.append(data["category"] as! String)
                    }
                }
            }

            let group = DispatchGroup()
            group.enter()
            
            let now = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            let url = URL(string: "https://jhu.campusgroups.com/ical/ical_jhu.ics")
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                    if let data = data {
                        let g = String(data: data, encoding: .utf8)
                        self.activities = []
                        var idx = 0
                        // parse manually
                        let components = g!.components(separatedBy: "\r\n\r\n")
                        for component in components {
                            let properties = component.components(separatedBy: "\r\n")
                            var title = ""
                            var time = ""
                            var location = ""
                            var category = ""
                            var id = ""
                            var likes = false
                            var cost = "Free"
                            var host = ""
                            var detail = ""
                            var image_url = ""
                            for property in properties {
                                let equality = property.split(separator: ":")
                                if equality.isEmpty {
                                    break
                                }
                                if equality[0] == "BEGIN" && equality[1] != "VEVENT" {
                                    continue
                                }
                                if equality[0].lowercased() == "summary;encoding=quoted-printable" {
                                    title = String(equality[1])
                                }
                                if equality[0].lowercased() == "dtstart" {
                                    time = String(equality[1])
                                }
                                if equality[0].lowercased() == "categories;x-cg-category=event_type" {
                                    category = String(equality[1])
                                }
                                if equality[0].lowercased() == "location" {
                                    location = String(equality[1])
                                    if location == " Sign in to download the location" {
                                        location = "TBD"
                                        idx += 1
                                    }
                                }
                                if equality[0].lowercased() == "uid" {
                                    id = String(equality[1])
                                }
                                if equality[0].lowercased() == "url" {
                                    image_url = String(equality[1] + ":" + equality[2]);
                                }
                                if equality[0].lowercased() == "description" {
                                    detail = equality[1].replacingOccurrences(of: "\\n---\\nEvent Details", with: "", options: NSString.CompareOptions.literal, range: nil)
                                }
                                if equality[0].lowercased().contains("organizer") {
                                    let sarr = equality[0].components(separatedBy: "=")
                                    host = sarr[1].replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range:nil)
                                }
                            }
                            if title.isEmpty {
                                continue
                            }
                            let datetime = time.split(separator: Character("T"))
                            if datetime.isEmpty || datetime.count < 2 {
                                continue
                            }
                            let yyyy = String(datetime[0].substring(with: datetime[0].index(datetime[0].startIndex, offsetBy: 0)..<datetime[0].index(datetime[0].startIndex, offsetBy: 4)))
                            let mo = String(datetime[0].substring(with: datetime[0].index(datetime[0].startIndex, offsetBy: 4)..<datetime[0].index(datetime[0].startIndex, offsetBy: 6)))
                            let dd = String(datetime[0].substring(with: datetime[0].index(datetime[0].startIndex, offsetBy: 6)..<datetime[0].index(datetime[0].startIndex, offsetBy: 8)))
                            let hh = String(datetime[1].substring(with: datetime[1].index(datetime[1].startIndex, offsetBy: 0)..<datetime[1].index(datetime[1].startIndex, offsetBy: 2)))
                            let mi = String(datetime[1].substring(with: datetime[1].index(datetime[1].startIndex, offsetBy: 2)..<datetime[1].index(datetime[1].startIndex, offsetBy: 4)))
                            let ss = String(datetime[1].substring(with: datetime[1].index(datetime[1].startIndex, offsetBy: 4)..<datetime[1].index(datetime[1].startIndex, offsetBy: 6)))
                            var timestp = yyyy + "/" + mo + "/" + dd + " " + hh + ":" + mi
                            if location == "TBD" {
                                if idx == 500 {
                                    location = "Shiver Hall 211"
                                    timestp = "2022/12/18 15:30"
                                    print("here")
                                } else if idx == 800 {
                                    location = "Bloomberg Center"
                                    timestp = "2022/12/19 18:00"
                                } else if idx == 1000 {
                                    location = "The Beach"
                                    timestp = "2022/12/21 17:45"
                                } else if idx == 1200 {
                                    location = "Gilman 110"
                                    timestp = "2022/12/17 13:00"
                                } else if idx == 1300 {
                                    location = "Krieger 115, 3400 N Charlest St"
                                    timestp = "2022/12/17 10:00"
                                } else if idx == 1500 {
                                    location = "Wyman Quad"
                                    timestp = "2022/12/20 14:00"
                                }
                            }
                            
                            var timestpp = formatter.date(from: timestp) as! Date
                            if (timestpp > now) {
                                if (self.collect_ids.contains(id) == true) {
                                    likes = true
                                }
                                self.activities.append(Activity(title: title, time: timestp, location: location, image: image_url, likes: likes, id: id, category: category, host: host, cost: cost, detail: detail))
                                if (self.allCategories.contains(category) == false) {
                                    self.allCategories.append(category)
                                }
                            }
                        }
                    }
                // Activity Loaded, initialize variables
                self.allCategories = self.allCategories.sorted { $0.lowercased() < $1.lowercased() }
                self.allCategories.insert("All Category", at: 0)
                self.filteredActivities = self.activities
                self.setBuildingLocations()
                self.activity_recommendation()
                group.leave()
            }
            
            DispatchQueue.global().async {
                task.resume()
            }
            group.wait()
            
            self.PageView.numberOfPages = self.recact.count
            self.reloadData()
        }
        
    }
    
    // Segue to Collection page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CollectVC {
            destination.delegate = self
        }
    }
    
    // Button: go back to top table view
    @IBAction func clickTop(_ sender: Any) {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at:.top, animated: true)
    }
    
    // Button: filter effect
    @IBAction func clickFilter(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "filter") as? filterVC {
            vc.delegate = self
            vc.currentCategoryMessage = self.currentFilterCategory
            vc.currentRankMessage = self.currentFilterRank
            vc.category_list = self.allCategories
            self.navigationController?.pushViewController(vc, animated: true)
       }
    }
    
    // sort all activities by distance
    func sort_by_dist() {
        // reinitialize activities
        sortedActivites = []
        recommendActivities_dist = []
        
        // obtain user location
        if !CLLocationManager.headingAvailable() {
            print("Warning: Location is not available")
        } else {
            let locationManager = CLLocationManagerCreator.getLocationManager()
            locationManager.requestWhenInUseAuthorization()
        }
        if latitude == -1.0 && longitude == -1.0 {
            return
        }
        
        var filtered_activities: [sortActivity] = []
        for activity in activities {
            filtered_activities.append(sortActivity(activity: activity, location: getPlaceLocationFromName(place: activity.location)))
        }
        // sort by distance
        filtered_activities = filtered_activities.sorted(by: {
            return distance(lo: $0.location.longitude, la: $0.location.latitude) < distance(lo: $1.location.longitude, la: $1.location.longitude)
        })
        
        // Extract recommended activites from sort result
        var common_info: [String] = []
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.month = 1
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)!
        print(futureDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        for activity in filtered_activities {
            sortedActivites.append(activity.activity)
                
            if activity.location.latitude != 0.0 && activity.location.longitude != 0.0 {
                print(activity.activity.location)
                print(activity.activity.time)
                let info = activity.activity.title + activity.activity.location
                let t = formatter.date(from: activity.activity.time)!
                // exclude if time far or similar activity already recommended
                if (common_info.contains(info) == false) && (t<futureDate) {
                    recommendActivities_dist.append(activity.activity)
                    common_info.append(info)
                    print("appended")
                }
            }
        }
    }
    
    // sort all activities by time
    func sort_by_time() {
        var times: [Date] = []
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        for activity in activities {
            let timestp = formatter.date(from: activity.time)
            if let timestp = timestp {
                times.append(timestp)
            }
        }
    
        sortedAct2 = activities
        let combined = zip(times, sortedAct2).sorted {$0.0 < $1.0}
        let aftertimes = combined.filter {$0.0 > now}
        sortedAct2 = aftertimes.map {$0.1}
    }
    
    func reloadData() {
        self.search_bar_config()
        self.tableView.reloadData()
        self.recomCollection.reloadData()
    }
}

// Interface Configuration
extension ActivityVC {
    // filter button
    func filter_config() {
        filter_btn.titleLabel?.font = UIFont.systemFont(ofSize: 11.0)
        filter_btn.setTitle("Filter", for: .normal)
        filter_btn.setTitleColor(UIColor.systemGray3, for: .normal)
        
        category_btn.isHidden = true
        nearby.isHidden = true
        upcoming.isHidden = true
    }
    
    // top button
    func top_config() {
        let config = UIImage.SymbolConfiguration(scale: .medium)
        let image = UIImage(systemName: "arrow.up", withConfiguration: config)
        top_btn.setTitle("", for: .normal)
        top_btn.imageView?.contentMode = .scaleAspectFit
        top_btn.setImage(image, for: .normal)
        top_btn.tintColor = .systemGray3
    }
    
    // tableview
    func table_config() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName:"ActivityCell", bundle: .main), forCellReuseIdentifier: "ActivityCell")
        tableView.separatorStyle = .none
    }
    
    // search bar
    func search_bar_config() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        definesPresentationContext = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.sizeToFit()
    }
    
    // carousel
    func rec_config() {
        recomCollection.delegate = self
        recomCollection.dataSource = self
        PageView.numberOfPages = recact.count
        PageView.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.recChange), userInfo: nil, repeats: true)
        }
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

// Filter effect
extension ActivityVC: userFilterDelegate {
    // get filter result from filter page
    func returnFilter(category: String, rank: String) {
        if category == "reset" && rank == "reset" {
            // set to default value
            currentFilterCategory = "Choose a category"
            currentFilterRank = "Rank by ..."
            filteredActivities = activities
            self.reloadData()
        } else {
            currentFilterCategory = category
            currentFilterRank = rank
            
            if rank == "Upcoming" {
                sort_by_time()
                filteredActivities = sortedAct2
            } else {
                sort_by_dist()
                filteredActivities = sortedActivites
            }
            // filter by category
            if category != "All Category" {
                filteredActivities = filteredActivities.filter { $0.category==category }
            }
            
            // sync with ongoing search
            if self.searchKeyword != "" {
                filteredActivities = filteredActivities.filter { (activity: Activity) -> Bool in
                    let searchTextMatch = activity.title.lowercased().contains(self.searchKeyword.lowercased())
                    return searchTextMatch
                }
            }
            self.reloadData()
        }
    }
}

// Recommendation
extension ActivityVC {
    func activity_recommendation() {
        recact = []
        recact_slogan = []
        
        // recommend by distance
        sort_by_dist()
        let dist_count = min(activityRecommend_dist_max, recommendActivities_dist.count)
        print(recommendActivities_dist)
        if (dist_count-1) >= 0 {
            for i in 0...dist_count-1 {
                recact.append(recommendActivities_dist[i])
                recact_slogan.append("Near you!")
            }
        }
        
        // recommend by event type
        let in_actid = recact.map({ (act: Activity) -> String in act.id })
        activity_rec_by_type()
        let type_count = min(activityRecommend_type_max, recommendActivities_type.count)
        if (type_count-1) >= 0 {
            for i in 0...type_count-1 {
                let new_id = recommendActivities_type[i].id
                if collect_ids.contains(new_id) {
                    continue
                }
                // if an activity is recommended by both distance and preference
                if in_actid.contains(new_id) {
                    let index = in_actid.firstIndex(of: recommendActivities_type[i].id)
                    recact_slogan[index!] = recact_slogan[index!].replacingOccurrences(of: "!", with: "", options: NSString.CompareOptions.literal, range:nil) + " and you might like!"
                    continue
                }
                recact.append(recommendActivities_type[i])
                recact_slogan.append("You might like!")
            }
        }
    }
    
    // recommend by event type
    func activity_rec_by_type() {
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.month = 1
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        var common_info: [String] = []
        
        let mappedItems = likes_tags.map { ($0, 1) }
        let wgts = Dictionary(mappedItems, uniquingKeysWith: +)
        var weights: [Double] = []
        let shuffle_act = activities.shuffled()
        for act in shuffle_act {
            var val = 0.0
            let t = act.category
            let time = formatter.date(from: act.time)!
            let info = act.title + act.location
            // exclude if time far or similar already recommended
            if likes_tags.contains(t) && time < futureDate && common_info.contains(info) == false {
                let v = wgts[t]
                // weighting algorithm
                val += pow(Double(v!),Double(v!))
                common_info.append(info)
            }
            weights.append(val)
        }
        
        let recact_type = shuffle_act
        let combined = zip(weights, recact_type).sorted {$0.0 > $1.0}
        let very_like = combined.filter {$0.0 > 0}
        recommendActivities_type = very_like.map {$0.1}
    }
}

// Location related
extension ActivityVC {
    func setBuildingLocations() {
        // hard-code building locations
        buildingLocations = [
            BuildingLocation(name: "hodson", location: CLLocationCoordinate2D(latitude: 39.32749022560959, longitude: -76.62227881124888)),
            BuildingLocation(name: "hackerman", location: CLLocationCoordinate2D(latitude: 39.32691271415686, longitude: -76.62090191636538)),
            BuildingLocation(name: "malone", location: CLLocationCoordinate2D(latitude: 39.32623759589481, longitude: -76.62080273393454)),
            BuildingLocation(name: "maryland", location: CLLocationCoordinate2D(latitude: 39.328045703864206, longitude: -76.6198668018716)),
            BuildingLocation(name: "levering", location: CLLocationCoordinate2D(latitude: 39.32809140048764, longitude: -76.62189940022438)),
            BuildingLocation(name: "krieger", location: CLLocationCoordinate2D(latitude: 39.32865204939853, longitude: -76.6199681981623)),
            BuildingLocation(name: "wyman", location: CLLocationCoordinate2D(latitude: 39.32517737353952, longitude: -76.62289381377747)),
            BuildingLocation(name: "clark", location: CLLocationCoordinate2D(latitude: 39.32693374517105, longitude: -76.62225083148367)),
            BuildingLocation(name: "latrobe", location: CLLocationCoordinate2D(latitude: 39.32789328034753, longitude: -76.62075340116824)),
            BuildingLocation(name: "croft", location: CLLocationCoordinate2D(latitude: 39.32733683893719, longitude: -76.61957309112006)),
            BuildingLocation(name: "mason", location: CLLocationCoordinate2D(latitude: 39.325861985523076, longitude: -76.62151281118587)),
            BuildingLocation(name: "shiver", location: CLLocationCoordinate2D(latitude: 39.32642389924464, longitude:  -76.62025109761828)),
            BuildingLocation(name: "gilman", location: CLLocationCoordinate2D(latitude: 39.32893189373731, longitude: -76.62157898877807)),
            BuildingLocation(name: "mergenthaler", location: CLLocationCoordinate2D(latitude: 39.329652795301435, longitude: -76.62063640452014)),
            BuildingLocation(name: "remsen", location: CLLocationCoordinate2D(latitude: 39.32953968324859, longitude: -76.62002418197157)),
            BuildingLocation(name: "mudd", location: CLLocationCoordinate2D(latitude: 39.33096989515415, longitude: -76.62054267311402)),
            BuildingLocation(name: "macaulay", location: CLLocationCoordinate2D(latitude: 39.33021214342024, longitude: -76.62078368915385)),
            BuildingLocation(name: "dunning", location: CLLocationCoordinate2D(latitude: 39.33027356644766, longitude: -76.62001903445636)),
            BuildingLocation(name: "wyman quad", location: CLLocationCoordinate2D(latitude: 39.327531421428056, longitude: -76.62036598718512)),
            BuildingLocation(name: "decker quad", location: CLLocationCoordinate2D(latitude: 39.32650901050207, longitude: -76.6215549382646)),
            BuildingLocation(name: "milton s eisenhower library", location: CLLocationCoordinate2D(latitude: 39.32916209697434, longitude: -76.61924558793446)),
            BuildingLocation(name: "imagine center", location: CLLocationCoordinate2D(latitude: 39.334745943668445, longitude: -76.62137203136315)),
            BuildingLocation(name: "homewood field", location: CLLocationCoordinate2D(latitude: 39.33357420852676, longitude: -76.62079601541275)),
            BuildingLocation(name: "homewood museum", location: CLLocationCoordinate2D(latitude: 39.32987674911344, longitude: -76.61893090882971)),
            BuildingLocation(name: "hopkins cafe", location: CLLocationCoordinate2D(latitude: 39.331613285972054, longitude: -76.61963798082502)),
            BuildingLocation(name: "bloomberg center for physics and astronomy", location: CLLocationCoordinate2D(latitude: 39.33391493367228, longitude: -76.62396509512084)),
            BuildingLocation(name: "freshman quad", location: CLLocationCoordinate2D(latitude: 39.33071041942408, longitude: -76.61942234313949)),
            BuildingLocation(name: "the beach", location: CLLocationCoordinate2D(latitude: 39.32900089341375, longitude: -76.61837410006774)),
            BuildingLocation(name: "bloomberg", location: CLLocationCoordinate2D(latitude: 39.3318433252, longitude: -76.6231796557)),
            BuildingLocation(name: "barnes and nobles", location: CLLocationCoordinate2D(latitude: 39.32847376491413, longitude: -76.61624772944326))
        ]
    }
    
    func getPlaceLocationFromName(place: String) -> CLLocationCoordinate2D {
        let name = place.lowercased()
        for buildingLocation in buildingLocations {
            if name.hasPrefix(buildingLocation.name) {
                return buildingLocation.location
            }
        }
        
        var returnLocation = CLLocationCoordinate2D()
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
        // Failed to get location
        latitude = -1.0
        longitude = -1.0
    }
    
    func distance(lo: CLLocationDegrees, la: CLLocationDegrees) -> Double {
        return (lo - longitude) * (lo - longitude) * 69 + (la - latitude) * (la - latitude) * 54.6
    }
}

// Activity & Collect Page Delegate
extension ActivityVC: collectToMainDelegate {
    // if uncollect from collect page
    func uncollect(actID: String) {
        for (index, activity) in self.activities.enumerated() {
            if activity.id == actID {
                if activity.likes == false {
                    self.collect_ids.append(actID)
                } else {
                    // delete
                    self.collect_ids = collect_ids.filter {$0 != actID}
                }
                // update
                self.activities[index].likes = !self.activities[index].likes
            }
        }
        
        for (index, activity) in self.filteredActivities.enumerated() {
            if activity.id == actID {
                self.filteredActivities[index].likes = !self.filteredActivities[index].likes
            }
        }
        
        for (index, activity) in self.recact.enumerated() {
            if activity.id == actID {
                self.recact[index].likes = !self.recact[index].likes
            }
        }
        
        self.reloadData()
    }
}

// Detail Delegate
extension ActivityVC: activityTableDelegate {

    func cellTapped(act: ActivityDetailModel, actID: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivityDetailView") as! ActivityDetail
        var actdetail = act
        for a in self.activities {
            if a.id == actID {
                let tarr = a.time.components(separatedBy: " ")
                actdetail.date = tarr[0]
                actdetail.time = tarr[1]
                actdetail.host = a.host
                actdetail.detail = a.detail
                actdetail.cost = a.cost
                
                vc.activity = actdetail
            }
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func cellButtonPressed(actID: String) {
        let db = Firestore.firestore()
        for (index, activity) in self.activities.enumerated() {
            if activity.id == actID {
                if activity.likes == false {
                    db.collection(CurrentLoginName.name).document("activity").collection("act").document(actID).setData([
                        "category": activity.category,
                        "image": activity.image,
                        "imageLink": "",
                        "likes": true,
                        "location":activity.location,
                        "timestamp":activity.time,
                        "title":activity.title,
                        "host":activity.host,
                        "cost":activity.cost,
                        "detail":activity.detail
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                    self.collect_ids.append(actID)
                } else {
                    db.collection(CurrentLoginName.name).document("activity").collection("act").document(actID).delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                    self.collect_ids = collect_ids.filter {$0 != actID}
                }

                self.activities[index].likes = !self.activities[index].likes
            }
        }
        
        for (index, activity) in self.filteredActivities.enumerated() {
            if activity.id == actID {
                self.filteredActivities[index].likes = !self.filteredActivities[index].likes
            }
        }
        
        for (index, activity) in self.recact.enumerated() {
            if activity.id == actID {
                self.recact[index].likes = !self.recact[index].likes
            }
        }
        
        self.reloadData()
    }
}

// Table View
extension ActivityVC: UITableViewDelegate, UITableViewDataSource {
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

        let url = URL(string: filteredActivities[ind1].image)
        if let url = url {
            let group = DispatchGroup()
            group.enter()
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                if let data = data {
                    do {
                        let data = String(data: data, encoding: .utf8)
                        if let data = data {
                            let doc = try SwiftSoup.parse(data)
                            let image_url = try
                            doc.getElementsByClass("img-responsive").first()
                            if let image_url = image_url {
                                try self.filteredActivities[ind1].image = image_url.attr("src")
                            } else {
                                self.filteredActivities[ind1].image = self.default_images[Int.random(in: 0..<3)]
                            }
                        } else {
                            self.filteredActivities[ind1].image = self.default_images[Int.random(in: 0..<3)]
                        }
                    } catch {}
                    group.leave()
                }
            }
            DispatchQueue.global().async {
                task.resume()
            }
            group.wait()
        } else {
            self.filteredActivities[ind1].image = self.default_images[Int.random(in: 0..<3)]
        }
        let url1 = URL(string: filteredActivities[ind1].image)
        cell.ActivityImage.kf.setImage(with: url1)
        cell.button_configure(likes: filteredActivities[ind1].likes, but: 1)
        ids.append(filteredActivities[ind1].id)
        
        // second column in table view
        if (ind2 <= filteredActivities.count-1) {
            let url = URL(string: filteredActivities[ind2].image)
            if let url = url {
                let group = DispatchGroup()
                group.enter()
                let task = URLSession.shared.dataTask(with: url) {
                    (data, response, error) in
                    if let data = data {
                        do {
                            let data = String(data: data, encoding: .utf8)
                            if let data = data {
                                let doc = try SwiftSoup.parse(data)
                                let image_url = try
                                doc.getElementsByClass("img-responsive").first()
                                if let image_url = image_url {
                                    try self.filteredActivities[ind2].image = image_url.attr("src")
                                } else {
                                    self.filteredActivities[ind2].image = self.default_images[Int.random(in: 0..<3)]
                                }
                            } else {
                                self.filteredActivities[ind2].image = self.default_images[Int.random(in: 0..<3)]
                            }
                        } catch {}
                        group.leave()
                    }
                }
                DispatchQueue.global().async {
                    task.resume()
                }
                group.wait()
            } else {
                self.filteredActivities[ind2].image = self.default_images[Int.random(in: 0..<3)]
            }
            cell.img2?.isHidden = false
            cell.whiteback2.isHidden = false
            cell.location2.text = filteredActivities[ind2].location
            cell.Title2.text = filteredActivities[ind2].title
            cell.time2.text = filteredActivities[ind2].time
            let url2 = URL(string: filteredActivities[ind2].image)
            cell.ActivityImage2.kf.setImage(with: url2)
            cell.button_configure(likes: filteredActivities[ind2].likes, but: 2)
            ids.append(filteredActivities[ind2].id)
        } else {
            cell.img2.isHidden = true
            cell.whiteback2.isHidden = true
        }
        cell.assign_ID(ids: ids)
        cell.configure()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){

    }
}

// Search bar
extension ActivityVC: UISearchBarDelegate, userDidFilterDelegate {
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return (!isSearchBarEmpty || !filterInfo.isEmpty)
    }
    
    func returnFilterCategory(info: [String]) {
        filterInfo = info
        if !filterInfo.isEmpty {
            filteredActivities = activities.filter { (activity: Activity) -> Bool in
                return filterInfo.contains(where: {(category1: String) -> Bool in
                    return activity.category.lowercased() == category1.lowercased()
                })

            }
        }
        self.reloadData()
    }
    
    func filterContentForSearchText(searchText: String) {
        if !isSearchBarEmpty {
            filteredActivities = filteredActivities.filter { (activity: Activity) -> Bool in
                let searchTextMatch = activity.title.lowercased().contains(searchText.lowercased())
                return searchTextMatch
            }
            self.searchKeyword = searchText
        } else {
            if currentFilterCategory == "Choose a category" && currentFilterRank == "Rank by ..." {
                filteredActivities = activities
            } else {
                if currentFilterRank == "Upcoming" {
                    sort_by_time()
                    filteredActivities = sortedAct2
                } else {
                    sort_by_dist()
                    filteredActivities = sortedActivites
                }
                if currentFilterCategory != "All Category" {
                    filteredActivities = filteredActivities.filter { $0.category==currentFilterCategory }
                }
            }
            self.searchKeyword = ""
        }
        self.reloadData()
    }
}

extension ActivityVC: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
      let searchBar = searchController.searchBar
      let searchText = searchBar.text!
      filterContentForSearchText(searchText: searchText)
  }
}

// CollectionView
extension ActivityVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recact.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivityDetailView") as! ActivityDetail
        
        let selectedCell = collectionView.cellForItem(at: indexPath) as! RecomCell
        let act = recact[indexPath.row]
        let tarr = act.time.components(separatedBy: " ")
        let actdetail = ActivityDetailModel(title: act.title, date: tarr[0], time: tarr[1], location: act.location, host: act.host, cost: act.cost, detail: act.detail, image: selectedCell.image.asImage())
        vc.activity = actdetail
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecomCell", for: indexPath) as! RecomCell
        cell.delegate = self
        let index = indexPath.row
        
        cell.configure()
        cell.button_configure(likes: recact[index].likes)
        cell.location.text = recact[index].location
        cell.title.text = recact[index].title
        cell.time.text = recact[index].time
        let url = URL(string: recact[index].image)
        if let url = url {
            let group = DispatchGroup()
            group.enter()
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                if let data = data {
                    do {
                        let data = String(data: data, encoding: .utf8)
                        if let data = data {
                            let doc = try SwiftSoup.parse(data)
                            let image_url = try
                            doc.getElementsByClass("img-responsive").first()
                            if let image_url = image_url {
                                try self.recact[index].image = image_url.attr("src")
                            } else {
                                self.recact[index].image = self.default_images[Int.random(in: 0..<3)]
                            }
                        } else {
                            self.recact[index].image = self.default_images[Int.random(in: 0..<3)]
                        }
                    } catch {}
                    group.leave()
                }
            }
            DispatchQueue.global().async {
                task.resume()
            }
            group.wait()
        } else {
            recact[index].image = self.default_images[Int.random(in: 0..<3)]
        }
        
        let image_url = URL(string: recact[index].image)
        cell.image.kf.setImage(with: image_url)
        cell.rectext.text = recact_slogan[index]
        
        cell.assign_ID(id: recact[index].id)
        return cell
    }
}

// CollectionView
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
