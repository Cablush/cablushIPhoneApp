//
//  ParseJson.swift
//  Cablush
//
//  Created by Jonathan on 10/03/16.
//  Copyright © 2016 Cablush. All rights reserved.
//

import Foundation
struct ParseJson {
    func parseJsonPista(data: NSData)->[Pista]{
       var pistas = [Pista]()
        do {
            let locais = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? NSArray ?? nil
            if locais != nil{
                for item in locais!{
                    let pista = Pista()
                    setLocalizavel(item as! NSDictionary,localizavel: pista)
                    if let loc = item["local"]!{
                        pista.local =  setLocal(loc)
                    }
                    if let hora = item["horario"]!{
                        pista.horario = setHorario(hora)
                    }
                    pista.img_url          = item["foto_url"]as? String ?? ""
                    pistas.append(pista)
                }
            }
        } catch {
            print(error)
        }
        return pistas
    }
    
    func parseJsonEvento(data: NSData)->[Evento]{
       var eventos = [Evento]()
        do {
            let locais = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? NSArray ?? nil
            if locais != nil{
                for item in locais!{
                    let evento = Evento()
                    setLocalizavel(item as! NSDictionary,localizavel: evento)
                    if let loc = item["local"]!{
                        evento.local =  setLocal(loc)
                    }
                    evento.img_url          = item["flyer_url"]as? String ?? ""
                    eventos.append(evento)
                }
            }
        } catch {
            print(error)
        }
        return eventos
    }
    
    func parseJsonLoja(data: NSData)->[Loja]{
        var lojas = [Loja]()
        do {
            let locais = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? NSArray ?? nil
            if locais != nil{
                for item in locais!{
                    let loja = Loja()
                    setLocalizavel(item as! NSDictionary,localizavel: loja)
                    loja.locais =  setLocais(item["locais"] as! NSArray)
                    loja.email = item["email"] as? String ?? ""
                    loja.img_url          = item["logo_url"]as? String ?? ""
                    if let hora = item["horario"]!{
                        loja.horario = setHorario(hora)
                    }
                    lojas.append(loja)
                }
            }
        } catch {
            print(error)
        }
        return lojas
    }
    
    
    func setLocalizavel(item :NSDictionary, localizavel: Localizavel){
        localizavel.nome             = item["nome"] as? String ?? ""
        localizavel.descricao        = item["descricao"] as? String ?? ""
        localizavel.facebook         = item["faceboook"] as? String ?? ""
        localizavel.responsavel_uuid = item["responsavel_uuid"] as? String ?? ""
        localizavel.uuid             = item["uuid"] as? String ?? ""
        localizavel.website          = item["website"] as? String ?? ""
        
        if let esportes = item["esportes"] as? NSArray {
            localizavel.setEsportes(esportes)
        }
    }
    
    func setLocal(loc :AnyObject)->Local{
        var local = Local()
        local.bairro        = loc["bairro"] as? String ?? ""
        local.cep           = loc["cep"] as? String ?? ""
        local.cidade        = loc["cidade"] as? String ?? ""
        local.estado        = loc["estado"] as? String ?? ""
        local.numero        = loc["numero"] as? String ?? ""
        local.pais          = loc["pais"] as? String ?? ""
        local.estado        = loc["estado"] as? String ?? ""
        local.complemento   = loc["complemento"] as? String ?? ""
        
        let latitude        = loc["latitude"] as? String ?? ""//0.0
        let longitude       = loc["longitude"] as? String ?? ""//0.0
        local.latitude = Double(latitude) ?? 0.0
        local.longitude = Double(longitude) ?? 0.0
        
        return local;
    }
    
    func setLocais(locais :NSArray)->[Local]{
        var listLocais = [Local]()
        for loc in locais{
            var local = Local()
            local.bairro        = loc["bairro"] as? String ?? ""
            local.cep           = loc["cep"] as? String ?? ""
            local.cidade        = loc["cidade"] as? String ?? ""
            local.estado        = loc["estado"] as? String ?? ""
            local.numero        = loc["numero"] as? String ?? ""
            local.pais          = loc["pais"] as? String ?? ""
            local.estado        = loc["estado"] as? String ?? ""
            local.complemento   = loc["complemento"] as? String ?? ""
            
            let latitude        = loc["latitude"] as? String ?? ""//0.0
            let longitude       = loc["longitude"] as? String ?? ""//0.0
            local.latitude = Double(latitude) ?? 0.0
            local.longitude = Double(longitude) ?? 0.0
            
            listLocais.append(local)
        }
        return listLocais;
    }
    
    func setHorario(hora :AnyObject) -> Horario{
        var horario = Horario()
        horario.seg             = hora["seg"] as? Bool ?? false
        horario.ter             = hora["ter"] as? Bool ?? false
        horario.qua             = hora["qua"] as? Bool ?? false
        horario.qui             = hora["qui"] as? Bool ?? false
        horario.sex             = hora["sex"] as? Bool ?? false
        horario.sab             = hora["sab"] as? Bool ?? false
        horario.dom             = hora["dom"] as? Bool ?? false
        horario.uuidLocalizavel = hora["uuidLocalizavel"] as? String ?? ""
        horario.inicio          = hora["inicio"] as? NSDate ?? NSDate()
        return horario
    }
    
}