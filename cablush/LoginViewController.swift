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
    
    override func viewDidLoad() {
        
    }

    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func login(sender: AnyObject) {
        print("Check if everything is allright")
        
        if usuario.text != nil && senha.text != nil{
         dologinRequest(usuario.text!, senha: senha.text!)
        }
        
    }

    func dologinRequest(email:String, senha:String){
        let login = LoginRequest();
        login.login_request(email, senha: senha) { (data) -> Void in
           let parseJson = ParseJson()
            if data != nil{
                parseJson.parseJsonUsuario(data!)
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
}