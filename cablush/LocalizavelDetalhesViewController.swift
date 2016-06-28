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
    
    var localizavel = Localizavel()
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var videoImg: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var enderecoImg: UIImageView!
    @IBOutlet weak var facebookImg: UIImageView!
    @IBOutlet weak var emailImg: UIImageView!
    @IBOutlet weak var telImg: UIImageView!
    @IBOutlet weak var websiteImg: UIImageView!
    
    
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var detalhes: UITextView!
    @IBOutlet weak var video: UIButton!
    @IBOutlet weak var telefone: UIButton!
    @IBOutlet weak var email: UIButton!
    @IBOutlet weak var endereco: UIButton!
    @IBOutlet weak var site: UIButton!
    @IBOutlet weak var facebook: UIButton!
    
    var tel :String = ""
    var fb :String = ""
    var ws :String = ""
    var mail :String = ""
    var lat :String = ""
    var lng :String = ""
    var vid :String = ""
    
    override func viewDidLoad() {
        fb = localizavel.facebook
        ws = localizavel.website ?? "www.cablush.com"
        nome.text       = localizavel.nome
        detalhes.text   = localizavel.descricao
        site.setTitle(localizavel.website, forState: UIControlState.Normal)
        
        facebook.setTitle(localizavel.facebook, forState: UIControlState.Normal)
        if let loja = localizavel as? Loja{
            tel = loja.telefone
            mail = loja.email
            lat = "\(loja.locais[0].latitude)"
            lng = "\(loja.locais[0].longitude)"
            telefone.setTitle(loja.telefone, forState: UIControlState.Normal)
            email.setTitle(loja.email, forState: UIControlState.Normal)
            endereco.setTitle(loja.locais[0].toString(), forState: UIControlState.Normal)
        }else if let pista = localizavel as? Pista{
            lat = "\(pista.local.latitude)"
            lng = "\(pista.local.longitude)"
            
            if pista.video.isEmpty{
                video.hidden = true
                videoImg.hidden = true
            }else{
                video.setTitle(pista.video, forState: .Normal)
                vid = pista.video
            }
            
            endereco.setTitle(pista.local.toString(), forState: UIControlState.Normal)
        }else if let evento = localizavel as? Evento{
            lat = "\(evento.local.latitude)"
            lng = "\(evento.local.longitude)"
            
            endereco.setTitle(evento.local.toString(), forState: UIControlState.Normal)
        }
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
                guard let data = data where error == nil else {
                self.imageView.image = UIImage(named: "missing")
                    return
                }
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSizeMake(375, 700)
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    @IBAction func telefone(sender: AnyObject) {
        
        let trimmedString = tel.stringByReplacingOccurrencesOfString("\\s", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        print("tel://\(trimmedString)")
        let url = NSURL(string: "tel://\(trimmedString)")
        
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func email(sender: AnyObject) {
        let url = NSURL(string: "mailto:\(mail)")
        UIApplication.sharedApplication().openURL(url!)
    }
    @IBAction func site(sender: AnyObject) {
        let url = NSURL(string: "http://\(ws)")
        UIApplication.sharedApplication().openURL(url!)
    }
    @IBAction func facebook(sender: AnyObject) {
        let url = NSURL(string: "http://\(fb)")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func endereco(sender: AnyObject) {

    }
    @IBAction func video(sender: AnyObject) {
        let url = NSURL(string: "\(vid)")
        UIApplication.sharedApplication().openURL(url!)
    }
    
}
