//
//  HomeViewController.swift
//  fogata
//
//  Created by Adriancys Jesus Villegas Toro on 13/3/24.
//

import UIKit
import MapKit
import CoreLocation


class HomeViewController: UIViewController {

    // MARK: -  Properties
    
    let locationManager = CLLocationManager()
    
    let baseAnnotations = [
        MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: 37.7833, longitude: -122.4167), title: "San Francisco (From Array)", subtitle: nil),
        MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0059), title: "New York City (From Array)", subtitle: nil),
    ]
    
    private lazy var viewModel: HomeViewModel = {
        let model = HomeViewModel()
        return model
    }()
    
    private lazy var mapKitView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        return map
    }()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        setUpView()
        getPermission()
        getAnnotations()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapKitView.frame = view.bounds
    }
    
    // MARK: - setUpView
    
    private func setUpView() {
        view.addSubview(mapKitView)
        let longPressed = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotationWithLongPress))
        
        longPressed.minimumPressDuration = 1
        longPressed.delaysTouchesBegan = true
        longPressed.delegate = self
        mapKitView.addGestureRecognizer(longPressed)
        
    }

    // MARK: - Methods
    
    private func getPermission() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        validatePermision()
        
    }
    
    func validatePermision() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
            if self.locationManager.authorizationStatus == .authorizedWhenInUse || self.locationManager.authorizationStatus == .authorizedAlways {
                
                self.locationManager.startUpdatingLocation()
            } else {
                self.getPermission()
            }
        }
    }
    
    func addAnnotation(location: CLLocation, name: String) {

        
        let pin = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        viewModel.addLocation(name: name, location: location)
        pin.coordinate = coordinate
        pin.title =  name
        mapKitView.addAnnotation(pin)
        mapKitView.setRegion(
            MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.2,
                    longitudeDelta: 0.2)),
            animated: true
        )
        
    }
    
    
    func getAnnotations() {
        
        let locations = viewModel.getLocation()
        for location in locations {
            let pin = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(
                latitude: location.latitud,
                longitude: location.longitude
            )
            pin.coordinate = coordinate
            pin.title = location.name
            
            mapKitView.addAnnotation(pin)
        }
        baseAnnotations.forEach {
            mapKitView.addAnnotation($0)
        }
    }

    // MARK: - Targets
    
    @objc func saveLocation() {
        print("tapped saved location")
    }
    
    @objc func addAnnotationWithLongPress(gesture: UIGestureRecognizer) {
        if gesture.state == .began {
            let touch = gesture.location(in: mapKitView)
            let newCoordinates = mapKitView.convert(touch, toCoordinateFrom: mapKitView)
            let location = CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude)
            addTitleToLocation(location: location)
        }
    }
    
     func addTitleToLocation(location: CLLocation) {
        let alert = UIAlertController(title: "Add a Title", message: "Please add a title to the location", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Add a name"
            textfield.keyboardType = .default
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            guard let name = alert.textFields?.first?.text else { return }
            
            self.addAnnotation(location: location, name: name)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - CLLocationManagerDelegate

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let cordinate2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: cordinate2D, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        let pin = MKPointAnnotation()
        pin.coordinate = cordinate2D
        pin.title = "Here you are!"
        mapKitView.addAnnotation(pin)
        mapKitView.setRegion(region, animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
}

// MARK: - MKMapViewDelegate

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        let cordinate = CLLocation(
            latitude:annotation.coordinate.latitude,
            longitude: annotation.coordinate.longitude
        )
        
        let vc = DetailsViewController(coordinate: cordinate)
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    
    
}


// MARK: - UIGestureRecognizerDelegate

extension HomeViewController: UIGestureRecognizerDelegate {
    
}
