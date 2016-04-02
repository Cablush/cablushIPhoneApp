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
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var confirmaSenha: UITextField!
    
   override func viewDidLoad() {
        
    }
    @IBAction func cadastrar(sender: AnyObject) {
        print("Create User")
        if name.text != nil && email.text != nil {
            if(senha.text == confirmaSenha.text){
                print("Pronto p cadastrar")
                doCadastro()
            }
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func doCadastro(){
        let cadastro = LoginRequest()
        cadastro.registro_request(name.text!, email: email.text!, senha: senha.text!) { (data) -> Void in
            if data != nil{
                print(data)
            }
        }
        
    }
}