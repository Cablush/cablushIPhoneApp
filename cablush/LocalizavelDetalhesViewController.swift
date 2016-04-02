//
//  LocalizavelDetalhesViewController.swift
//  cablush
//
//  Created by Jonathan on 01/04/16.
//  Copyright © 2016 com.Cablush. All rights reserved.
//

import Foundation
import UIKit



class LocalizavelDetalhesViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var detalhes: UITextView!
    
    @IBOutlet weak var site: UILabel!
    @IBOutlet weak var facebook: UILabel!
    @IBOutlet weak var endereco: UILabel!
    @IBOutlet weak var telefone: UILabel!
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var siteImg: UIImageView!
    @IBOutlet weak var facebookImg: UIImageView!
    @IBOutlet weak var enderecoImg: UIImageView!
    @IBOutlet weak var emailImg: UIImageView!
    @IBOutlet weak var telefoneImg: UIImageView!
    
    var localizavel = Localizavel()
    
    override func viewDidLoad() {
        nome.text       = localizavel.nome
        detalhes.text   = localizavel.descricao
        site.text       = localizavel.website
        facebook.text   = localizavel.facebook
        endereco.text   = "Endereco"
        telefone.text   = "Telefone"
        email.text      = "E-mail"
        
        let url = NSURL(string:localizavel.img_url)
        downloadImage(url!)
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func downloadImage(url: NSURL){
        getDataFromUrl(url) {
            (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
}
