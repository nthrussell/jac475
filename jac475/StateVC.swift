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
    @IBOutlet var FQStatus: UITextView!
    
    
    @IBOutlet var RDLocation: UILabel!
    @IBOutlet var RDAccuracy: UILabel!
    @IBOutlet var RDForeGround: UILabel!
    @IBOutlet var RDStopped: UILabel!
    @IBOutlet weak var RDPlaceName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pilgrim()
        radar()
    }
    
    func pilgrim() {
        PilgrimManager.shared().getCurrentLocation { (currentLocation, error) in
            // Example: currentLocation.currentPlace.venue.name
            if let currentLocation = currentLocation {
                if let place = currentLocation.currentPlace.venue {
                    let description = "\(currentLocation.currentPlace.hasDeparted ? "\(currentLocation.currentPlace.departureDate!)" : "\(currentLocation.currentPlace.arrivalDate!)") : \(currentLocation.currentPlace.hasDeparted ? "Departure from" : "Arrival at"):  - \(String(describing: place.name)) \nCategory:\(place.primaryCategory!.name)"
                    
                    self.FQStatus.text = "\(String(describing: currentLocation))"
                    UserDefaults.standard.pilgrimArray.append(description)
                }
            }

            print("FQLocationError: \(String(describing: error))")
        }
    }
    
    func radar() {
        Radar.trackOnce(completionHandler: { (status: RadarStatus, location: CLLocation?, events: [RadarEvent]?, user: RadarUser?) in
            DispatchQueue.main.async {
                
                let statusString = Utils.stringForStatus(status)
                self.showAlert(title: "Radar Status", message: statusString)
                
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
                            UserDefaults.standard.radarArray.append("geofence:\(geofenceString)")
                        }
                    }
                    
                    if let user = user, let place = user.place {
                        let placeString = place.name
                        let myCategory = place.categories
                        self.RDPlaceName.text = placeString
                        
                        if let timeStamp = location?.timestamp {
                            UserDefaults.standard.radarArray.append("\(timeStamp):\(placeString) \nCategories: \(myCategory)")
                        } else {
                            UserDefaults.standard.radarArray.append("\(placeString) \nCategories: \(myCategory)")
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
    
    
    @IBAction func reload(_ sender: Any) {
        pilgrim()
        radar()
    }
    
}
