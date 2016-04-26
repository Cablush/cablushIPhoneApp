//
//  Localizavel.swift
//  Cablush
//
//  Created by Jonathan on 08/03/16.
//  Copyright © 2016 Cablush. All rights reserved.
//

import Foundation
class Localizavel: NSObject {
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
    
    
    struct LocalizavelPropertyKey {
        static let nomeKey = "nome"
        static let uuidKey = "uuid"
        static let descricaoKey = "descricao"
        static let facebookKey = "facebook"
        static let websiteKey = "website"
        static let imgKey = "img_url"
        static let fundoKey = "fundo"
        static let responsavelKey = "responsavel_uuid"
    }
    
    override init(){}
    
    init(uuid :String, nome :String, descricao :String, facebook :String, website :String, img_url :String, fundo :Bool, responsavel_uuid :String) {
        self.uuid = uuid
        self.nome = nome
        self.descricao = descricao
        self.facebook = facebook
        self.website = website
        self.img_url = img_url
        self.fundo  = fundo
        self.responsavel_uuid = responsavel_uuid
    }
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(uuid,             forKey: LocalizavelPropertyKey.uuidKey)
        aCoder.encodeObject(nome,             forKey: LocalizavelPropertyKey.nomeKey)
        aCoder.encodeObject(descricao,        forKey: LocalizavelPropertyKey.descricaoKey)
        aCoder.encodeObject(facebook,         forKey: LocalizavelPropertyKey.facebookKey)
        aCoder.encodeObject(website,          forKey: LocalizavelPropertyKey.websiteKey)
        aCoder.encodeObject(img_url,          forKey: LocalizavelPropertyKey.imgKey)
        aCoder.encodeObject(fundo,            forKey: LocalizavelPropertyKey.fundoKey)
        aCoder.encodeObject(responsavel_uuid, forKey: LocalizavelPropertyKey.responsavelKey)
    }

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