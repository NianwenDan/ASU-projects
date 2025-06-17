//
//  City.swift
//  lab7
//
//  Created by Nianwen Dan on 3/31/24.
//

import Foundation
import SwiftData

@Model
class City: Identifiable {
    @Attribute(.unique) var id: String
    @Attribute var title: String
    @Attribute var desc: String
    @Attribute var image: Data?
    
    init(id: String, title: String, desc: String, image: Data) {
        self.id = id
        self.title = title
        self.desc = desc
        self.image = image
    }
}
