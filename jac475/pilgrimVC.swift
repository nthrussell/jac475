//
//  pilgrimVC.swift
//  jac475
//
//  Created by russell on 11/7/19.
//

import UIKit
import Pilgrim

class pilgrimVC: UIViewController {
    
    @IBOutlet var pilgrimDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Background events
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pilgrimVenuName(_:)),
                                               name:.pilgrimVenuName,
                                               object: nil)
        
        pilgrim()
        
    }
    
    func pilgrim() {
        PilgrimManager.shared().getCurrentLocation { (currentLocation, error) in
            // Example: currentLocation.currentPlace.venue.name
            if let currentLocation = currentLocation {
                self.pilgrimDescription.text = "\(String(describing: currentLocation))"
            }
            print("FQLocationError: \(String(describing: error))")

        }
        
       _ = PilgrimManager.shared().triggerDescriptions
        
    }
    
    @objc func pilgrimVenuName(_ notification: Notification) {
//        if let data = notification.userInfo as? [String: Double] {
//
//        }
    }
    
}
