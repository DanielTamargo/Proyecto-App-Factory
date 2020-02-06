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
import RealmSwift

class MapaViewController: UIViewController, MKMapViewDelegate {

    // ---------------------------------------------------------------------------------------------------------------------------
    // Variables que vienen de la parte gráfica
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var selector: UISegmentedControl!
    
    @IBOutlet weak var labelTemporizador: UILabel!
    @IBOutlet weak var iniciar: UIButton!
    @IBOutlet weak var finalizar: UIButton!
    @IBOutlet weak var distanciaLabel: UILabel!
    
    
    var registro = Registro()
    var usuario = Usuario()
    
    // Variables que utilizaremos para el temporizador (mostrarlo en labelTemporizador)
    var temporizador = Timer()
    var temporizadorEstaON = false
    var contador = 0.0

    var fecha_inicio: Date?
    var distancia_total = 0.0
    
    //var evitarCoordenadasRepetidas = 0
    
    // Variables internas
    var tipoActividad: String = "" //<- caminar/correr/bici , mejor que sea una enumeración <- pasamos este valor desde fuera
    var listaCoordenadas = [CLLocationCoordinate2D]() //<- guardar las coordenadas con X frecuencia
    var listaCoordenadasTotal = [[CLLocationCoordinate2D]]() //<- lista de las listas de coordenadas
    
    var fechaInicio = "" //<- fecha y hora
    var fechaFin = "" //<- fecha y hora
    
    let servicioLocalizacion = CLLocationManager()
    var regionEnMetros: Double = 400
    var distanciaActualizacion: Int = 10
    
    // BBDD
    let realm = try! Realm()
    
