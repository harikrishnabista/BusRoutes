//
//  RouteListParser.swift
//  BusRoutes
//
//  Created by Hari Krishna Bista on 1/30/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class RouteListParser {
    
    func parseRouteList(data:Data?,resp:URLResponse?,err:Error?) -> RouteList? {
        
        if let err = err {
            print(err.localizedDescription)
            return nil
        }
        
        guard let data = data else {
            return nil
        }
        
        do{
            let routes = try JSONDecoder().decode([Route].self, from: data)
            return RouteList(routes: routes)
            
        } catch let jsonError {
            print("jsonError: \(jsonError)")
            return nil
        }
    }
}
