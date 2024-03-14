//
//  HomeViewModel.swift
//  fogata
//
//  Created by Adriancys Jesus Villegas Toro on 13/3/24.
//

import Foundation
import CoreLocation

class HomeViewModel {
    
    // MARK: - Properties
    
    let dataManager: DataManager
    
    init(dataManager: DataManager = DataManager()) {
        self.dataManager = dataManager
    }
    
    // MARK: - Methods
    
    
    func addLocation(name: String, location: CLLocation) {
        let annotation = PinModel(
            id: "\(name)\(location.coordinate.longitude)",
            name: name,
            latitud: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        let success = dataManager.createPin(pin: annotation)
        print("was Saved\(success)")
    }
    
    func getLocation() -> [PinModel] {
        let annotation = dataManager.fetchTasks()
        for pin in annotation {
            print(pin)
        }
        return annotation
    }
}
