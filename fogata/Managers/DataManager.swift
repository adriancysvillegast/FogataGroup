//
//  DataManager.swift
//  fogata
//
//  Created by Adriancys Jesus Villegas Toro on 13/3/24.
//

import Foundation
import CoreData
import UIKit
import CoreLocation


final class DataManager {
    
    // MARK: - Properties
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    // MARK: - methods
    
    func createPin(pin: PinModel ) -> Bool {
      let context = context
        let newPin = NSEntityDescription.insertNewObject(forEntityName: "Entity", into: context)
        newPin.setValue(pin.id, forKey: "id")
        newPin.setValue(pin.name, forKey: "name")
        newPin.setValue(pin.latitud, forKey: "latitude")
        newPin.setValue(pin.longitude, forKey: "longitude")
      do {
        try context.save()
          return true
      } catch {
          return false
      }
    }
    
    
    func fetchTasks() -> [PinModel] {
        var pinSaved: [PinModel] = []
        let context = context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
//        NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        
        do {
            let pins = try context.fetch(request)
            for pin in pins as! [NSManagedObject] {
                pinSaved.append(createObjc(pin: pin))
            }
            return pinSaved
        } catch {
            print("Error fetching tasks: \(error.localizedDescription)")
            return []
        }
    }
    

    private func createObjc(pin: NSManagedObject) -> PinModel {
        let id = pin.value(forKey: "id") as! String
        let name = pin.value(forKey: "name") as! String
        let latitud = pin.value(forKey: "latitude") as! Double
        let longitude = pin.value(forKey: "longitude") as! Double
        
        let newPin = PinModel(id: id, name: name, latitud: latitud, longitude: longitude)
        return newPin
    }
}
