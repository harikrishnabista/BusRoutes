//
//  ApiCaller.swift
//  BusRoutes
//
//  Created by Hari Krishna Bista on 1/30/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class ApiCaller {
    func getDataFromUrl(url:URL, completion:@escaping (_ data:Data?, _ resp:URLResponse?, _ err:Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, resp, err) in
            completion(data, resp, err)
        })
        
        task.resume()
    }
    
    func getImageFrom(url:URL, completion:@escaping (_ image:UIImage?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, resp, err) in
            if err == nil, let data = data {
                completion(UIImage.init(data: data))
            }else{
                if let err = err {
                    print("error Message: \(err.localizedDescription)")
                }
                
                completion(nil)
            }
        })
        
        task.resume()
        
        return task
    }
}
