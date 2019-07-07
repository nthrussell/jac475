//
//  Utils.swift
//  jac475
//
//  Created by russell on 7/7/19.
//

import Foundation
import RadarSDK

class Utils {
    
    static let pilgrimClientID     = "L3GVFUYYDJ3ODMOQFFJQ2MYHDSQIZWG345OBC3BV1KIUQE0K"
    static let radarPublishableKey = "prj_test_pk_81c06ab3fa9fa0d2656ad26a179eff38b2eb5a6c"
    
    static func getUserId() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    static func stringForEvent(_ event: RadarEvent) -> String {
        switch event.type {
        case .userEnteredGeofence:
            return "Entered geofence \(event.geofence != nil ? event.geofence!._description : "-")"
        case .userExitedGeofence:
            return "Exited geofence \(event.geofence != nil ? event.geofence!._description : "-")"
        case .userEnteredHome:
            return "Entered home"
        case .userExitedHome:
            return "Exited home"
        case .userEnteredOffice:
            return "Entered office"
        case .userExitedOffice:
            return "Exited office"
        case .userStartedTraveling:
            return "Started traveling"
        case .userStoppedTraveling:
            return "Stopped traveling"
        case .userEnteredPlace:
            return "Entered place \(event.place != nil ? event.place!.name : "-")"
        case .userExitedPlace:
            return "Exited place \(event.place != nil ? event.place!.name : "-")"
        default:
            return "-"
        }
    }
    
    static func stringForStatus(_ status: RadarStatus) -> String {
        switch status {
        case .success:
            return "Success"
        case .errorPublishableKey:
            return "Publishable Key Error"
        case .errorPermissions:
            return "Permissions Error"
        case .errorLocation:
            return "Location Error"
        case .errorNetwork:
            return "Network Error"
        case .errorUnauthorized:
            return "Unauthorized Error"
        case .errorServer:
            return "Server Error"
        default:
            return "Unknown Error"
        }
    }
    
}
