//
//  Usuario.swift
//  cablush
//
//  Created by Jonathan on 31/03/16.
//  Copyright © 2016 com.Cablush. All rights reserved.
//

import Foundation
struct PropertyKey {
    static let nomeKey = "nome"
    static let uuidKey = "uuid"
    static let emailKey = "email"
    static let passwordKey = "password"
    static let roleKey = "role"
    static let accessTokenKey = "accessToken"
    static let esportesKey = "esportes"
}

class Usuario: NSObject{
    @nonobjc static var usuario = Usuario()
    var uuid        :String = ""
    var nome        :String = ""
    var email       :String = ""
    var password    :String = ""
    var role        :String = ""
    var accessToken :String = ""
    var esportes    :[Esporte] = []
    
    override init(){}
    
    init?(nome :String, email : String, password: String){
        self.nome = nome
        self.email = email
        self.password = password
        
        // Initialization should fail if there is no name or if the rating is negative.
        if nome.isEmpty || email.isEmpty {
            return nil
        }
    }
    
    convenience init?(uuid: String, nome :String, email : String, password: String,role :String,accessToken:String){
        
        self.init(nome: nome, email: email,password: password)
        self.role = role
        self.accessToken = accessToken
        self.uuid = uuid
    }
    
    @objc required convenience init?(coder aDecoder: NSCoder) {
        let nome = aDecoder.decodeObjectForKey(PropertyKey.nomeKey) as! String
        let email = aDecoder.decodeObjectForKey(PropertyKey.emailKey) as! String
        let password = aDecoder.decodeObjectForKey(PropertyKey.passwordKey) as! String
        
        self.init(nome: nome, email: email,password: password)
        
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

extension Usuario : NSCoding{
    // MARK Coding
    @nonobjc static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
     @nonobjc static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("usuario")
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(nome, forKey: PropertyKey.nomeKey)
        aCoder.encodeObject(email, forKey: PropertyKey.emailKey)
        aCoder.encodeObject(password, forKey: PropertyKey.passwordKey)
    }
    
    //Saving
    func saveUser()-> Bool{
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self, toFile: Usuario.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save user...")
            return false
        }else{
            Usuario.usuario = self
            return true
        }
        
    }
    
    //loading
    func loadUser() -> [Usuario]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Usuario.ArchiveURL.path!) as? [Usuario]
    }
    
}