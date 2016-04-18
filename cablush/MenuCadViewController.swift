//
//  MenuCadViewController.swift
//  cablush
//
//  Created by Jonathan on 11/04/16.
//  Copyright © 2016 com.Cablush. All rights reserved.
//

import Foundation
import UIKit

class MenuCadViewController : UIViewController{
    
    override func viewDidLoad() {
        
    }

    @IBAction func back(sender: AnyObject) {
         self.dismissViewControllerAnimated(true, completion: nil)
    }
}