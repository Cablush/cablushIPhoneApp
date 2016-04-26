//
//  Pista.swift
//  Cablush
//
//  Created by Jonathan on 09/03/16.
//  Copyright © 2016 Cablush. All rights reserved.
//

import Foundation
class Pista: Localizavel,NSCoding {
    var horario = Horario()
    var local = Local()
    var video :String = ""
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("pista")
    
    override init(){
        super.init()
    }
    
    // MARK: Types
    
    struct PropertyKey {
        static let videoKey = "video"
    }
    init(uuid: String, nome: String, descricao: String, facebook: String, website: String, img_url: String, fundo: Bool, responsavel_uuid: String, video :String) {
       
        super.init(uuid: uuid, nome: nome, descricao: descricao, facebook: facebook, website: website, img_url: img_url, fundo:fundo, responsavel_uuid:responsavel_uuid)
        
        self.video = video
    }
    
    // MARK: NSCoding
    
    override func encodeWithCoder(aCoder: NSCoder) {
       super.encodeWithCoder(aCoder)
        aCoder.encodeObject(video, forKey: PropertyKey.videoKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        let nome        = aDecoder.decodeObjectForKey(LocalizavelPropertyKey.nomeKey) as! String
        let uuid        = aDecoder.decodeObjectForKey(LocalizavelPropertyKey.uuidKey) as! String
        let descricao   = aDecoder.decodeObjectForKey(LocalizavelPropertyKey.descricaoKey) as! String
        let facebook    = aDecoder.decodeObjectForKey(LocalizavelPropertyKey.facebookKey) as? String ?? ""
        let website     = aDecoder.decodeObjectForKey(LocalizavelPropertyKey.websiteKey) as? String ?? ""
        let img         = aDecoder.decodeObjectForKey(LocalizavelPropertyKey.imgKey) as? String ?? ""
        let fundo       = aDecoder.decodeObjectForKey(LocalizavelPropertyKey.fundoKey) as? Bool ?? false
        let responsavel = aDecoder.decodeObjectForKey(LocalizavelPropertyKey.responsavelKey) as? String ?? ""
        let video       = aDecoder.decodeObjectForKey(PropertyKey.videoKey) as? String ?? ""
        
        self.init(uuid: uuid, nome: nome, descricao: descricao, facebook: facebook, website: website, img_url: img, fundo:fundo, responsavel_uuid:responsavel, video:video)
    }
    
    //Saving
    func save()-> Bool{
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self, toFile: Pista.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save pista...")
            return false
        }else{
            print("Pista \(self.nome) saved!")
            return true
        }
    }
    //loading
    static func loadPistas() -> [Pista]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Pista.ArchiveURL.path!) as? [Pista]
    }

}