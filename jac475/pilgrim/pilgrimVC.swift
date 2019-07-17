//
//  pilgrimVC.swift
//  jac475
//
//  Created by russell on 11/7/19.
//

import UIKit
import Pilgrim

class pilgrimVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
                if let place = currentLocation.currentPlace.venue {
                    self.pilgrimDescription.text = "\(String(describing: place.name))"
                    self.pilgrimPlaces.append(place.name)
                }
            }
            self.tableView.reloadData()
            print("FQLocationError: \(String(describing: error))")
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pilgrimPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pilgrimCell") as! pilgrimCell
        
        var reversedNames : [String] = Array(pilgrimPlaces.reversed())
        let data = reversedNames[indexPath.row]
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
