//
//  LoginViewController.swift
//  cablush
//
//  Created by Jonathan on 21/03/16.
//  Copyright © 2016 com.Cablush. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var senha: UITextField!
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func login(sender: AnyObject) {
    }

    override func viewDidLoad() {
    
    }
    
}