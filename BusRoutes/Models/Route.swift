//
//  Route.swift
//  BusRoutes
//
//  Created by Hari Krishna Bista on 1/30/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class Stop: Codable {
    var name:String
}

class Route: Codable {
    var id:String
    var name:String
    
    var accessible:Bool = true
    var imageUrl:String?
    
    var description: String?
    var stops:[Stop] = []
    
    init(id:String, name:String) {
        self.id = id
        self.name = name
    }
}
