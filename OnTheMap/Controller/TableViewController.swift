//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Rahaf Naif on 25/10/1441 AH.
//  Copyright © 1441 Rahaf Naif. All rights reserved.
//

import UIKit

class TableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var locations = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        parseAPI.getRequest(completionHandler: {(StudentLocationList,error) in
            
            self.locations = StudentLocationList!.results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell")!
        let location = self.locations[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = "\(location.firstName) \(location.lastName)"
        cell.detailTextLabel?.text = location.mediaURL
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let location = locations[indexPath.row]
        let url = URL(string: location.mediaURL)
        if let safeURL = url {
            UIApplication.shared.open(safeURL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        UdacityAPI.deleteSession(completionHandler:{ (error) in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
}
