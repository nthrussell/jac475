//
//  pilgrimVC.swift
//  jac475
//
//  Created by russell on 11/7/19.
//

import UIKit
import Pilgrim

class pilgrimVC: UIViewController, UITableViewDataSource, UITableViewDelegate, PilgrimManagerDelegate {
    
    @IBOutlet var pilgrimDescription: UITextView!
    @IBOutlet var tableView: UITableView!
    var pilgrimPlaces = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        pilgrim()
        
        //Background events
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pilgrimVenuName(_:)),
                                               name:.pilgrimVenuName,
                                               object: nil)
        
    }
    
    func pilgrim() {
        PilgrimManager.shared().getCurrentLocation { (currentLocation, error) in
            // Example: currentLocation.currentPlace.venue.name
            if let currentLocation = currentLocation {
                self.pilgrimDescription.text = "\(String(describing: currentLocation))"
            }
            print("FQLocationError: \(String(describing: error))")
            
        }
        
    }
    
    func pilgrimManager(_ pilgrimManager: PilgrimManager, handle visit: Visit) {
       let placeVisited =  "\(visit.hasDeparted ? "Departure from" : "Arrival at") \(visit.venue != nil ? visit.venue!.name : "Unknown venue."). Added a Pilgrim visit at: \(visit.displayName)"
        self.pilgrimPlaces.append(placeVisited)
        self.tableView.reloadData()
        print("pilgrimPlaces \(pilgrimPlaces)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pilgrimPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pilgrimCell") as! pilgrimCell
        
        let data = self.pilgrimPlaces[indexPath.row]
        print("pilgrimPlaces: \(data)")
        cell.textLabel?.text = data
        //cell.detailTextLabel?.text = data.descriptionOfPlace
        
        return cell
    }
    
    @objc func pilgrimVenuName(_ notification: Notification) {
//        if let data = notification.userInfo as? [String: Double] {
//
//        }
    }
    
}
