//
//  AppDelegate.swift
//  jac475
//
//  Created by russell on 6/7/19.
//

import UIKit
import CoreLocation
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

        //Mr Jamal Cole //prj_test_pk_81c06ab3fa9fa0d2656ad26a179eff38b2eb5a6c
        initLocationManager()
        Radar.initialize(publishableKey: "prj_test_pk_81c06ab3fa9fa0d2656ad26a179eff38b2eb5a6c")
        Radar.setDelegate(self)
        Radar.setPlacesProvider(.facebook)
        Radar.startTracking()
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
        if ((error) != nil) {
            if (seenError == false) {
                seenError = true
                print("error is: \(error)")
            }
        }
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
        print("myBackgroundEvents:\(events)")
        print("myUserData: \(user.place)")
        
        let RDBackgroundEvents = ["events": events]
        NotificationCenter.default.post(name: .RDBackgroundEvents, object: self, userInfo: RDBackgroundEvents)
        
        let RDBackgroundPlace = ["place": user.place as Any]
        NotificationCenter.default.post(name: .RDBackgroundUserPlace, object: self, userInfo: RDBackgroundPlace)

    }
    
    func didUpdateLocation(_ location: CLLocation, user: RadarUser) {
        // do something with location, user
        print("radarLocationUpdate: \(location.coordinate)")
        let backGroundLocation = ["lat": location.coordinate.latitude, "lon": location.coordinate.longitude]
        NotificationCenter.default.post(name: .RDbackgroundLocationUpdate, object: self, userInfo: backGroundLocation)
    }
    
    func didFail(status: RadarStatus) {
        // do something with status
        print("radar fail status: \(status)")
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

