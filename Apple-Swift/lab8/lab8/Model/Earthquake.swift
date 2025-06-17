//
//  Earthquake.swift
//  lab8
//
//  Created by Nianwen Dan on 4/11/24.
//

import Foundation

struct Earthquake: Decodable {
    let datetime: String
    let depth: Double
    let lng: Double
    let src: String
    let eqid: String
    let magnitude: Double
    let lat: Double
}

struct EarthquakeResponse: Decodable {
    let earthquakes: [Earthquake]
}
