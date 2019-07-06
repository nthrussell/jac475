//
//  StateVC.swift
//  jac475
//
//  Created by russell on 6/7/19.
//

import UIKit
import RadarSDK

class StateVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Radar.trackOnce(completionHandler: { (status: RadarStatus, location: CLLocation?, events: [RadarEvent]?, user: RadarUser?) in
            // do something with status, location, events, user
            print("radarStatus: \(status)")
            print("radarLocation: \(location)")
            print("radarEvents: \(events)")
            print("radarUser: \(user?.stopped)")
        })
    }
    

}
