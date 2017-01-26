//
//  BlankPageVC.swift
//  pedalaMI
//
//  Created by Ivo on 07/12/16.
//  Copyright © 2016 IvanoRotondo. All rights reserved.
//

import Foundation
import UIKit


class BlankPageVC : UIViewController {
    
    var mapVC : MapVC?
    
    @IBOutlet var label: UILabel!
    
    var labelText = ""
    
    override func viewDidLoad() {
        label.text = labelText
        
        self.navigationController?.navigationBarHidden = true
    }
    
    @IBAction func tryAgainButtonPressed(sender: UIButton) {
        
        Utilities.loadingBarDisplayer("Loading",indicator:true, view: self.view)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.mapVC?.downloadAndShowStations({
                self.dismissViewControllerAnimated(true, completion: {})
                }, fail: {
                    error in
                    
                    Utilities.removeLoading()
                    
                    if error == -1009 {
                        var alertNoInternetConnection = Utilities.AlertTextualDetails()
                        alertNoInternetConnection.title = "The device results offline"
                        alertNoInternetConnection.message = "No internet connection available"
                        Utilities.displayAlert(self, alertTextualDetails: alertNoInternetConnection)
                    } else if error == -1001{
                        var alertRequestTimeout = Utilities.AlertTextualDetails()
                        alertRequestTimeout.title = "Slow Connection"
                        alertRequestTimeout.message = "It took too long to download data"
                        Utilities.displayAlert(self, alertTextualDetails: alertRequestTimeout)
                    } else if error == -2102{
                        var alertRequestTimeout = Utilities.AlertTextualDetails()
                        alertRequestTimeout.title = "Connection timeout"
                        alertRequestTimeout.message = "We're experiencing some problems to connect to the server.\nPlease try again later"
                        Utilities.displayAlert(self, alertTextualDetails: alertRequestTimeout)
                    } else {
                        var alertUnknownError = Utilities.AlertTextualDetails()
                        alertUnknownError.title = "Error"
                        alertUnknownError.message = "Unknown error"
                        Utilities.displayAlert(self, alertTextualDetails: alertUnknownError)
                    }
            })
        })
        
    }
}