//
//  EventVC.swift
//  jac475
//
//  Created by russell on 6/7/19.
//

import UIKit
import RadarSDK

class EventVC: UIViewController {
    
    @IBOutlet var RDFGStatus: UILabel!
    @IBOutlet var RDFGLocation: UILabel!
    @IBOutlet var RDFGEvent: UILabel!
    @IBOutlet var RDFGIsStopped: UILabel!
    @IBOutlet var RDFGLastPlace: UILabel!
    

    @IBOutlet var RDBGStatus: UILabel!
    @IBOutlet var RDBGLocation: UILabel!
    @IBOutlet var RDBGEvent: UILabel!
    @IBOutlet var RDBGIsStopped: UILabel!
    @IBOutlet var RDBGLastPlace: UILabel!
    
    @IBOutlet var RDBGLocationUpdate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Radar.trackOnce(completionHandler: { (status: RadarStatus, location: CLLocation?, events: [RadarEvent]?, user: RadarUser?) in
            // do something with status, location, events, user
            self.RDFGStatus.text = "Status: \(status)"
            self.RDFGLocation.text = "Loc: \(location)"
            self.RDFGEvent.text = "Events: \(events)"
            self.RDFGIsStopped.text = "isStop: \(user?.stopped)"
            self.RDFGLastPlace.text = "LastPlace: \(user?.place)"
        })
        
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
