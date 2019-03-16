//
//  VehicleListCellModel.swift
//  myTaxiApp
//
//  Created by Satyam Sehgal on 13/03/19.
//  Copyright © 2019 Satyam Sehgal. All rights reserved.
//

import Foundation

@objcMembers open class CabsObject: NSObject {
    var title: Int
    var fleetType: String
    
    init(id: Int, fleetType: String) {
        self.title = id
        self.fleetType = fleetType
        super.init()
    }
}
