//
//  KeyLoader.swift
//  Marvel
//
//  Created by Luis Sergio Duran Arenas on 30/09/23.
//

import Foundation

class KeyLoader {
    static let shared = KeyLoader()
    
    var privateKey = ""
    var publicKey = ""
    var ts = ""
    var hash = ""
    
    private init() {
        if let file = Bundle.main.url(forResource: "marvelApi", withExtension: "keys") {
            do {
                let data = try Data(contentsOf: file)
                let myKeys = try JSONDecoder().decode(Keys.self, from: data)
                privateKey = myKeys.privateKey
                publicKey = myKeys.publicKey
            } catch let error {
                print("ERROR: ", error)
            }
        } else {
            print("Couldn't load keys file")
        }
    }
    
    //        MARK: API params
    /*
     ts = timestamp
     apikey : public key
     hash param : a md5 digest of the ts parameter, your private key and your public key (e.g. md5(ts+privateKey+publicKey)
     */
    
    func getAPIParams() -> (ts: String, hash: String, apiKey: String){
        ts = (Date().timeIntervalSince1970).asString
        return (ts, (ts+self.privateKey+self.publicKey).md5, self.publicKey)
    }
    
    func getQueryString() -> String {
        ts = (Date().timeIntervalSince1970).asString
        hash = (ts+self.privateKey+self.publicKey).md5
        return "ts="+ts+"&hash="+hash+"&apikey="+self.publicKey
    }
    
    func getQueryString(limit: Int, offset: Int) -> String {
        ts = (Date().timeIntervalSince1970).asString
        hash = (ts+self.privateKey+self.publicKey).md5
        return "ts="+ts+"&hash="+hash+"&apikey="+self.publicKey+"&limit="+String(limit)+"&offset="+String(offset)

    }
}
