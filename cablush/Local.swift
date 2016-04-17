//
//  Local.swift
//  Cablush
//
//  Created by Jonathan on 08/03/16.
//  Copyright © 2016 Cablush. All rights reserved.
//

import Foundation
struct Local {
    var logradouro = ""
    var bairro=""
    var cep = ""
    var cidade = ""
    var complemento = ""
    var estado = ""
    var latitude = 0.0
    var longitude = 0.0
    var numero = ""
    var pais = ""
    
    func toString() -> String {
        return "\(logradouro) \(numero) \(cidade)"
    }
}