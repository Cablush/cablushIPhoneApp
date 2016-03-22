//
//  DataRequest.swift
//  Cablush
//
//  Created by Jonathan on 10/03/16.
//  Copyright © 2016 Cablush. All rights reserved.
//

import Foundation

struct DataRequest {
    
    func data_request(tipo: String, completion: (data: NSData?) ->Void )
    {
        let myUrl = NSURL(string: "http://www.cablush.com/api/\(tipo)/")
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "GET"
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            //Let’s convert response sent from a server side script to a NSDictionary object:
            if data != nil{
                completion(data: data!)
            }
        }
        task.resume()
    }
    
}