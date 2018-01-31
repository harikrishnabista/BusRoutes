//
//  RouteListViewController.swift
//  BusRoutes
//
//  Created by Hari Krishna Bista on 1/30/18.
//  Copyright © 2018 meroapp. All rights reserved.
//
import UIKit

class RouteListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var routeList:RouteList?
    static let ROUTE_TABLE_VIEW_REUSE_IDENTIFIER = "RouteListTableViewCell"
    static let ROUTE_CONTAINER_VIEW_CONTROLLER = "RouteContainerViewController"
    
    // make those lazy var for load balance
    var routeImageCache:[String:UIImage] = [:]
    var imageDownLoadTasks:[String:URLSessionDataTask] = [:]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        getRoutes()
    }
    
    func getRoutes() {
        guard let url = URL(string: Constants.API) else { return }
        
        ApiCaller().getDataFromUrl(url: url) { (data, resp, err) in
            self.routeList = RouteListParser().parseRouteList(data: data, resp: resp, err: err)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // UITableViewDataSource delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeList?.routes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RouteListViewController.ROUTE_TABLE_VIEW_REUSE_IDENTIFIER, for: indexPath) as! RouteListTableViewCell
        
        cell.imgRoute.image = UIImage(named:"iconBusPlaceHolder")
        
        if let route = routeList?.routes[indexPath.row] {
            cell.lblRouteName.text = route.name
            
            if let imgUrlStr = route.imageUrl {
                
               if let cacheImg = routeImageCache[imgUrlStr] {
                    cell.imgRoute.image = cacheImg
               }else if let imgUrl = URL(string:imgUrlStr) {
                    // storing downloadtask later we may need it to cancel
                    imageDownLoadTasks[imgUrlStr] = ApiCaller().getImageFrom(url: imgUrl, completion: { (img) in
                        if let img = img {
                            self.routeImageCache[imgUrlStr] = img
                            DispatchQueue.main.async {
                                cell.imgRoute.image = img
                            }
                        }else{
                            print("No remote image: \(indexPath.row)")
                        }
                        
                        // no more need to reference download task as it is completed
                        self.imageDownLoadTasks.removeValue(forKey: imgUrlStr)
                    })
                }
            }
        }

        return cell
    }
    
    // UITableViewDelegate delegates
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let imgUrl = routeList?.routes[indexPath.row].imageUrl, let task = imageDownLoadTasks[imgUrl] {
            if task.state == URLSessionTask.State.running{
                print("downloading image cancelled because no more need to show for row: \(indexPath.row)")
                task.cancel()
                imageDownLoadTasks.removeValue(forKey: imgUrl)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let routeDetailViewCon = self.storyboard?.instantiateViewController(withIdentifier: RouteListViewController.ROUTE_CONTAINER_VIEW_CONTROLLER) as? RouteContainerViewController {
            routeDetailViewCon.routeList = routeList
            routeDetailViewCon.routeImageCache = routeImageCache
            routeDetailViewCon.selectedIndex = indexPath.row
            navigationController?.show(routeDetailViewCon, sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
