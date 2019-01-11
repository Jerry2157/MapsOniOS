//
//  ViewController.swift
//  MapsRoman
//
//  Created by Gerardo Magdaleno on 15/11/18.
//  Copyright © 2018 Gerardo Magdaleno. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let gps = CLLocationManager()
    
    @IBOutlet weak var mapa: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configurarMapa()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var options: UIButton!
    @IBOutlet weak var hamburguer: UIButton!
    @IBOutlet weak var info: UIButton!
    @IBOutlet weak var traffic: UIButton!
    var showed = false
 
    @IBAction func trafficroads(_ sender: Any) {
        mapa.showsTraffic = true
    }
    
    @IBAction func showHamburguers(_ sender: Any) {
        populateNearByPlaces()
    }
    
    @IBAction func showmenu(_ sender: Any) {
        if showed == false{
            showed = true
            hamburguer.alpha = 1
            info.alpha = 1
            traffic.alpha = 1
        }else{
            showed = false
            hamburguer.alpha = 0
            info.alpha = 0
            traffic.alpha = 0
        }
    }
    func configurarMapa() {
        mapa.delegate = self
        gps.delegate = self
        gps.desiredAccuracy = kCLLocationAccuracyBest
        gps.requestWhenInUseAuthorization()
        
        // Tamaño inicial del mapa
        let centro = CLLocationCoordinate2DMake(19.5953, -99.2276)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegionMake(centro, span)
        mapa.region = region
        
        // Marcador en plaza de borregos (19.595402, -99.226725)
        let centroBorregos = CLLocationCoordinate2DMake(19.595402, -99.226725)
        let pin = MKPointAnnotation()
        pin.coordinate = centroBorregos
        pin.title = "Plaza Borregos"
        pin.subtitle = "Tec CEM"
        mapa.addAnnotation(pin)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // Hay permiso, iniciar las actualizaciones gps.startUpdatingLocation()
        } else if status == .denied {
            gps.stopUpdatingLocation()
            print("Puedes habilitar el gps en Ajustes") // Alerta
        }
    }
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //cambio la posicion
        mapa.setCenter(userLocation.coordinate, animated: true)
    }
    
    
    
    func populateNearByPlaces() {
        
        var region = MKCoordinateRegion()
        region.center = CLLocationCoordinate2D(latitude: self.mapa.userLocation.coordinate.latitude, longitude: self.mapa.userLocation.coordinate.longitude)
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "restaurant"
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            
            guard let response = response else {
                return
            }
            
            for item in response.mapItems {
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                
                DispatchQueue.main.async {
                    self.mapa.addAnnotation(annotation)
                }
            }

        }
    }
    
    
}







































