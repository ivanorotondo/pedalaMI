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
    
    static func askTheTRKServer(var destination : String, method: String, successHandler: (response: NSData) -> Void, errorHandler:(error: Int) -> Void){
        
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
    
}