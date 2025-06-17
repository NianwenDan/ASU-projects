//
//  City.swift
//  lab6
//
//  Created by Nianwen Dan on 3/19/24.
//

import Foundation
import MapKit

struct City: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var coordinate: CLLocationCoordinate2D
    var picture: UIImage
    
    init(name: String, description: String, picture: UIImage) {
        self.name = name
        self.description = description
        self.coordinate = CLLocationCoordinate2D() // Temporary placeholder
        self.picture = picture
    }
    
    init(name: String, description: String, coordinate: CLLocationCoordinate2D, picture: UIImage) {
        self.name = name
        self.description = description
        self.coordinate = coordinate
        self.picture = picture
    }
}