    // Selector -> Cambia la amplitud con la que vemos el mapa
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
            regionEnMetros = 2000
            comprobarAutorizacionLocalizacion()
        default:
            //Nada
            print("Hola")
        }
    }
    
    // Controla la función de finalizar
    @IBAction func finalizar(_ sender: Any) {
        
        //TODO : IMPORTANTE, como por ahora no elijo usuario, ¡¡¡¡utilizo siempre el mismo usuario de la BBDD!!!! si implemento usuarios, ¡¡¡cambiar esto!!!
        let realm = try! Realm()
        usuario = realm.objects(Usuario.self).first!
        print(usuario.nickname)
        
        
        // Guardar el registro en la BBDD y añadirselo al usuario
        temporizadorEstaON = false
        
        //let registro = Registro()
        
        let registros = realm.objects(Registro.self)
        
        registro.id = registros.count + 1
        registro.fecha = fecha_inicio
        registro.distancia = distancia_total //<- falta calcular distancia entre puntos //es un double
        registro.actividad = tipoActividad
        registro.usuario = usuario
        
        let t_contadorTiempo = Int(floor(contador))
        let t_horas = t_contadorTiempo / 3600
        let t_minutos = (t_contadorTiempo % 3600) / 60
        let t_segundos = (t_contadorTiempo % 60) % 60
        
        registro.tiempo.append(t_horas)
        registro.tiempo.append(t_minutos)
        registro.tiempo.append(t_segundos)
        
        for lista in listaCoordenadasTotal {
            for coordenada in lista {
                registro.listaLatitudes.append(String(coordenada.latitude))
                registro.listaLongitudes.append(String(coordenada.longitude))
            }
            registro.listaLongitudes.append("pausa")
            registro.listaLatitudes.append("pausa")
        }
        
        try! realm.write {
            realm.add(registro)
            print("Registro añadido")
            performSegue(withIdentifier: "registroTrasRecorrido", sender: self)
        }
        
    }
    
    // Iniciar ó Pausar ó Reanudar -> Controla lo que sucede cuando se aprieta este botón (el cual va cambiando conforme se usa)
    // Pone en marcha, para y reanuda el cronómetro
    @IBAction func iniciarPausarReanudar(_ sender: Any) {
        let textoBotonIniciar = iniciar.titleLabel?.text

        fecha_inicio = Date()
        
        if textoBotonIniciar == "Iniciar" {
            print("Iniciando recorrido")
            self.mapView.delegate = self
            
            temporizadorEstaON = true
            temporizadorON()
            
            finalizar.isEnabled = true
            iniciar.setTitle("Pausar", for: .normal)
        } else  {
            if temporizadorEstaON {
                print("Pausando recorrido")
                
                temporizadorEstaON = false
                
                iniciar.setTitle("Reanudar", for: .normal)
            } else {
                print("Reanudando recorrido")
                
                listaCoordenadas = [CLLocationCoordinate2D]()
                listaCoordenadasTotal.append(listaCoordenadas)
                
                temporizadorEstaON = true
                
                iniciar.setTitle("Pausar", for: .normal)
            }
        }
    }
    
    // Pone en marcha el temporizador, utiliza la función temporizadorCorriendo
    func temporizadorON() {
        temporizador = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(temporizadorCorriendo), userInfo: nil, repeats: true)
    }
    
    // En base al temporizador y al contador:
    // 1- Va modificando el labelTemporizador para que salga el cronómetro
    // 2- Va guardando un registro de las coordenadas cada X tiempo (X varia en base a el tipo de actividad)
    @objc func temporizadorCorriendo() {
        if temporizadorEstaON {
            contador += 0.1
            
            // Sacamos horas, minutos y segundos
            let contadorTiempo = Int(floor(contador))
            let horas = contadorTiempo / 3600
            let minutos = (contadorTiempo % 3600) / 60
            let segundos = (contadorTiempo % 60) % 60
            
            // Lo sacamos en texto para mostrar en labelTemporizador
            var horasString = "\(horas):"
            var minutosString = "\(minutos)"
            var segundosString = "\(segundos)"
            
            // Añadimos un 0 a la izquierda si solo es una cifra
            if segundos < 10 {
                segundosString = "0\(segundos)"
            }
            
            if minutos < 10 {
                minutosString = "0\(minutos)"
            }
            
            if horas < 10 {
                horasString = "0\(horas):"
            }
            
            let decimasSegundo = String(format: "%.1f", contador).components(separatedBy: ".").last!
            
            // No quiero que salgan las horas hasta que llegue a una hora
            if horas == 0 {
                horasString = ""
            }
            
            // Configuramos el texto del label
            labelTemporizador.text = "\(horasString)\(minutosString):\(segundosString).\(decimasSegundo)"
            
            var kilometros = 0
            kilometros = Int(distancia_total) / 1000
            let metros = Int(distancia_total) % 1000
            
            if kilometros > 0 {
                distanciaLabel.text = "\(kilometros)km \(metros)m"
            } else {
                distanciaLabel.text = "\(metros)m"
            }
            
            //distanciaLabel.text = String(format: "%.0f")
            
        }
    }
    
    // Se ejecuta al cargar la ventana
    override func viewDidLoad() {
        super.viewDidLoad()
        comprobarServicioLocalizacion()
    }
    
    // Comprueba el servicio de localización
    func comprobarServicioLocalizacion() {
        if CLLocationManager.locationServicesEnabled() {
            configurarServicioLocalizacion() //Configurar (set up) nuestro location manager
            comprobarAutorizacionLocalizacion() //Comprobar la autorización para el servicio de localización
        } else {
            //Mostrar alerta para que el usuario active la ubicación // ¿Cuándo se llegaría aquí?
            print("No intenta configurar el servicio de localización")
        }
    }
    
    // Configura el servicio de localización
    func configurarServicioLocalizacion() {
        servicioLocalizacion.delegate = self
        servicioLocalizacion.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        servicioLocalizacion.distanceFilter = 5
        
    }
    
    
    // Comprueba la autorización del servicio de localización
    func comprobarAutorizacionLocalizacion() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse: // Funciona solo cuando la aplicación está abierta.
            
            print("Autorización cuando se usa")
            ubicacionPermitida()
            
            break
        case .authorizedAlways: // Funciona siempre, incluso cuando está en en segundo plano
            
            print("Autorización siempre")
            ubicacionPermitida()
            
            break
        case .denied: // Mostrar alerta para que configuren su propio sistema de localización
            
            print("Autorización denegada")
            alertaAutorizacionDenegada()
            break
            
        case .notDetermined: // Mostrar alerta para que configuren su propio sistema de localización
            
            print("Autorización no determinada")
            servicioLocalizacion.requestWhenInUseAuthorization()
            //comprobarAutorizacionLocalizacion() //<- no hace falta porque he implementado la función locationManager dentro de la extensión, esta función se encarga de esto mismo, arrancar la aplicación conforme a los cambios que haya hecho con la autorización
            break
        case.restricted: // Mostrar alerta para que configuren su propio sistema de localización
            
            print("Autorización restringida")
            alertaAutorizacionRestringida()
            
            break
        default:
            print("Error desconocido con la autorización de ubicación...")
            break
        }
    }
    
    // Se utiliza esta función en los casos que disponemos de autorización para la ubicación
    func ubicacionPermitida() {
        mapView.showsUserLocation = true
        centrarVistaEnLocalizacionUsuario()
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 0)! //<- ???
    }
    
    // Centra la vista en la localización del usuario
    func centrarVistaEnLocalizacionUsuario() {
        servicioLocalizacion.startUpdatingLocation() //<- empieza a obtener las coordenadas
        servicioLocalizacion.startUpdatingHeading()
        if let localizacion = servicioLocalizacion.location?.coordinate {
            let region = MKCoordinateRegion.init(center: localizacion, latitudinalMeters: regionEnMetros, longitudinalMeters: regionEnMetros)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // Crear la Polyline y la añade (¿¿¿¿ no funciona ????)
    func crearPolyline() {
        
        print("Empezando a crear Polyline")
        
        if listaCoordenadas.count >= 2 {
            let puntoA = listaCoordenadas[listaCoordenadas.count - 2]
            let puntoB = listaCoordenadas[listaCoordenadas.count - 1]
            
            print()
            print("Últimas dos coordenadas para la polyline")
            print("\(puntoA.latitude), \(puntoA.longitude)")
            print("\(puntoB.latitude), \(puntoB.longitude)")
            print()
            
            let polyline = MKPolyline(coordinates: listaCoordenadas, count: listaCoordenadas.count)
            
            mapView.addOverlay(polyline)
            
            
        } else {
            print("No hay suficientes coordenadas para empezar la polyline")
        }
        
        
        /*
        print("Empezando a crear Polyline")
        //Aquí tenemos que definir la lista de coordenadas de las localizaciones
        let latitud = (servicioLocalizacion.location?.coordinate.latitude)!
        print(latitud)
        let longitud = (servicioLocalizacion.location?.coordinate.longitude)!
        print(longitud)
        let localizaciones = [
            CLLocationCoordinate2D(latitude: 10.0, longitude: -96.7970),
            CLLocationCoordinate2D(latitude: 37.7833, longitude: -122.4167),
            CLLocationCoordinate2D(latitude: 42.2814, longitude: -83.7483),
            CLLocationCoordinate2D(latitude: 32.7767, longitude: -96.7970)
        ]
        
        //Creamos la Polyline con los puntos que le hemos pasado
        let unPolyLine = MKPolyline(coordinates: localizaciones, count: localizaciones.count)
        
        //Añadimos la Polyline al mapa
        mapa.addOverlay(unPolyLine)
        */
    }
    
    // Otro intento de Polyline, que sigue sin funcionar // Corrijo, soy imbécil, sí que funcionaban todos pero me faltaba mapView.delegate = self :)
    func otroIntentoDePolyline() {
        
        print("Empezando a crear Polyline (fórmula 2)")
        
        let latitud = (servicioLocalizacion.location?.coordinate.latitude)!
        let longitud = (servicioLocalizacion.location?.coordinate.longitude)!
        print(latitud)
        print(longitud)
        
        let localizacionInicial = CLLocation(latitude: latitud, longitude: longitud)
        let localizacionFinal = CLLocation(latitude: (latitud - 10), longitude: (longitud - 10))
        print(localizacionInicial)
        print(localizacionFinal)
        
        let localizaciones = [localizacionInicial, localizacionFinal]
        print(localizaciones)
        
        var coordenadas = localizaciones.map({(localizacion: CLLocation!) -> CLLocationCoordinate2D in return localizacion.coordinate})
        print(coordenadas)
        
        let polylinea = MKPolyline(coordinates: &coordenadas, count: localizaciones.count)
        print(polylinea)
        mapView.addOverlay(polylinea, level: .aboveRoads)
    }
    
    
    // Otro más, peor resultado, destroza el mapa
    func otroIntentoMasDePolyline() { //<- este intento me toca algo del mapa
    
        print("Empezando a crear Polyline (fórmula 3)")
        
        /*
        let point1 = CLLocationCoordinate2DMake(-73.761105, 41.017791);
        let point2 = CLLocationCoordinate2DMake(-73.760701, 41.019348);
        let point3 = CLLocationCoordinate2DMake(-73.757201, 41.019267);
        let point4 = CLLocationCoordinate2DMake(-73.757482, 41.016375);
        let point5 = CLLocationCoordinate2DMake(-73.761105, 41.017791);
        */
        
        let points: [CLLocationCoordinate2D]
        points = listaCoordenadas

        let geodesic = MKGeodesicPolyline(coordinates: points, count: 5)
        mapView.addOverlay(geodesic)

        UIView.animate(withDuration: 1.5, animations: { () -> Void in
            //let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            if let localizacion = self.servicioLocalizacion.location?.coordinate {
                let region = MKCoordinateRegion.init(center: localizacion, latitudinalMeters: self.regionEnMetros, longitudinalMeters: self.regionEnMetros)
                self.mapView.setRegion(region, animated: true)
            }
        })
    }
    
    func polylineSalYaPorfavor() { // Corrijo, soy imbécil, sí que funcionaban todos pero me faltaba mapView.delegate = self :)
        
        print("Empezando a crear Polyline (fórmula 4)")

        if listaCoordenadas.count > 1 {
            
            let sourceLocation: CLLocationCoordinate2D = listaCoordenadas[listaCoordenadas.count - 2]
            let destinationLocation: CLLocationCoordinate2D = listaCoordenadas[listaCoordenadas.count - 1]
            
            let sourcePlacemark = MKPlacemark(coordinate: sourceLocation)
            let destinationPlacemark = MKPlacemark(coordinate: destinationLocation)
            
            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: sourcePlacemark)
            directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
            directionRequest.transportType = .walking

            let directions = MKDirections(request: directionRequest)
            directions.calculate {
                (response, error) in guard let directionResonse = response else {
                    if let error = error {
                        print("Error obteniendo las direcciones: \(error)")
                    }
                    return
                }
                let route = directionResonse.routes[0]
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                
                //let rect = route.polyline.boundingMapRect
                //self.mapView.setRegion(MKCoordinateRegion, animated: true)
            }
            self.mapView.delegate = self
            
        } else {
            print("No hay suficientes coordenadas para empezar la polyline")
        }
    }
    
    func volverANuevoRecorrido() {
        super.navigationController?.popViewController(animated: true)
    }

    func alertaAutorizacionDenegada() {
        
        let alertController = UIAlertController(title: "Aplicación sin permisos", message: "Los permisos de ubicación para esta aplicación están denegados. Debes otorgar permisos de ubicación a la aplicación. Puedes cambiar esta configuración desde las opciones de tu teléfono.", preferredStyle: .alert)
        let actionGuardar = UIAlertAction(title: "Okay", style: .cancel) { (_) in
            //let firstTextField = alertController.textFields![0] as UITextField
            self.volverANuevoRecorrido()
        }
        alertController.addAction(actionGuardar)
        present(alertController, animated: true, completion: nil)
    }
    
    func alertaAutorizacionRestringida() {
        
        let alertController = UIAlertController(title: "Aplicación sin permisos", message: "Los permisos de ubicación para esta aplicación están restringidos y esto impide un correcto funcionamiento. Debes otorgar permisos de ubicación a la aplicación. Puedes cambiar esta configuración desde las opciones de tu teléfono.", preferredStyle: .alert)
        let actionGuardar = UIAlertAction(title: "Okay", style: .cancel) { (_) in
            //let firstTextField = alertController.textFields![0] as UITextField
            self.volverANuevoRecorrido()
        }
        alertController.addAction(actionGuardar)
        present(alertController, animated: true, completion: nil)
    }
    
    
    // Override de la función que se ejecuta cuando llamamos a mapView.addOverlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //Propiedades de la Polyline
        print("Hemos entrado a renderizar la polyline")
        if overlay.isKind(of: MKPolyline.self) {
            print("Renderizando polyline")
            
            let renderizadoPolyline = MKPolylineRenderer(overlay: overlay)
            renderizadoPolyline.fillColor = UIColor.orange.withAlphaComponent(0.8)
            renderizadoPolyline.strokeColor = UIColor.orange.withAlphaComponent(0.8)
            renderizadoPolyline.lineWidth = 5
            
            print("Renderización exitosa")
            return renderizadoPolyline
        }
        
        print("Error con la renderización polyline")
        return MKPolylineRenderer()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "registroTrasRecorrido") {
            let destino = segue.destination as! RegistroViewController
            destino.registro = registro
            destino.usuario = usuario
        }
        
        
    }
    
}

