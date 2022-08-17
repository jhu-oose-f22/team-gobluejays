//
//  ViewController.swift
//  GoBlueJays
//
//  Created by Jessie Luo on 8/6/22.
//

import UIKit
import MapKit

class MapVC: UIViewController, UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty,
        let resultsVC = searchController.searchResultsController as? ResultsViewController else {
            return
        }
        
        resultsVC.delegate = self
        
        GooglePlacesManager.shared.findPlaces(query: query) { result in
            switch result {
            case .success(let places):
                DispatchQueue.main.async {
                    resultsVC.update(with: places)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    let mapView = MKMapView()
    let searchVC = UISearchController(searchResultsController: ResultsViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Map"
        view.addSubview(mapView)
        let hopkins = MKPointAnnotation()
        //39.3299° N, 76.6205° W
        hopkins.coordinate = CLLocationCoordinate2D(latitude: 39.3299, longitude: -76.6205)
        mapView.addAnnotation(hopkins)
        
        let brody = MKPointAnnotation()
        brody.coordinate = CLLocationCoordinate2D(latitude: 39.32854936102123, longitude: -76.61937490046321)
        brody.title = "Brody Learning Commons"
        brody.subtitle = "Library"
//        mapView.addAnnotation(brody)
        
        let region = MKCoordinateRegion(center: hopkins.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.setRegion(region, animated: true)
//        searchVC.searchBar.backgroundColor = .secondarySystemBackground
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = CGRect(x: 0, y: 6, width: view.frame.size.width, height: view.frame.size.height)
    }
}

extension MapVC: ResultsViewControllerDelegate {
    func didTapPlace(with coordinates: CLLocationCoordinate2D) {
        // get rid of keyboard
        searchVC.searchBar.resignFirstResponder()
        searchVC.dismiss(animated: true)
        
        // remove existing map pins
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        
        // add a map pin
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: coordinates, latitudinalMeters: 300, longitudinalMeters: 300), animated: true)
    }
    
    
}

