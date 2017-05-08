//
//  Registry.swift
//  HenriPotier
//
//  Created by Rémi Caroff on 08/05/2017.
//  Copyright © 2017 Rémi Caroff. All rights reserved.
//

import UIKit
import Foundation

class Registry: NSObject {
    
    static let instance = Registry()
    
    private override init() {}
    
    func set(key: String, value: String) {
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func get(key: String) -> String {
        if(!self.has(key: key)) {
            return ""
        }
        
        return UserDefaults.standard.string(forKey: key)!
    }
    
    func has(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func del(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func setDisaprovedMode(enabled: Bool) {
        if enabled {
            self.set(key: "disaprove", value: "yes")
        } else {
            self.del(key: "disaprove")
        }
    }
    
    

}
