//
//  VehicleManager.swift
//  InOfffice
//
//  Created by ktrkathir on 04/01/19.
//  Copyright © 2019 ktrkathir. All rights reserved.
//

import UIKit
import CoreData

class VehicleManager: NSObject {
    
    static let current = VehicleManager()
    
    /// Insert vehicle detail
    ///
    /// - Parameters:
    ///   - type: Vehicle type
    ///   - no: Plate number
    ///   - initialkm: initialkm
    ///   - bestMileage: bestMileage
    ///   - saved: Completion handler
    func insert(vehicle type: String, plate number: String, initialkm: Double, bestMileage: Double, saved: @escaping(() -> ()) ) {
        if let context = TimeSheetManager.current.objectContext {
            let vehicle = Vehicle(context: context)
            
            vehicle.type = type
            vehicle.plateNo = number
            vehicle.totalKm = initialkm
            vehicle.bestMileage = bestMileage
            
            do {
                try context.save()
                saved()
            } catch let error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Delete vehicle
    ///
    /// - Parameters:
    ///   - plateNumber: Vehicle plate number
    ///   - deleted: completion handler
    func delete(vehicle plateNumber: String, deleted: @escaping(() -> ())) {
        
        let fetchRequest : NSFetchRequest = Vehicle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "plateNo = %@", plateNumber)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        if let context = TimeSheetManager.current.objectContext {
            do {
                try context.execute(deleteRequest)
                try context.save()
                deleted()
            } catch let error {
                debugPrint("Failed to fetch a record from Timesheet: \(error.localizedDescription)")
            }
        }
    }
    
    /// Fetch all vehicles
    var fetchVehicles: [Vehicle]? {
        
        if let context = TimeSheetManager.current.objectContext {
            do {
                let vehicles = try context.fetch(Vehicle.fetchRequest())
                return vehicles as? [Vehicle]
            } catch let error {
                debugPrint("Failed to fetch a record from Timesheet: \(error.localizedDescription)")
            }
        }
        return nil
    }
}

// MARK: - Add Mileage detail
extension VehicleManager {
    
    /// Insert fuel details
    ///
    /// - Parameters:
    ///   - litre: Fuel litres
    ///   - number: plate number
    ///   - date: fuel filled date
    ///   - intialkm: Initial km
    ///   - finalKm: current km
    ///   - mileage: calculated mileage
    ///   - saved: completion handler
    func insertFuel(filled litre:Double, plate number: String, date: Date, intialkm: Double = 0.0, finalKm: Double = 0.0, mileage: Double = 0.0, saved: @escaping(() -> ())) {
        if let context = TimeSheetManager.current.objectContext {
            let fuelInfo = FuelDetail(context: context)
            fuelInfo.litre = litre
            fuelInfo.plateNo = number
            fuelInfo.date = date
            fuelInfo.initialKm = intialkm
            fuelInfo.currentKm = finalKm
            fuelInfo.avgKm = mileage
            
            do {
                try context.save()
                saved()
            } catch let error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func saveFuelInfo(completed: @escaping(() -> ())) {
        if let context = TimeSheetManager.current.objectContext {
            do {
                try context.save()
                completed()
            } catch let error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Fetch all fuel details
    ///
    /// - Parameter plateNumber: plate number
    /// - Returns: fuel details
    func fetchAllFuels(plateNumber: String) -> [FuelDetail]? {
        
        if let context = TimeSheetManager.current.objectContext {
            let fetchRequest: NSFetchRequest = FuelDetail.fetchRequest()
            let dateSort = NSSortDescriptor(key: "date", ascending: false)
            fetchRequest.sortDescriptors = [dateSort]
            do {
                let fuels = try context.fetch(fetchRequest)
                return fuels
            } catch let error {
                debugPrint("Failed to fetch a record from Timesheet: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    func delete(fuelDetail: FuelDetail) {
        // let fetchRequest : NSFetchRequest = FuelDetail.fetchRequest()
        
        //    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        if let context = TimeSheetManager.current.objectContext {
            context.delete(fuelDetail)
            do {
                //  try context.execute(deleteRequest)
                try context.save()
            } catch let error {
                debugPrint("Failed to fetch a record from Timesheet: \(error.localizedDescription)")
            }
        }
    }    
}
