//
//  Plist.swift
//  SampleGame2048
//
//  Created by HuuLuong on 7/22/16.
//  Copyright © 2016 CanhDang. All rights reserved.
//

import Foundation

let plistFileName: String = "GameData"

struct Plist{
    //1
    enum PlistError: ErrorType {
        case FileNotWritten
        case FileDoesNotExist
    }
    //2
    let name: String
    //3
    var sourcePath:String? {
        guard let path = NSBundle.mainBundle().pathForResource(name, ofType: "plist") else {
            return .None
        }
        return path
    }
    //4
    var destPath:String? {
        guard sourcePath != .None else { return .None}
        let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        return (dir as NSString).stringByAppendingPathComponent("\(name).plist")
    }
    
    init?(name:String) {
        //1
        self.name = name
        //2
        let fileManager = NSFileManager.defaultManager()
        //3
        guard let source = sourcePath else { return nil }
        guard let destination = destPath else { return nil }
        //4
        if !fileManager.fileExistsAtPath(destination) {
            //5
            do {
                try fileManager.copyItemAtPath(source, toPath: destination)
            } catch let error as NSError {
                print("Unable to copy file. ERROR:\(error.localizedDescription)")
                return nil
            }
        }
    }
    
    func getValuesInPlistFile() -> NSDictionary? {
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(destPath!) {
            guard let dict = NSDictionary(contentsOfFile: destPath!) else { return .None }
            return dict
        } else {
            return .None
        }
    }
    
    func getMutablePlistFile() -> NSMutableDictionary? {
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(destPath!) {
            guard let dict = NSMutableDictionary(contentsOfFile: destPath!) else { return ( .None) }
            return dict
        } else {
            return .None
        }
    }
    
    func addValuesToPlistFile(dictionary: NSDictionary) throws {
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(destPath!) {
            if !dictionary.writeToFile(destPath!, atomically: false) {
                print("File not wrriten successfully")
                throw PlistError.FileNotWritten
            }
        } else {
            throw PlistError.FileDoesNotExist
        }
    }
    
}

class PlistManager {
    static let sharedInstance = PlistManager()
    private init() {}
    
    func startPlistManager() {
        if let _ = Plist(name: plistFileName) {
            print("[PlistManager] PlistManager started")
        }
    }
    
    func addNewItemWithKey(key: String, value:AnyObject) {
        print("[PlistManager] Starting to add item for key '\(key) with value '\(value)'. . .")
        if !keyAlreadyExists(key) {
            if let plist = Plist(name: plistFileName) {
                
                let dict = plist.getMutablePlistFile()!
                dict[key] = value
                
                do {
                    try plist.addValuesToPlistFile(dict)
                } catch {
                    print(error)
                }
                print("[PlistManager] An Action has been performed. You can check if it went ok by taking a look at the current content of the plist file: ")
                print("[PlistManager] \(plist.getValuesInPlistFile())")
            } else {
                print("[PlistManager] Unable to get Plist")
            }
        } else {
            print("[PlistManager] Item for key '\(key)' already exists. Not saving Item. Not overwrting value.")
        }
    }
    
    func saveValue(value: AnyObject, forKey: String) {
        
        if let plist = Plist(name: plistFileName) {
            
            let dict = plist.getMutablePlistFile()!
            
            if let dictValue = dict[forKey] {
                
                if value.dynamicType != dictValue.dynamicType {
                    print("[PlistManager] WARNING You are svaing a \(value.dynamicType) typed value into a \(dictValue.dynamicType) typed value. Best practice is to save Int values to Int fields, String values to String fields etc. (For examples: '_NSContiguousString' to '_NSCFString' is ok too; they are both String types) If you believe that this mismatch in the types of the values is ok and will not break your code than disregard this message.")
                    
                }
            
                dict[forKey] = value
            }
            
            do {
                try plist.addValuesToPlistFile((dict))
            } catch {
                print(error)
            }
            print("[PlistManager] An Action has been performed. You can check if it went ok by taking a look at the current content fo the plist file: ")
            print("[PlistManager] \(plist.getValuesInPlistFile())")
        } else {
            print("[PlistManager] Unable to get Plist")
        }
    }
    
    func getValueForKey(key: String) -> AnyObject? {
        var value: AnyObject?
        
        if let plist = Plist(name: plistFileName) {
            
            let dict = plist.getMutablePlistFile()!
            
            let keys = Array(dict.allKeys)
            
            if keys.count != 0 {
                
                for (_,element) in keys.enumerate() {
                    if element as! String == key {
                        print("[PlistManager] Found the Item that we were looking for key: [\(key)]")
                        value = dict[key]!
                    } else {
                        
                    }
                }
                
                if value != nil {
                    return value!
                } else {
                    print("[PlistManager] WARNING: The Item for key '\(key)' does not exist! Please, check your spelling.")
                    return .None
                }
                
            } else {
                print("[PlistManager] No Plist Item Found when searching for item with key: \(key). The Plist is Empty!")
                return .None
            }
            
        } else {
            print("{PlistManager] Unable to get Plist")
            return .None
        }
    }
    
    func keyAlreadyExists(key: String) -> Bool {
        var keyExists = false
        
        if let plist = Plist(name: plistFileName) {
            
            let dict = plist.getMutablePlistFile()!
            
            let keys = Array(dict.allKeys)
            
            if keys.count != 0 {
                
                for (_, element) in keys.enumerate() {
                    
                    if element as! String == key {
                        print("[PlistManager] Checked if item exists and found it for key: [\(key)]")
                        keyExists = true
                    } else {
                        
                    }
                }
            
            } else {
                
                keyExists = false
            }

        } else {
            
            keyExists = false
        }
        
        return keyExists
    }
    
}





















