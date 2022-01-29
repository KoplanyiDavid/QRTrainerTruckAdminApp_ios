//
//  HomeViewController.swift
//  QRTrainerTruckAdminApp
//
//  Created by Koplányi Dávid on 2021. 11. 14..
//

import UIKit
import Firebase
import FirebaseDatabase
import MapKit

class HomeViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func startLocationSharing(_ sender: Any) {
        
        LocationManager.shared.getLocation { [weak self] location in
            DispatchQueue.main.async {
                self!.updateTrainerTruckLocation(location: location)
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getTruckLocation(map: mapView)
    }
    
    func updateTrainerTruckLocation(location: CLLocation) {
        
        Database.database().reference().child("TrainerTruckLocation/latitude").setValue(location.coordinate.latitude)
        Database.database().reference().child("TrainerTruckLocation/longitude").setValue(location.coordinate.longitude)

        
    }
    
    func getTruckLocation(map: MKMapView) {

        let realtimeDb = Database.database().reference().child("TrainerTruckLocation")
        realtimeDb.observe(DataEventType.value, with: { snapshot in
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: snapshot.childSnapshot(forPath: "latitude").value as! Double, longitude: snapshot.childSnapshot(forPath: "longitude").value as! Double)
            annotation.title = "Trainer Truck"
            map.addAnnotation(annotation)
            
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            map.setRegion(region, animated: true)
        })
    }
}
