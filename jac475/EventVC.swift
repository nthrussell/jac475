//
//  EventVC.swift
//  jac475
//
//  Created by russell on 6/7/19.
//

import UIKit
import RadarSDK
import Pilgrim

class EventVC: UIViewController {

    @IBOutlet var RDBGStatus: UILabel!
    @IBOutlet var RDBGLocation: UILabel!
    @IBOutlet var RDBGEvent: UILabel!
    @IBOutlet var RDBGIsStopped: UILabel!
    @IBOutlet var RDBGLastPlace: UILabel!
    
    @IBOutlet var RDBGLocationUpdate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Background location
        NotificationCenter.default.addObserver(self,
                                          selector: #selector(onDidReceiveLocationData(_:)),
                                          name:.RDbackgroundLocationUpdate,
                                          object: nil)
        //Background events
        NotificationCenter.default.addObserver(self,
                                          selector: #selector(onDidReceiveEventData(_:)),
                                          name:.RDBackgroundEvents,
                                          object: nil)
        //Background events
        NotificationCenter.default.addObserver(self,
                                          selector: #selector(onDidReceivePlaceData(_:)),
                                          name:.RDBackgroundUserPlace,
                                          object: nil)
        
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
                        self.RDBGLocation.text = "\(String(describing: locationString))"
                    }
                    
                    if let user = user, let geofences = user.geofences {
                        for geofence in geofences {
                            let geofenceString = geofence._description
                            print("geofenceString:\(geofenceString)")
                        }
                    }
                    
                    if let user = user, let place = user.place {
                        let placeString = place.name
                        print("placeString:\(placeString)")
                        self.RDBGStatus.text = "Place:\(placeString)"
                    }
                    
                    if let events = events {
                        for event in events {
                            let eventString = Utils.stringForEvent(event)
                            print("eventString:\(eventString)")
                            self.RDBGEvent.text = "Event:\(eventString)"
                        }
                    }
                }
            }
        })
        
    }

    
    @objc func onDidReceiveLocationData(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Double] {
            self.RDBGLocationUpdate.text = "\(data)"
        }
    }
    
    @objc func onDidReceiveEventData(_ notification: Notification) {
        if let data = notification.userInfo {
            self.RDBGEvent.text = "\(data)"
        }
    }
    
    @objc func onDidReceivePlaceData(_ notification: Notification) {
        if let data = notification.userInfo {
            self.RDBGLastPlace.text = "\(data)"
        }
    }
    
    func showAlert(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert);
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}
