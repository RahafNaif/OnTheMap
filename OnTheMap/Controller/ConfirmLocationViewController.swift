//
//  ConfirmLocationViewController.swift
//  OnTheMap
//
//  Created by Rahaf Naif on 28/10/1441 AH.
//  Copyright © 1441 Rahaf Naif. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class ConfirmLocationViewController : UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    struct locationInfo {
      static var location = ""
      static var link = ""
      static var lat = 0.0
      static var long = 0.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        var annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: locationInfo.lat , longitude: locationInfo.long)
        zoomingMap(coordinate, mapView: mapView)
        annotation.coordinate = coordinate
        
        annotation.title = "hhh"
        annotation.subtitle = "\(locationInfo.link)"
        
        self.mapView.addAnnotation(annotation)
        
    }
    
//    func getUser()->String{
//
//        let uid = Auth.auth().currentUser?.uid
//        var username = ""
//        Database.database().reference().child("users").child(uid!).child("username").observeSingleEvent(of: .value) { (snapshot) in
//            guard let user = snapshot.value as? String else { return }
//            username = user
//        }
//        return username
//    }
    
    @IBAction func finishTapped(_ sender: Any) {
        parseAPI.postRequest(location: locationInfo.location, link: locationInfo.link, lat: locationInfo.lat, long: locationInfo.long) {(StudentLocationList ,error) in
            guard error == nil else{
                self.showFailure(title: "Error", message: "\(error)")
                return
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func zoomingMap(_ location: CLLocationCoordinate2D, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
    func showFailure(title: String ,message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: false, completion: nil)
    }
    
}
