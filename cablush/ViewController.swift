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

    @IBAction func menuTapped(sender: AnyObject) {
        delegate?.toggleLeftPanel?()
    }
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    var delegate: ViewControllerDelegate?
    var localizaveis = [Localizavel]()
    var selectedLocalizavel = Localizavel()
    
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
        centerMapOnLocation(regionRadius)
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {}
    
    func centerMapOnLocation(regionRadius : CLLocationDistance) {
        if locationManager.location != nil {
            let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
            
            let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            if #available(iOS 9.0, *) {
                mapView.showsCompass = true
                mapView.showsUserLocation = true
            } 
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
            imageName = "ic_mark_cablush_orange"
        }else if let _ = localizavel as? Evento{
            imageName = "ic_mark_cablush_blue"
        }else if let _ = localizavel as? Loja{
            imageName = "ic_mark_cablush_green"
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
        
        let rightButton: AnyObject! = UIButton(type: UIButtonType.DetailDisclosure)
        anView?.rightCalloutAccessoryView = rightButton as? UIView
        
        let cpa = annotation as! CustomAnnotation
        
        let pinImage = UIImage(named: cpa.imageName)
         anView!.image = pinImage!
        return anView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            getSelectedLocalizavel((view.annotation?.coordinate)!)
            performSegueWithIdentifier("LocalizavelDetail", sender: self)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "LocalizavelDetail"){
            let localizavelDetalhesVC = segue.destinationViewController as! LocalizavelDetalhesViewController
            localizavelDetalhesVC.localizavel = selectedLocalizavel
        }
    }
    
    
    
    func getSelectedLocalizavel(coordenada : CLLocationCoordinate2D){
        for localizavel in self.localizaveis {
            if let pista = localizavel as? Pista{
                if(pista.local.latitude == coordenada.latitude && pista.local.longitude == coordenada.longitude){
                    selectedLocalizavel  = pista
                }
            }else if let loja = localizavel as? Loja{
                for local in loja.locais{
                    if(local.latitude == coordenada.latitude && local.longitude == coordenada.longitude){
                        selectedLocalizavel  = loja
                    }
                }
            }else if let evento = localizavel as? Evento{
                if(evento.local.latitude == coordenada.latitude && evento.local.longitude == coordenada.longitude){
                    selectedLocalizavel  = evento
                }
            }
        }
    }
    
}

extension ViewController: SidePanelViewControllerDelegate {
   
    
    func showDialogWait(){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .Alert)
        
        alert.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        presentViewController(alert, animated: true, completion: nil)
    }
 
    func requestDataPistas() {
        showDialogWait()
        mapView.removeAnnotations(mapView.annotations)
        
            let dataRequest = DataRequest();
            dataRequest.data_request("pistas") { (data) -> Void in
                var pistas = [Pista]()
                if data != nil{
                    let parseJson = ParseJson()
                    pistas = parseJson.parseJsonPista(data!)
                }
                self.localizaveis = pistas
                for pista in pistas{
                    let pin = CLLocationCoordinate2D(latitude: pista.local.latitude, longitude: pista.local.longitude)
                    self.putMapAnotation(pin,localizavel: pista)
                }
                dispatch_async(dispatch_get_main_queue(),{
                    let regionRadius: CLLocationDistance = 15000
                    self.centerMapOnLocation(regionRadius)
                 });
            self.dismissViewControllerAnimated(false, completion: nil)
            }
        
        delegate?.toggleLeftPanel?()
    }
    
    func requestDataLojas(){
        showDialogWait()
        mapView.removeAnnotations(mapView.annotations)
            let dataRequest = DataRequest();
            dataRequest.data_request("lojas") { (data) in
                var lojas = [Loja]()
                if data != nil{
                    let parseJson = ParseJson()
                    lojas = parseJson.parseJsonLoja(data!)
                }
                self.localizaveis = lojas
                for loja in lojas{
                    for local in loja.locais{
                        let pin = CLLocationCoordinate2D(latitude: local.latitude, longitude: local.longitude)
                        self.putMapAnotation(pin,localizavel: loja)
                    }
                }
                dispatch_async(dispatch_get_main_queue(),{
                    let regionRadius: CLLocationDistance = 15000
                    self.centerMapOnLocation(regionRadius)
                });
                self.dismissViewControllerAnimated(false, completion: nil)
            }
     delegate?.toggleLeftPanel?()
    }
    
    func requestDataEventos(){
        showDialogWait()
        mapView.removeAnnotations(mapView.annotations)
            let dataRequest = DataRequest();
            dataRequest.data_request("eventos") { (data) -> Void in
                var eventos = [Evento]()
                if data != nil{
                    let parseJson = ParseJson()
                    eventos = parseJson.parseJsonEvento(data!)
                }
                self.localizaveis = eventos
                for evento in eventos{
                    let pin = CLLocationCoordinate2D(latitude: evento.local.latitude, longitude: evento.local.longitude)
                    self.putMapAnotation(pin,localizavel: evento)
                }
                dispatch_async(dispatch_get_main_queue(),{
                    let regionRadius: CLLocationDistance = 15000
                    self.centerMapOnLocation(regionRadius)
                });
                self.dismissViewControllerAnimated(false, completion: nil)
            }
        
      delegate?.toggleLeftPanel?()
    }
}

