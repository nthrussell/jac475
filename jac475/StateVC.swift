//
//  StateVC.swift
//  jac475
//
//  Created by russell on 6/7/19.
//

import UIKit
import Pilgrim
import RadarSDK
import SwiftyJSON

class StateVC: UIViewController {

    @IBOutlet var FQLocation: UILabel!
    @IBOutlet var FQAccuracy: UILabel!
    @IBOutlet var FQForeGround: UILabel!
    @IBOutlet var FQStopped: UILabel!
    
    @IBOutlet var RDLocation: UILabel!
    @IBOutlet var RDAccuracy: UILabel!
    @IBOutlet var RDForeGround: UILabel!
    @IBOutlet var RDStopped: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pilgrim()
        radar()

    }
    
    func pilgrim() {
        PilgrimManager.shared().getCurrentLocation { (currentLocation, error) in
            // Example: currentLocation.currentPlace.venue.name
            self.FQLocation.text = "\(String(describing: currentLocation))"
            print("FQLocationError: \(String(describing: error))")
        }
    }
    
    func radar() {
        Radar.trackOnce(completionHandler: { (status: RadarStatus, location: CLLocation?, events: [RadarEvent]?, user: RadarUser?) in
            DispatchQueue.main.async {
                
                let statusString = Utils.stringForStatus(status)
                print("statusString:\(statusString)")
                self.showAlert(title: statusString, message: nil)
                
                if status == .success {
                    
                    if let location = location {
                        let locationString = "lat:\(location.coordinate.latitude), lon:\(location.coordinate.longitude)"
                        self.RDLocation.text = "\(String(describing: locationString))"
                        self.RDAccuracy.text = "\(String(describing: location.horizontalAccuracy)) meters"
                    }
                    
                    if let user = user {
                        self.RDForeGround.text = "foreground:\(String(describing: user.foreground))"
                        self.RDStopped.text = "stopped:\(String(describing: user.stopped))"
                    }
                    
                    if let user = user, let geofences = user.geofences {
                        for geofence in geofences {
                            let geofenceString = geofence._description
                            print("geofenceString:\(geofenceString)")
                            self.showAlert(title: "geofenceString", message: geofenceString)
                        }
                    }
                    
                    if let user = user, let place = user.place {
                        let placeString = place.name
                        print("placeString:\(placeString)")
                        self.showAlert(title: "placeString", message: placeString)
                    }
                    
                    if let events = events {
                        for event in events {
                            let eventString = Utils.stringForEvent(event)
                            print("eventString:\(eventString)")
                            self.showAlert(title: "eventString", message: eventString)
                        }
                    }
                }
            }
        })

    }
    
    func showAlert(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert);
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
