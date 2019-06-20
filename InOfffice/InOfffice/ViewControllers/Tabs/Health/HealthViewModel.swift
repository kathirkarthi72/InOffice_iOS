//
//  HealthViewModel.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit
import HealthKit

class HealthViewModel: NSObject {
    
    var healthStore : HKHealthStore? {
        
        if HKHealthStore.isHealthDataAvailable() {
            return HKHealthStore()
        }
        
        return nil
    }
    
    /// Health Kit access request authorization
    func requestAuthorization() {
        
        if let healthStore = healthStore {
            // Health kit available.
            let objectTypes = Set([HKObjectType.quantityType(forIdentifier: .dietaryWater)!])
            
            // Get Request to access Health objects
            healthStore.requestAuthorization(toShare: objectTypes, read: objectTypes) { (success, error) in
                if !success {
                    print("Didn't get permission to access your health kit: \(error.debugDescription)")
                } else {
                    print("Got permission")
                }
            }
        }
    }
    
    /// Add Water in take quantity
    func addWaterInTake(onces: Double) {
        
        let objectTypes = HKObjectType.quantityType(forIdentifier: .dietaryWater)!
        
        let quantityUnit = HKUnit(from: "l")
        
        let quantity = HKQuantity(unit: quantityUnit, doubleValue: onces)
        
        let now = Date()
        
        let sample = HKQuantitySample(type: objectTypes, quantity: quantity, start: now, end: now)
        let correlationType = HKObjectType.correlationType(forIdentifier: .food)
        
        let waterCorrelation = HKCorrelation(type: correlationType!, start: now, end: now, objects: Set([sample]))

        healthStore?.save(waterCorrelation, withCompletion: { (success, error) in
            
            if let err = error {
                print(err.localizedDescription)
            }
        })
    }
}
