//
//  SidePanelViewController.swift
//  cablush
//
//  Created by Jonathan on 21/03/16.
//  Copyright © 2016 com.Cablush. All rights reserved.
//


import UIKit


protocol SidePanelViewControllerDelegate {
    func requestDataPistas()
    func requestDataEventos()
    func requestDataLojas()
}


class SidePanelViewController: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var cadastroBtn: UIButton!

    var delegate: SidePanelViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        if !Usuario.usuario.accessToken.isEmpty {
            loginBtn.hidden = true
            cadastroBtn.hidden = true
        }
    }

    
    @IBAction func buscaLojas(sender: AnyObject) {
    delegate?.requestDataLojas()
    }
    
    @IBAction func buscaEventos(sender: AnyObject) {
    delegate?.requestDataEventos()
    }
    @IBAction func buscaPistas(sender: AnyObject) {
     delegate?.requestDataPistas()
    }
    
}

