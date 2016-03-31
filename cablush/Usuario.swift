//
//  Usuario.swift
//  cablush
//
//  Created by Jonathan on 31/03/16.
//  Copyright © 2016 com.Cablush. All rights reserved.
//

import Foundation
class Usuario{
    var uuid        :String = ""
    var nome        :String = ""
    var email       :String = ""
    var password    :String = ""
    var role        :String = ""
    var accessToken :String = ""
    var esportes    :[Esporte] = []
}