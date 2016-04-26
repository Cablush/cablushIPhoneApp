//
//  Usuario.swift
//  cablush
//
//  Created by Jonathan on 31/03/16.
//  Copyright © 2016 com.Cablush. All rights reserved.
//

import Foundation
class Usuario: NSObject,NSCoding{
    @nonobjc static var usuario = Usuario()
    var uuid        :String = ""
    var nome        :String = ""
    var email       :String = ""
    var password    :String = ""
    var role        :String = ""
    var accessToken :String = ""
    var esportes    :[Esporte] = []
    
    struct PropertyKey {
        static let nomeKey = "nome"
        static let uuidKey = "uuid"
        static let emailKey = "email"
        static let passwordKey = "password"
        static let roleKey = "role"
        static let accessTokenKey = "accessToken"
        static let esportesKey = "esportes"
    }
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("usuario")
    
    
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
        let password = aDecoder.decodeObjectForKey(PropertyKey.passwordKey) as? String ?? ""
        let accessToken = aDecoder.decodeObjectForKey(PropertyKey.accessTokenKey) as? String ?? ""
        let role = aDecoder.decodeObjectForKey(PropertyKey.roleKey) as? String ?? ""
        let uuid = aDecoder.decodeObjectForKey(PropertyKey.uuidKey) as? String ?? ""
        
        
        
        self.init(uuid: uuid, nome: nome, email: email,password: password, role: role, accessToken: accessToken)
        
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
    // MARK Coding
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(nome, forKey: PropertyKey.nomeKey)
        aCoder.encodeObject(email, forKey: PropertyKey.emailKey)
        aCoder.encodeObject(password, forKey: PropertyKey.passwordKey)
        aCoder.encodeObject(role, forKey: PropertyKey.roleKey)
        aCoder.encodeObject(accessToken, forKey: PropertyKey.accessTokenKey)
        aCoder.encodeObject(uuid, forKey: PropertyKey.uuidKey)
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
    static func loadUsuario() -> Usuario? {
         let users = NSKeyedUnarchiver.unarchiveObjectWithFile(Usuario.ArchiveURL.path!)
        return users as? Usuario
    }
    
}