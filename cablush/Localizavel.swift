//
//  Localizavel.swift
//  Cablush
//
//  Created by Jonathan on 08/03/16.
//  Copyright © 2016 Cablush. All rights reserved.
//

import Foundation
class Localizavel {
    var uuid = ""
    var nome = ""
    var descricao = ""
    var facebook = ""
    var website = ""
    var img_url = ""
    var fundo  = false
    var responsavel_uuid = ""

    var responsavel = ""
    var esportes = [Esporte]()

    func setEsportes(esportes : NSArray){
        for esporte in esportes{
            var esp = Esporte()
            esp.categoria = esporte["categoria"] as? String ?? ""
            esp.id        = esporte["id"] as? Int ?? 0
            esp.nome      = esporte["nome"] as? String ?? ""
            esp.icone     = esporte["icone"] as? String ?? ""
            self.esportes.append(esp)
        }
    }
     
}