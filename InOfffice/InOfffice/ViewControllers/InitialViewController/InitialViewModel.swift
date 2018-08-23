//
//  InitialViewModel.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

class InitialViewModel: NSObject {
    
    var userEnteredDetails: UserDetail = UserDetail(name: UIDevice.current.name,
                                                    office: "",
                                                    productionHourString: "8h",
                                                    productionHours: 8.0,
                                                    games: Games(orderNumbers: OrderNumbers()))
}
