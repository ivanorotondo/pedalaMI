//
//  iBiciSDK.swift
//  iBici
//
//  Created by Ivano Rotondo on 11/03/16.
//  Copyright © 2016 IvanoRotondo. All rights reserved.
//

import Foundation
import UIKit

class ServerCallsSDK {
    
    static func askTheServer(var destination : String, method: String, successHandler: (response: NSData) -> Void, errorHandler:(error: Int) -> Void){
        
        let destinationString = (destination as String).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let request = NSMutableURLRequest(URL: NSURL(string: destinationString)!)
        request.HTTPMethod = method
        request.timeoutInterval = 15.0
                
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                errorHandler(error: (error?.code)!)
                return
            }
            successHandler(response: data!);
            
        } 
        
        task.resume()
    }
    

    
    static func askTheServerWithData(var dataPost : String, var destination : String, method: String, var headersDict: NSDictionary, successHandler: (response: NSData) -> Void, errorHandler:(error: Int) -> Void){
        
        let request = NSMutableURLRequest(URL: NSURL(string: destination as String)!)
        request.HTTPMethod = method
        request.timeoutInterval = 15.0
        
        let postString = dataPost
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        for item in headersDict {
            request.setValue("\(item)", forHTTPHeaderField: "\(headersDict.objectForKey("\(item)"))")
        }

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                errorHandler(error: (error?.code)!)
                return
            }
            successHandler(response: data!);
            
        }
        
        task.resume()
    }

    
}