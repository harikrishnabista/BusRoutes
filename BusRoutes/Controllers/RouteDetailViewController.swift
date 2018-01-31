//
//  RouteDetailViewController.swift
//  BusRoutes
//
//  Created by Hari Krishna Bista on 1/30/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class RouteDetailViewController: UIViewController, UITableViewDataSource {
    
    var route:Route!
    var routeImage:UIImage?

    @IBOutlet weak var lblRouteName: UILabel!
    @IBOutlet weak var imgRoute: UIImageView!
    @IBOutlet weak var lblRouteDesc: UILabel!
    @IBOutlet weak var imgAccesibility: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    var dataObject: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        imgAccesibility.isHidden = !route.accessible
        lblRouteName.text = route.name
        lblRouteDesc.text = route.description
        
        if let img = routeImage {
            imgRoute.image = img
        }else{
            if let imgUrlStr = route.imageUrl, let url = URL(string:imgUrlStr) {
                ApiCaller().getImageFrom(url: url, completion: { (img) in
                    if let img = img {
                        DispatchQueue.main.async {
                            self.imgRoute.image = img
                        }
                    }
                })
            }
        }
    }
    
    //UITableViewDataSource delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return route.stops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StopTableViewCell", for: indexPath) as! StopTableViewCell
        cell.imgTopBar.isHidden = false
        cell.imgBottomBar.isHidden = false
        
        if indexPath.row == 0 {
            cell.imgTopBar.isHidden = true
        }
        
        if indexPath.row == route.stops.count - 1 {
            cell.imgBottomBar.isHidden = true
        }
        
        cell.lblStopName.text = route.stops[indexPath.row].name
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
