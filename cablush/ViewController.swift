//
//  ViewController.swift
//  cablush
//
//  Created by Jonathan on 21/03/16.
//  Copyright © 2016 com.Cablush. All rights reserved.
//

import UIKit
import MapKit

enum SlideOutState {
    case BothCollapsed
    case LeftPanelExpanded
    case RightPanelExpanded
}

@objc
protocol ViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func toggleRightPanel()
    optional func collapseSidePanels()
}
class ViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate  {
    // MARK: Button actions
    
    @IBAction func menuTapped(sender: AnyObject) {
        delegate?.toggleLeftPanel?()
    }
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    var delegate: ViewControllerDelegate?
    
    
    override func viewDidLoad() {
        self.mapView.delegate = self
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {}
    
    func centerMapOnLocation(regionRadius : CLLocationDistance) {
        if locationManager.location != nil {
            let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
            
            let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            mapView.showsCompass = true
            mapView.showsUserLocation = true
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func putMapAnotation(pin :CLLocationCoordinate2D, localizavel :Localizavel){
        let dropPin = CustomAnnotation()
        dropPin.coordinate = pin
        dropPin.title = localizavel.nome
        
        dropPin.subtitle = localizavel.descricao
        dropPin.imageName = getPinColor(localizavel)
        
        mapView.addAnnotation(dropPin)
    }
    
    func getPinColor(localizavel : Localizavel) -> String{
        var imageName = ""
        if let _ = localizavel as? Pista{
            imageName = "ic_mark_cablush_orange.png"
        }else if let _ = localizavel as? Evento{
            imageName = "ic_mark_cablush_blue.png"
        }else if let _ = localizavel as? Loja{
            imageName = "ic_mark_cablush_green.png"
        }
        return imageName
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
        }
        else {
            anView!.annotation = annotation
        }
        
        let btnInfo = UIButton(type: UIButtonType.DetailDisclosure)
        btnInfo.addTarget(self, action: "detail", forControlEvents: UIControlEvents.TouchDown)
        anView?.rightCalloutAccessoryView = btnInfo
        
        let cpa = annotation as! CustomAnnotation
        
        let pinImage = UIImage(named: cpa.imageName)
        let size = CGSize(width: 42, height: 42)
        UIGraphicsBeginImageContext(size)
        pinImage!.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        anView!.image = resizedImage
        
        return anView
    }
}

extension ViewController: SidePanelViewControllerDelegate {
    func requestDataPistas() {
        mapView.removeAnnotations(mapView.annotations)
        let dataRequest = DataRequest();
        dataRequest.data_request("pistas") { (data) -> Void in
            var pistas = [Pista]()
            if data != nil{
                let parseJson = ParseJson()
                pistas = parseJson.parseJsonPista(data!)
            }
            for pista in pistas{
                let pin = CLLocationCoordinate2D(latitude: pista.local.latitude, longitude: pista.local.longitude)
                self.putMapAnotation(pin,localizavel: pista)
                
            }
        }
        let regionRadius: CLLocationDistance = 15000
        self.centerMapOnLocation(regionRadius)
        delegate?.toggleLeftPanel?()
    }
    func requestDataLojas(){
        mapView.removeAnnotations(mapView.annotations)
        let dataRequest = DataRequest();
        dataRequest.data_request("lojas") { (data) in
            var lojas = [Loja]()
            if data != nil{
                let parseJson = ParseJson()
                lojas = parseJson.parseJsonLoja(data!)
            }
            for loja in lojas{
                for local in loja.locais{
                    let pin = CLLocationCoordinate2D(latitude: local.latitude, longitude: local.longitude)
                    self.putMapAnotation(pin,localizavel: loja)
                }
            }
        }
        let regionRadius: CLLocationDistance = 15000
        self.centerMapOnLocation(regionRadius)
     delegate?.toggleLeftPanel?()
    }
    
    func requestDataEventos(){
        mapView.removeAnnotations(mapView.annotations)
        let dataRequest = DataRequest();
        dataRequest.data_request("eventos") { (data) -> Void in
            var eventos = [Evento]()
            if data != nil{
                let parseJson = ParseJson()
                eventos = parseJson.parseJsonEvento(data!)
            }
            for evento in eventos{
                let pin = CLLocationCoordinate2D(latitude: evento.local.latitude, longitude: evento.local.longitude)
                self.putMapAnotation(pin,localizavel: evento)
            }
        }
        let regionRadius: CLLocationDistance = 15000
        self.centerMapOnLocation(regionRadius)
      delegate?.toggleLeftPanel?()
    }
}

