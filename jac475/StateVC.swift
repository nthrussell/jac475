//
//  StateVC.swift
//  jac475
//
//  Created by russell on 6/7/19.
//

import UIKit
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
    
    override func viewDidAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
//        Radar.trackOnce(completionHandler: { (status: RadarStatus, location: CLLocation?, events: [RadarEvent]?, user: RadarUser?) in
//            // do something with status, location, events, user
//            print("radarStatus: \(status)")
//            print("radarLocation: \(String(describing: location))")
//            print("radarEvents: \(String(describing: events))")
//            print("radarUser: \(String(describing: user))")
//
//            if let location = location,
//                let events = events,
//                 let user = user {
//                    self.RDLocation.text = "\(String(describing: location))"
//                    self.RDAccuracy.text = "\(String(describing: events))"
//                    self.RDForeGround.text = "\(String(describing: user.foreground))"
//                    self.RDStopped.text = "\(String(describing: user.stopped))"
//                }
//        })

    }
    
    func showAlert(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert);
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
