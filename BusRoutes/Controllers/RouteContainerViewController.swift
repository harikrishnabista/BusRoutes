//
//  RouteContainerViewController.swift
//  BusRoutes
//
//  Created by Hari Krishna Bista on 1/30/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class RouteContainerViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController?
    var selectedIndex = 0

    var routeList:RouteList!
    var routeImageCache:[String:UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        // Configure the page view controller and add it as a child view controller.
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        //        self.pageViewController!.delegate = self
        
        let selectedRouteDetailViewControlelr: RouteDetailViewController = self.viewControllerAtIndex(selectedIndex, storyboard: self.storyboard!)!
        
        self.pageViewController!.setViewControllers([selectedRouteDetailViewControlelr], direction: .forward, animated: false, completion: {done in })
        
        self.pageViewController!.dataSource = self
        
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        
        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        var pageViewRect = self.view.bounds
        if UIDevice.current.userInterfaceIdiom == .pad {
            pageViewRect = pageViewRect.insetBy(dx: 40.0, dy: 40.0)
        }
        self.pageViewController!.view.frame = pageViewRect
        
        self.pageViewController!.didMove(toParentViewController: self)
    }
    
    func viewControllerAtIndex(_ index: Int, storyboard: UIStoryboard) -> RouteDetailViewController? {
        // Return the data view controller for the given index.
        if (routeList.routes.count == 0) || (index >= routeList.routes.count) {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let routeDetailViewController = storyboard.instantiateViewController(withIdentifier: "RouteDetailViewController") as! RouteDetailViewController
        
        routeDetailViewController.route = self.routeList.routes[index]
        
        if let imageUrl = routeDetailViewController.route.imageUrl, let img = routeImageCache[imageUrl] {
            routeDetailViewController.routeImage = img
        }
        
        return routeDetailViewController
    }
    
    func indexOfViewController(_ viewController: RouteDetailViewController) -> Int {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
        
        for (i,item) in routeList.routes.enumerated() {
            if item.id == viewController.route.id {
                return i
            }
        }
        
        return NSNotFound
        
//        return routeList.routes.index(of: viewController.route) ?? NSNotFound
    }
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! RouteDetailViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! RouteDetailViewController)
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == routeList.routes.count {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
