//
//  InOfficeManager.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

/// User Details
struct UserDetail {
    
    var name: String
    
    var office: String
    
    var productionHourString: String
    
    var productionHours: Float
    
    var games : Games
}

struct Games {
    var orderNumbers : OrderNumbers
}

struct OrderNumbers {
    
    var savedSeconds : Int = 0
    
    var completedLevels : Int = 1
}


class InOfficeManager: NSObject {
    
    static let current = InOfficeManager()
    
    /// User profile plist
    var userPlistPath : String {
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = documentDirectory.appending("/profile.plist")
        
        return path
    }
    
    /// Check user was logged in or not
    var isUserLoggedIn: Bool {
        
        if FileManager.default.fileExists(atPath: userPlistPath) {
            return true
        } else { // User not logged In
            return false
        }
    }
    
    /// Fetch user infos from Plist
    var userInfos : UserDetail? {
        
        if let userInfos = NSDictionary(contentsOfFile: userPlistPath), isUserLoggedIn {
          //  debugPrint("Created: \(userPlistPath)")
            
            return UserDetail(name: userInfos["name"] as! String,
                       office: userInfos["office"] as! String,
                       productionHourString: userInfos["productionHourString"] as! String,
                       productionHours: userInfos["productionHour"] as! Float,
                       games: Games(orderNumbers: OrderNumbers(savedSeconds: userInfos.value(forKeyPath: "games.orderNumbers.savedSeconds") as! Int,
                                                               completedLevels: userInfos.value(forKeyPath: "games.orderNumbers.completedLevels") as! Int)))
        }
        return nil
    }
    
    /// save user infos to Plist
    
    func saved(detail: UserDetail) -> Bool {
        
        if isUserLoggedIn {
            
            do {
                try FileManager.default.removeItem(atPath: userPlistPath)
                
                let userInfos : NSDictionary = ["name": detail.name,
                                                "office": detail.office,
                                                "productionHourString": detail.productionHourString,
                                                "productionHour": detail.productionHours,
                                                "games": ["orderNumbers" : ["savedSeconds" : detail.games.orderNumbers.savedSeconds,
                                                                            "completedLevels" : detail.games.orderNumbers.completedLevels]]
                ]
                
                if userInfos.write(toFile: self.userPlistPath, atomically: true) {
                  //  debugPrint("Created: \(self.userPlistPath)")
                    return true
                } else {
                    debugPrint("Not created")
                }
            } catch {
                debugPrint(error.localizedDescription)
            }
            
        } else {
            let userInfos : NSDictionary = ["name": detail.name,
                                            "office": detail.office,
                                            "productionHourString": detail.productionHourString,
                                            "productionHour": detail.productionHours,
                                            "games": ["orderNumbers" : ["savedSeconds" : detail.games.orderNumbers.savedSeconds,
                                                                        "completedLevels" : detail.games.orderNumbers.completedLevels]]
            ]
            
            if userInfos.write(toFile: self.userPlistPath, atomically: true) {
              // debugPrint("Created: \(self.userPlistPath)")
                return true
            } else {
                debugPrint("Not created")
            }
        }
        
       
        return false
    }
    
    
    /// User logged out actions
    func userLoggedOut() -> Bool {
        
        do {
            if isUserLoggedIn {
                try FileManager.default.removeItem(atPath: userPlistPath)
                
                TimeSheetManager.current.trashSummary(sheetID: nil)
            }
        } catch let error {
            debugPrint(error)
            return false
        }
        
        return true
    }
    
}
