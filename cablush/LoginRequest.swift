//
//  LoginRequest.swift
//  cablush
//
//  Created by Jonathan on 31/03/16.
//  Copyright © 2016 com.Cablush. All rights reserved.
//

import Foundation

class LoginRequest{
    
    func login_request(email: String, senha :String, completion: (data: NSData?) ->Void )
    {
        let myUrl = NSURL(string: "http://www.cablush.com/usuarios/sign_in")
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "POST"
        let jsonString = "usuario:{email:\(email),senha:\(senha)"
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

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
    
    func registro_request(name: String,email: String, senha :String, completion: (data: NSData?) ->Void )
    {
        let myUrl = NSURL(string: "http://www.cablush.com/usuarios")
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "POST"
        let jsonString = "usuario:{name:\(name),email:\(email),senha:\(senha)"
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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