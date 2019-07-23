//
//  extensions.swift
//  jac475
//
//  Created by russell on 7/7/19.
//

import Foundation

extension Notification.Name {
    static let RDbackgroundLocationUpdate = Notification.Name("RDbackgroundLocationUpdate")
    static let RDBackgroundEvents         = Notification.Name("RDBackgroundEvents")
    static let RDBackgroundUserPlace      = Notification.Name("RDBackgroundUserPlace")
    
    static let pilgrimVenuName = Notification.Name("pilgrimVenuName")
}

extension UserDefaults {
    var radarArray: [String] {
        get {
            if let radarArray = UserDefaults.standard.object(forKey: "radarArray") as? [String] {
                return radarArray
            } else {
                return []
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "radarArray")
        }
    }
}

extension UserDefaults {
    var pilgrimArray: [String] {
        get {
            if let pilgrimArray = UserDefaults.standard.object(forKey: "pilgrimArray") as? [String] {
                return pilgrimArray
            } else {
                return []
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "pilgrimArray")
        }
    }
}


