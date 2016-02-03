//
//  keychain.swift
//  ClinicList
//
//  Created by Radha Vignesh on 2/2/16.
//  Copyright © 2016 Radha Natesan. All rights reserved.
//

import UIKit
import Security

class Keychain {
    
    class func save(key: String, name: String) -> Bool {
        
        let data = name.dataUsingEncoding(NSUTF8StringEncoding)
        
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data!]
        
        SecItemDelete(query as CFDictionaryRef)
        
        let status: OSStatus = SecItemAdd(query as CFDictionaryRef, nil)
        
        return status == noErr
    }
    
    class func load(key: String) -> String? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue,
            kSecMatchLimit as String  : kSecMatchLimitOne ]
        
        var dataTypeRef :AnyObject?
        
        let status: OSStatus = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == noErr {
            let datastring = String(data: (dataTypeRef as? NSData)!, encoding: NSUTF8StringEncoding)
            return datastring
        } else {
            return ""
        }
    }
    
    class func delete(key: String) -> Bool {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key ]
        
        let status: OSStatus = SecItemDelete(query as CFDictionaryRef)
        
        return status == noErr
    }
    
    
    class func clear() -> Bool {
        let query = [ kSecClass as String : kSecClassGenericPassword ]
        
        let status: OSStatus = SecItemDelete(query as CFDictionaryRef)
        
        return status == noErr
    }
    
}
