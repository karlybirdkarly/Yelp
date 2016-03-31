//
//  MapViewController.swift
//  Yelp
//
//  Created by Karlygash Zhuginissova on 2/5/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var businesses: [Business]!

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 100
        locationManager.requestWhenInUseAuthorization()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        Business.searchWithTerm("Restaurant", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            
            for business in businesses {
                //set a location
                let lat = business.latitude!
                let long = business.longitude!
                let location = CLLocationCoordinate2DMake(lat, long)
                // Drop a pin to the locations
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = location
                dropPin.title = business.name!
                dropPin.subtitle = "\(business.address!), \(business.distance!)"
                
                self.mapView.addAnnotation(dropPin)
            }

        })
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            var span = MKCoordinateSpanMake(0.1, 0.1)
            span.longitudeDelta = mapView.region.span.longitudeDelta
            span.latitudeDelta = mapView.region.span.latitudeDelta
            
            var region = MKCoordinateRegionMake(location.coordinate, span)
            region.span = span
            mapView.setRegion(region, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
