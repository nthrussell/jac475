//
//  EventVC.swift
//  jac475
//
//  Created by russell on 6/7/19.
//

import UIKit
import RadarSDK

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
