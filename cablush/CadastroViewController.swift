//
//  CadastroViewController.swift
//  cablush
//
//  Created by Jonathan on 22/03/16.
//  Copyright © 2016 com.Cablush. All rights reserved.
//

import Foundation
import UIKit
class CadastroViewController : UIViewController {
   override func viewDidLoad() {
        
    }
    @IBAction func cadastrar(sender: AnyObject) {
        print("Create User")
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}