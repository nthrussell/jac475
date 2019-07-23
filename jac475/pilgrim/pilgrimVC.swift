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
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pilgrimPlaces = UserDefaults.standard.pilgrimArray
        print("pilgrimPlaces are did load: \(pilgrimPlaces)")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        pilgrim()
        
        //Background events
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pilgrimVenuName(_:)),
                                               name:.pilgrimVenuName,
                                               object: nil)
        self.tableView.reloadData()
        
        refreshControl.attributedTitle = NSAttributedString(string: "pilgrim refresh")
        refreshControl.addTarget(self, action: #selector(refreshPG(sender:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.pilgrimPlaces = UserDefaults.standard.pilgrimArray
        print("pilgrimPlaces are did apper: \(pilgrimPlaces)")
        self.tableView.reloadData()
    }
    
    func pilgrim() {
        PilgrimManager.shared().getCurrentLocation { (currentLocation, error) in
            // Example: currentLocation.currentPlace.venue.name
            if let currentLocation = currentLocation {
                if let place = currentLocation.currentPlace.venue {
                    let description = "\(currentLocation.currentPlace.hasDeparted ? "\(currentLocation.currentPlace.departureDate!)" : "\(currentLocation.currentPlace.arrivalDate!)") : \(currentLocation.currentPlace.hasDeparted ? "Departure from" : "Arrival at"):  - \(String(describing: place.name))"
                    self.pilgrimDescription.text = description
                    //self.pilgrimPlaces.append(description)
                }
            }
            print("FQLocationError: \(String(describing: error))")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pilgrimPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pilgrimCell") as! pilgrimCell
        
        var reversedNames : [String] = Array(pilgrimPlaces.reversed())
        let data = reversedNames[indexPath.row]
        print("pilgrimPlaces: \(data)")
        cell.pilgrimTxt.text = data
        return cell
    }
    
    @objc func refreshPG(sender:AnyObject) {
        // Code to refresh table view
        self.pilgrimPlaces = UserDefaults.standard.pilgrimArray
        print("pilgrimPlaces refresh: \(pilgrimPlaces)")
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc func pilgrimVenuName(_ notification: Notification) {
//        if let data = notification.userInfo as? [String: Double] {
//
//        }
    }
    
}