/*
extension MKPolyline { //<- quiere tratar un posible error con las coordenadas al leerlas cuando las pasas al polyline, pero no surte efecto
    convenience init(coordinates coords: Array<CLLocationCoordinate2D>) {
        let unsafeCoordinates = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: coords.count)
        unsafeCoordinates.initialize(from: coords, count: coords.count)
        self.init(coordinates: unsafeCoordinates, count: coords.count)
        unsafeCoordinates.deallocate()
    }
}
 */

extension MapaViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations localizaciones: [CLLocation]) {
        guard let localizacion = localizaciones.last else { return }
        let centro = CLLocationCoordinate2D(latitude: localizacion.coordinate.latitude, longitude: localizacion.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: centro, latitudinalMeters: regionEnMetros, longitudinalMeters: regionEnMetros)
        mapView.setRegion(region, animated: true)
        if temporizadorEstaON {
            listaCoordenadas.append(localizacion.coordinate)
            if (listaCoordenadas.count > 1) {
                let loc1 = CLLocation(latitude: listaCoordenadas[listaCoordenadas.count - 2].latitude, longitude: listaCoordenadas[listaCoordenadas.count - 2].longitude)
                let loc2 = CLLocation(latitude: listaCoordenadas[listaCoordenadas.count - 1].latitude, longitude: listaCoordenadas[listaCoordenadas.count - 1].longitude)
                distancia_total += loc1.distance(from: loc2)
            }
            crearPolyline()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        comprobarAutorizacionLocalizacion()
    }
    
}
