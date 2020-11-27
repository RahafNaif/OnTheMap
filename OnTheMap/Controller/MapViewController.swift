//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Rahaf Naif on 24/10/1441 AH.
//  Copyright © 1441 Rahaf Naif. All rights reserved.
//

import UIKit
import MapKit

class MapViewController : UIViewController, MKMapViewDelegate{
  
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var annotations = [MKPointAnnotation]()
        mapView.delegate = self

        
        parseAPI.getRequest(completionHandler:{ (StudentLocationList, error) in
                    
            for StudentLocation in StudentLocationList?.results ?? [] {
                
                let lat = CLLocationDegrees(StudentLocation.latitude ?? 0.0)
                let long = CLLocationDegrees(StudentLocation.longitude ?? 0.0)
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = StudentLocation.firstName
                let last = StudentLocation.lastName
                let mediaURL = StudentLocation.mediaURL
                
                // Here we create the annotation and set its coordiate, title, and subtitle properties
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
                
            }
            self.mapView.addAnnotations(annotations)
        })

        
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
                if verifyUrl(urlString: toOpen){
                    app.openURL(URL(string: toOpen)!)
                }//for the last review the url is vaild by the verifyUrl func
            }
        }
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return true
            }
        }
        return false
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
    
        UdacityAPI.deleteSession(completionHandler:{ (error) in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
            
        
}
        
    

    

