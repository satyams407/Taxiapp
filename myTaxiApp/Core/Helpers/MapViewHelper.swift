//
//  MapViewBounds.swift
//  myTaxiApp
//
//  Created by Satyam Sehgal on 10/03/19.
//  Copyright © 2019 Satyam Sehgal. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    
    func getBounds() -> MapRectBounds {
        let topRightPoint = CGPoint(x: self.bounds.maxX, y: self.bounds.origin.y)
        let bottomLeftPoint = CGPoint(x: self.bounds.minX, y: self.bounds.maxY)
        let northEastCoordinate = convert(topRightPoint, toCoordinateFrom: self)
        let southWestCoordinate = convert(bottomLeftPoint, toCoordinateFrom: self)
        
        return MapRectBounds(southWestCoordinate,northEastCoordinate)
    }
}
