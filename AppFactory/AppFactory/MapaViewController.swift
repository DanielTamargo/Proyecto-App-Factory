//
//  MapaViewController.swift
//  AppFactory
//
//  Created by  on 23/01/2020.
//  Copyright © 2020 Daniel Tamargo Saiz. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapaViewController: UIViewController {

    
    @IBOutlet weak var mapa: MKMapView!
    
    @IBOutlet weak var selector: UISegmentedControl!
    
    let servicioLocalizacion = CLLocationManager()
    var regionEnMetros: Double = 400
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comprobarServicioLocalizacion()
    }
    
    // Configura el servicio de localización
    func configurarServicioLocalizacion() {
        servicioLocalizacion.delegate = self
        servicioLocalizacion.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // Centra la vista en la localización del usuario
    func centrarVistaEnLocalizacionUsuario() {
        if let localizacion = servicioLocalizacion.location?.coordinate {
            let region = MKCoordinateRegion.init(center: localizacion, latitudinalMeters: regionEnMetros, longitudinalMeters: regionEnMetros)
            mapa.setRegion(region, animated: true)
        }
    }
    
    // Comprueba el servicio de localización
    func comprobarServicioLocalizacion() {
        if CLLocationManager.locationServicesEnabled() {
            //Configurar (set up) nuestro location manager
            configurarServicioLocalizacion()
            //Comprobar la autorización para el servicio de localización
            comprobarAutorizacionLocalizacion()
        } else {
            //Mostrar alerta para que el usuario active la ubicación
            // ¿cuándo se llegaría aquí?
            
            
            
        }
    }
    
    // Comprueba la autorización del servicio de localización
    func comprobarAutorizacionLocalizacion() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            //Funciona solo cuando la aplicación está abierta.
            // Trabajar con el mapa
            mapa.showsUserLocation = true
            centrarVistaEnLocalizacionUsuario()
            servicioLocalizacion.startUpdatingLocation()
            break
        case .authorizedAlways:
            //Funciona siempre, incluso cuando está en en segundo plano
            //No es lo ideal, invade la privacidad
            // Trabajar con el mapa (?) no lo tengo muy claro
            mapa.showsUserLocation = true
            centrarVistaEnLocalizacionUsuario()
            servicioLocalizacion.startUpdatingLocation()
            
            break
        case .denied:
            // Mostrar alerta para que configuren su propio sistema de localización
            // Mostrar alerta mostrando cómo activar los permisos
            
            break
        case .notDetermined:
            // Aún no han seleccionado si permiten o no permiten
            // Pedimos autorización (quizás esté en inglés)
            servicioLocalizacion.requestWhenInUseAuthorization()
            //comprobarAutorizacionLocalizacion() //<- no hace falta porque he implementado la función locationManager dentro de la extensión, esta función se encarga de esto mismo, arrancar la aplicación conforme a los cambios que haya hecho con la autorización
            break
        case.restricted:
            // Acceso restringido y la app no funcionará bien
            // Mostrar una alerta para enseñarles qué sucede
            
            
            break
        default:
            break
        }
    }
    
    
    
    @IBAction func cambiarAmplitud(_ sender: Any) {
        //Cambia la amplitud con la que se ve el mapa
        switch selector.selectedSegmentIndex {
        case 0:
            regionEnMetros = 400
            comprobarAutorizacionLocalizacion()
        case 1:
            regionEnMetros = 1000
            comprobarAutorizacionLocalizacion()
        case 2:
            regionEnMetros = 10000
            comprobarAutorizacionLocalizacion()
        default:
            //Nada
            print("Hola")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapaViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations localizaciones: [CLLocation]) {
        guard let localizacion = localizaciones.last else { return }
        let centro = CLLocationCoordinate2D(latitude: localizacion.coordinate.latitude, longitude: localizacion.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: centro, latitudinalMeters: regionEnMetros, longitudinalMeters: regionEnMetros)
        mapa.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        comprobarAutorizacionLocalizacion()
    }
}
