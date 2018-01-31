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

    lazy var routeList = RouteList(routes:[])
    lazy var routeImageCache = [String:UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        if let storyboard = self.storyboard, let selectedViewCon = self.viewControllerAtIndex(selectedIndex, storyboard: storyboard),let pageViewController = pageViewController{
            
            pageViewController.setViewControllers([selectedViewCon], direction: .forward, animated: false, completion: {done in })
            
            pageViewController.dataSource = self
            
            addChildViewController(pageViewController)
            view.addSubview(pageViewController.view)
            
            // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
            var pageViewRect = view.bounds
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                pageViewRect = pageViewRect.insetBy(dx: 40.0, dy: 40.0)
            }
            
            pageViewController.view.frame = pageViewRect
            pageViewController.didMove(toParentViewController: self)
        }

    }
    
    @IBAction func btnNavBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        for (i,item) in routeList.routes.enumerated() {
            if item.id == viewController.route.id {
                return i
            }
        }
        
        return NSNotFound
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
