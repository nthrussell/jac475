//
//  AppDelegate.swift
//  jac475
//
//  Created by russell on 6/7/19.
//

import UIKit
import CoreLocation
import UserNotifications
import RadarSDK
import Pilgrim
import FacebookCore
import FBSDKPlacesKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, RadarDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager!
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //FBSDK
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Pilgrim
        PilgrimManager.shared().configure(withConsumerKey: Utils.pilgrimClientID, secret: Utils.pilgrimClientSecret, delegate: self, completion: nil)
        PilgrimManager.shared().start()
        PilgrimManager.shared().isDebugLogsEnabled = true


        //Radar
        initLocationManager()
        Radar.initialize(publishableKey: Utils.radarPublishableKey)
        Radar.setDelegate(self)
        Radar.startTracking()
        Radar.setPlacesProvider(.facebook)
        return true
    }
    
    // Location Manager helper stuff
    func initLocationManager() {
        seenError = false
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
    }
    
    // Location Manager Delegate stuff
    // If failed
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("location manager error is: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            let coord = locationObj.coordinate
            
            print("latitude: \(coord.latitude)")
            print("longitude: \(coord.longitude)")
        }
    }
    
    // authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        var shouldIAllow = false
        
        switch status {
        case CLAuthorizationStatus.restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.notDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        
        if (shouldIAllow == true) {
            // Start location services
            print("Location to Allowed")
            locationManager.startUpdatingLocation()
        } else {
            print("Denied access: \(locationStatus)")
        }
    }

    func didReceiveEvents(_ events: [RadarEvent], user: RadarUser) {
        
        for event in events {
            let eventString = Utils.stringForEvent(event)
            Utils.showNotification(title: "Event", body: eventString)
        }
        
        print("myBackgroundEvents:\(events)")
        print("myUserData: \(String(describing: user.place))")
        
        let RDBackgroundEvents = ["events": events]
        NotificationCenter.default.post(name: .RDBackgroundEvents, object: self, userInfo: RDBackgroundEvents)
        Utils.showNotification(title: "Radar Event", body: "\(events)")
        
        let RDBackgroundPlace = ["place": user.place as Any]
        NotificationCenter.default.post(name: .RDBackgroundUserPlace, object: self, userInfo: RDBackgroundPlace)
        Utils.showNotification(title: "Radar Place", body: "\(String(describing: user.place))")

    }
    
    func didUpdateLocation(_ location: CLLocation, user: RadarUser) {
        // do something with location, user
        print("radarLocationUpdate: \(location.coordinate)")
        let backGroundLocation = ["lat": location.coordinate.latitude, "lon": location.coordinate.longitude]
        NotificationCenter.default.post(name: .RDbackgroundLocationUpdate, object: self, userInfo: backGroundLocation)
        
        let state = user.stopped ? "Stopped at" : "Moved to"
        let locationString = "\(state) location (\(location.coordinate.latitude), \(location.coordinate.longitude)) with accuracy \(location.horizontalAccuracy) meters"
        Utils.showNotification(title: "Radar Location", body: locationString)
    }
    
    func didFail(status: RadarStatus) {
        // do something with status
        let statusString = Utils.stringForStatus(status)
        Utils.showNotification(title: "Radar Error", body: statusString)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension AppDelegate : PilgrimManagerDelegate {
    // Primary visit handler:
    func pilgrimManager(_ pilgrimManager: PilgrimManager, handle visit: Visit) {
        // Process the visit however you'd like:
        Utils.showNotification(title: "Pilgrim", body: "\(visit.hasDeparted ? "Departure from" : "Arrival at") \(visit.venue != nil ? visit.venue!.name : "Unknown venue."). Added a Pilgrim visit at: \(visit.displayName)")
    }
    
    // Optional: If visit occurred without network connectivity
    func pilgrimManager(_ pilgrimManager: PilgrimManager, handleBackfill visit: Pilgrim.Visit) {
        // Process the visit however you'd like:
        Utils.showNotification(title: "pilgrim without network activity", body: "Backfill \(visit.hasDeparted ? "departure from" : "arrival at") \(visit.venue != nil ? visit.venue!.name : "Unknown venue."). Added a Pilgrim backfill visit at: \(visit.displayName)")
    }
    
    // Optional: If visit occurred by triggering a geofence
    func pilgrimManager(_ pilgrimManager: PilgrimManager, handle geofenceEvents: [GeofenceEvent]) {
        // Process the geofence events however you'd like:
        geofenceEvents.forEach { geofenceEvent in
            Utils.showNotification(title: "Pilgrim geofence", body: "\(geofenceEvent)")
        }
    }
}
