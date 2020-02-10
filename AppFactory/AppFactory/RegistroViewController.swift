//
//  RegistroViewController.swift
//  AppFactory
//
//  Created by  on 06/02/2020.
//  Copyright © 2020 Daniel Tamargo Saiz. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift
import CoreLocation
import Darwin

class RegistroViewController: UIViewController {

    var usuario: Usuario?
    var registro: Registro?
    
    @IBOutlet weak var selector_amplitud: UISegmentedControl!
    
    
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var fecha: UILabel!
    
    @IBOutlet weak var actividad: UILabel!
    @IBOutlet weak var distancia: UILabel!
    @IBOutlet weak var tiempo: UILabel!
    @IBOutlet weak var calorias: UILabel!
    @IBOutlet weak var pausas: UILabel!
    
    @IBOutlet weak var imagen_usuario: UIImageView!
    
    var listaCoordenadas = [CLLocationCoordinate2D]() //<- guardar las coordenadas con X frecuencia
    var listaCoordenadasTotal = [[CLLocationCoordinate2D]]() //<- lista de las listas de coordenadas
    
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var imagen_rating: UIImageView!
    
    @IBOutlet weak var mapa: MKMapView!
    
    var amplitud_mapa: CGFloat = 10.0
    
    @IBAction func volverListaRegistros(_ sender: Any) {
        
    }
    
    
    @IBAction func borrarRegistro(_ sender: Any) {
        //Borrar registro y volver a la lista de registros (W.I.P.)
        
        
    }
    
    @IBAction func cambiarAmplitudMapa(_ sender: Any) {
        if (selector_amplitud.selectedSegmentIndex == 0) {
            amplitud_mapa = 10.0
        } else {
            amplitud_mapa = 100.0
        }
        centrarVistaEnPolyLineInvisible()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapa.delegate = self
        
        let realm = try! Realm()
        usuario = realm.objects(Usuario.self).first!
        print(usuario!.nickname)

        nickname.text = usuario?.nickname
        nickname.textColor = UIColor.purple.withAlphaComponent(1)
        
        //Sombras de la imagen https://fluffy.es/rounded-corner-shadow/
        imagen_rating.layer.shadowColor = UIColor.darkGray.cgColor
        imagen_rating.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        imagen_rating.layer.shadowRadius = 2.0
        imagen_rating.layer.shadowOpacity = 0.9
        
        //Faltan
        //- Fórmula para calcular las calorías
        //- Cálculo para saber qué rating mostrar
        
        //let imagenRating = UIImage(named: "rating-\(num_icono_rating)")
        //imagen_rating = imagenRating
        
        //Imagen usuario
        if (usuario!.num_icono > 0 && usuario!.num_icono < 16) {
        let imagenUsu = UIImage(named: "avatar-\(usuario!.num_icono)")
            imagen_usuario.image = imagenUsu
        }
        
        //Distancia
        let distancia_total = registro!.distancia
        
        var kilometros = 0
        kilometros = Int(distancia_total) / 1000
        let metros = Int(distancia_total) % 1000
        
        if kilometros > 0 {
            distancia.text = "Distancia: \(kilometros)km \(metros)m"
        } else {
            distancia.text = "Distancia: \(metros)m"
        }
        
        //Calorias WIP
        calorias.text = "Calorías: "
        
        //Tiempo
        if registro!.tiempo.count > 2 {
            tiempo.text = "Tiempo: \(registro!.tiempo[0])h \(registro!.tiempo[1])m \(registro!.tiempo[2])s"
        } else {
            tiempo.text = "Tiempo: error"
        }
        
        //Fecha
        let df = DateFormatter()
        df.dateFormat = "dd MMMM yyyy"
        let fechaStr = df.string(from: registro!.fecha!)
        fecha.text = fechaStr
        
        //Pausas
        pausas.text = "Pausas: \(registro!.pausas)"
        
        //Actividad
        if (registro!.actividad == "") {
            actividad.text = "Actividad: Fase Testing"
        } else {
            actividad.text = "Actividad: \(registro!.actividad)"
        }
        
        //Coordenadas
        let latitudes_registro = registro!.listaLatitudes
        let longitudes_registro = registro!.listaLongitudes
        
        for i in 0 ..< latitudes_registro.count {
            print(latitudes_registro[i])
            print(longitudes_registro[i])
            if (latitudes_registro[i] == "pausa") {
                listaCoordenadasTotal.append(listaCoordenadas)
                listaCoordenadas = []
            } else {
                let latitud: Double! = Double(latitudes_registro[i])
                let longitud: Double! = Double(longitudes_registro[i])
                let coordenada = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
                listaCoordenadas.append(coordenada)
            }
        }
        
        crearVariasPolyline()
        centrarVistaEnPolyLineInvisible()
        
    }
    
    func calcularRating() {

        let today = Date()
        let calendar = Calendar.current
        let componentes = calendar.dateComponents([.year, .month, .day], from: registro!.usuario!.fecha_nac!, to: today)
        let dias = componentes.day! //print(type(of: dia)) //Int
        let meses = componentes.month!
        let anyos = componentes.year!
        print("Edad: \(anyos) años, \(meses) meses, \(dias) días") //24 años, 4 meses, 14 días
        
        //Un sistema de rating muy casero basado en la edad, distancia recorrida y tiempo
        var puntuacion = 0
        
        if (registro!.distancia > 1000) {
            if (anyos < 27) {
                puntuacion += 1
            }
            
        }
        
    }

    //En caso de haber hecho pausas en el recorrido, la polyline no será una única línea, sino que habrá que crear una por cada recorrido entre pausas
    func crearVariasPolyline() {
        for lista in listaCoordenadasTotal {
            listaCoordenadas = lista
            crearPolyline()
        }
    }
    
    func centrarVistaEnPolyLineInvisible() {
        var todasLasCoordenadas = [CLLocationCoordinate2D]()
        for lista in listaCoordenadasTotal {
            for coordenada in lista {
                todasLasCoordenadas.append(coordenada)
            }
        }
        let polyline = MKPolyline(coordinates: todasLasCoordenadas, count: todasLasCoordenadas.count)
        setVisibleMapArea(polyline: polyline, edgeInsets: UIEdgeInsets(top: amplitud_mapa, left: amplitud_mapa, bottom: amplitud_mapa, right: amplitud_mapa))
    }
    
    func setVisibleMapArea(polyline: MKPolyline, edgeInsets: UIEdgeInsets, animated: Bool = true) {
        mapa.setVisibleMapRect(polyline.boundingMapRect, edgePadding: edgeInsets, animated: animated)
    }
    
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
            
            mapa.addOverlay(polyline)
            
        } else {
            print("No hay suficientes coordenadas para crear la polyline")
        }
    }

}

extension RegistroViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //Propiedades de la Polyline
        print("Hemos entrado a renderizar la polyline")
        if overlay.isKind(of: MKPolyline.self) {
            print("Renderizando polyline")
            
            let renderizadoPolyline = MKPolylineRenderer(overlay: overlay)
            renderizadoPolyline.fillColor = UIColor.orange.withAlphaComponent(1)
            renderizadoPolyline.strokeColor = UIColor.orange.withAlphaComponent(1)
            renderizadoPolyline.lineWidth = 5
            
            print("Renderización exitosa")
            return renderizadoPolyline
        }
        
        print("Error con la renderización polyline")
        return MKPolylineRenderer()
    }
    
}
