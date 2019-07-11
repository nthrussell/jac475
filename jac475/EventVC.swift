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
    
    func pilgrimManager(_ pilgrimManager: PilgrimManager, didVisit visit: Visit) {
        
         print("\(visit.hasDeparted ? "Departure from" : "Arrival at") \(visit.venue != nil ? visit.venue!.name : "Unknown venue."). Added a Pilgrim visit at: \(visit.displayName)")
        
        if pilgrimManager.hasHomeOrWork() {
            // Home and work are set. Lets print them out
            print(pilgrimManager.homeLocations)
            print(pilgrimManager.workLocations)
            
        } else if visit.confidence != .high {
            // Home and work aren't set and visit confidence isn't High
            // Depending on my application I might not want to trust this visit
        }
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

}
