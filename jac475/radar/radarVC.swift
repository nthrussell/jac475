//
//  radarVC.swift
//  jac475
//
//  Created by russell on 16/7/19.
//

import UIKit
import RadarSDK

class radarVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var radarCurrentPlaceName: UILabel!
    var radarplaces = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.radarplaces = UserDefaults.standard.stringArray(forKey: "radarPlaces") ?? [String]()
        print("radarPlaces**:\(radarplaces)")
        
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
        radar()
        
        //Background location
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onDidReceiveLocationData(_:)),
                                               name:.RDbackgroundLocationUpdate,
                                               object: nil)
  
        tableView.reloadData()
    }
    
    func radar() {
        Radar.trackOnce(completionHandler: { (status: RadarStatus, location: CLLocation?, events: [RadarEvent]?, user: RadarUser?) in
            DispatchQueue.main.async {
                
                let statusString = Utils.stringForStatus(status)
                print("statusString:\(statusString)")
                
                if status == .success {
                    
                    if let user = user, let geofences = user.geofences {
                        for geofence in geofences {
                            let geofenceString = geofence._description
                        }
                    }
                    
                    if let user = user, let place = user.place {
                        let placeString = place.name
                        self.radarCurrentPlaceName.text = "\(placeString)"
                    }
                    
                    if let events = events {
                        for event in events {
                            let eventString = Utils.stringForEvent(event)
                            print("eventString:\(eventString)")
                        }
                    }
                }
                
            }
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return radarplaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //radarCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "radarCell") as! radarCell

        var reversedNames : [String] = Array(radarplaces.reversed())
        let data = reversedNames[indexPath.row]
        cell.radarText.text = data
        
        return cell
    }

    @objc func onDidReceiveLocationData(_ notification: Notification) {
//        if let data = notification.userInfo as? [String: Double] {
//            //self.RDBGLocationUpdate.text = "\(data)"
//        }
    }

    
    func showAlert(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert);
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    

}
