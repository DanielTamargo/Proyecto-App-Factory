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
    
    var borrado = false //si se borra el registro se pone como true
    var nuevoRegistro = false
    var record = false
    var listaCoordenadas = [CLLocationCoordinate2D]() //<- guardar las coordenadas con X frecuencia
    var listaCoordenadasTotal = [[CLLocationCoordinate2D]]() //<- lista de las listas de coordenadas
    
    var temporizador = Timer()
    var temporizadorEstaON = false


    var red = 255
    var green = 169
    var greenInverso = false
    var blue = 118
    var alpha = 1.0
    
    var inicio = 0
    var numListas = 0
    var listaCoordenadasV = [CLLocationCoordinate2D]() //<- usada para la polyline progresiva
    var lista = [CLLocationCoordinate2D]()
    
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var imagen_rating: UIImageView!
    
    @IBOutlet weak var mapa: MKMapView!
    
    var amplitud_mapa: CGFloat = 25.0 //no entiendo por que en ipohone 8 necesito poner 85 para que sea similar
    
    
    @IBAction func cambiarAmplitudMapa(_ sender: Any) {
        if (selector_amplitud.selectedSegmentIndex == 0) {
            amplitud_mapa = 25.0
        } else {
            amplitud_mapa = 300.0
        }
        centrarVistaEnPolyLineInvisible()
    }
    
    func crearPolylineProgresivamente() {
        if listaCoordenadasTotal.count > 0 {
            listaCoordenadasV = listaCoordenadasTotal[0]
            temporizadorON()
        }
    }
    
    func temporizadorON() {
        temporizador = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(temporizadorCorriendo), userInfo: nil, repeats: true)
    }
    
    @objc func temporizadorCorriendo() {
        let punto = listaCoordenadasV[inicio]
        gradientePolyline()
        lista.append(punto)
        //borrar esto para la lenta v1
        crearPolylineProgresiva()
        inicio += 1
        if inicio >= listaCoordenadasV.count {
            numListas += 1
            inicio = 0
            if numListas < listaCoordenadasTotal.count {
                listaCoordenadasV = listaCoordenadasTotal[numListas]
                lista = [CLLocationCoordinate2D]()
            } else {
                crearVariasPolyline()
                listaCoordenadasV = listaCoordenadasTotal[0]
                lista = [CLLocationCoordinate2D]()
                numListas = 0
            }
        }
    }
    
    func gradientePolyline() { //Utilizar colores que van cambiando progresivamente???
        
        if !greenInverso {
            green += 1
            if green > 218 {
                greenInverso = true
            }
        } else {
            green -= 1
            if green < 169 {
                greenInverso = false
            }
        }
        
    }
    
    func pararPolylineProgresiva() {
        temporizador.invalidate()
        crearVariasPolyline()
    }
    
    func crearPolylineProgresiva() {
        if lista.count >= 2 {
            let polyline = MKPolyline(coordinates: lista, count: lista.count)
            polyline.title = "test"
            mapa.addOverlay(polyline)
        }
      }
    

    func volverALaListaDeRegistros() {
        pararPolylineProgresiva()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let pantalla_lista_registros = storyBoard.instantiateViewController(withIdentifier: "TabBarNuevoRecorridoRegistro") as! TabBarViewController
        pantalla_lista_registros.selectedIndex = 1
        navigationController?.pushViewController(pantalla_lista_registros, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func volverListaRegistros(_ sender: Any) {
        volverALaListaDeRegistros()
    }
    
    @IBAction func borrarRegistro(_ sender: Any) {
        if !borrado {
            //Borrar registro y volver a la lista de registros (W.I.P.)
            do {
                let realm = try! Realm()
                
                try realm.write {
                    realm.delete(registro!)
                    borrado = true
                }
                pararPolylineProgresiva()
                let alertController = UIAlertController(title: "Registro eliminado", message: "Volverás a la lista de registros.", preferredStyle: .alert)
                let actionGuardar = UIAlertAction(title: "Okay", style: .cancel) { (_) in
                    //let firstTextField = alertController.textFields![0] as UITextField
                    self.volverALaListaDeRegistros()
                }
                alertController.addAction(actionGuardar)
                present(alertController, animated: true, completion: nil)
                
            } catch {
                print("Error con el Realm")
                //mostrar alerta de que no se ha podido eliminar por un error con la BBDD
            }
        } else {
            let alertController = UIAlertController(title: "Registro ya eliminado", message: "El registro ya fue eliminado. Descuida.", preferredStyle: .alert)
            let actionGuardar = UIAlertAction(title: "Okay", style: .cancel) { (_) in
                //let firstTextField = alertController.textFields![0] as UITextField
                self.volverALaListaDeRegistros()
            }
            alertController.addAction(actionGuardar)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        mapa.delegate = self
        
        let realm = try! Realm()
        let registros = realm.objects(Registro.self)
        let record_distancia: Double? = registros.max(ofProperty: "distancia") as Double?
        
        if registro!.distancia >= record_distancia! {
            record = true
        }
        
        usuario = registro!.usuario
        print(usuario!.nickname)

        nickname.text = usuario?.nickname
        nickname.textColor = UIColor.purple.withAlphaComponent(1)
        
        //Sombras de la imagen https://fluffy.es/rounded-corner-shadow/
        imagen_rating.layer.shadowColor = UIColor.darkGray.cgColor
        imagen_rating.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        imagen_rating.layer.shadowRadius = 2.0
        imagen_rating.layer.shadowOpacity = 0.9
        
        
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
        
        if record {
            if nuevoRegistro {
                distancia.text! += " ¡Nuevo Record!"
            } else {
                distancia.text! += " ¡Record!"
            }
        }
        
        //Calorias
        if registro?.calorias != nil && registro!.calorias > 0.5 {
            calorias.text = "Calorías: \(registro!.calorias)"
        } else {
            calorias.text = "Calorías: 0"
        }
        
        //Tiempo
        if registro!.tiempo.count > 2 {
            tiempo.text = "Tiempo: \(registro!.tiempo[0])h \(registro!.tiempo[1])m \(registro!.tiempo[2])s"
        } else {
            tiempo.text = "Tiempo: error"
        }
        
        //Fecha
        let df = DateFormatter()
        df.locale = Locale(identifier: "es_ES")
        df.dateFormat = "dd MMMM yyyy"
        let fechaStr = df.string(from: registro!.fecha)
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
        
        calcularRating()
        crearVariasPolyline()
        
        centrarVistaEnPolyLineInvisible()
        
        crearPolylineProgresivamente()
        
    }
    
    func calcularRating() {
        guard let fecha_nac = registro!.usuario!.fecha_nac else {
            print("Error con la fecha nacimiento")
            return
        }
        let today = Date()
        let calendar = Calendar.current
        let componentes = calendar.dateComponents([.year, .month, .day], from: fecha_nac, to: today)
        let dias = componentes.day! //print(type(of: dia)) //Int
        let meses = componentes.month!
        let anyos = componentes.year!
        print("Edad: \(anyos) años, \(meses) meses, \(dias) días") //24 años, 4 meses, 14 días
        
        //IMC: https://www.texasheart.org/heart-health/heart-information-center/topics/calculadora-del-indice-de-masa-corporal-imc/
        let IMC = registro!.usuario!.peso / (registro!.usuario!.altura * 2 / 10)

        //Un sistema de rating muy casero basado en la edad, distancia recorrida y tiempo aguantado
        var puntuacion = 0
        
        var meta_distancia = 1000.0
        //Meta distancia en base a edad y tipo actividad
        if anyos < 24 {
            if registro!.actividad == "Bici" {
                meta_distancia = 15000
            } else if registro!.actividad == "Correr" {
                meta_distancia = 10000
            } else {
                meta_distancia = 4000
            }
        } else if anyos < 33 {
            if registro!.actividad == "Bici" {
                meta_distancia = 12000
            } else if registro!.actividad == "Correr" {
                meta_distancia = 8000
            } else {
                meta_distancia = 3000
            }
        } else if anyos < 50 {
            if registro!.actividad == "Bici" {
                meta_distancia = 12000
            } else if registro!.actividad == "Correr" {
                meta_distancia = 6000
            } else {
                meta_distancia = 2500
            }
        } else if anyos < 60 {
            if registro!.actividad == "Bici" {
                meta_distancia = 5000
            } else if registro!.actividad == "Correr" {
                meta_distancia = 3000
            } else {
                meta_distancia = 2000
            }
        } else {
            if registro!.actividad == "Bici" {
                meta_distancia = 4000
            } else if registro!.actividad == "Correr" {
                meta_distancia = 2000
            } else {
                meta_distancia = 2000
            }
        }
        
        if IMC < 18 {
            meta_distancia -= 500 //peso inferior al normal, menos esfuerzo
        } else if IMC < 25 {
            meta_distancia += 1000 //peso ideal, más esfuerzo
        } else if IMC < 30 {
            meta_distancia -= 500 //peso mayor al normal, menos esfuerzo
        } else {
            meta_distancia -= 1000 //obesidad, aún menos esfuerzo
        }
        
        if (registro!.distancia > meta_distancia) {
            puntuacion += 10
        } else if registro!.distancia > (meta_distancia / 2) {
            puntuacion += 7
        } else if registro!.distancia > (meta_distancia / 3) {
            puntuacion += 5
        }
        
        var segundos = 0
        if registro!.tiempo[0] > 0 {
            segundos += registro!.tiempo[0] * 3600
        }
        if registro!.tiempo[1] > 0 {
            segundos += registro!.tiempo[1] * 60
        }
        if registro!.tiempo[2] > 0 {
            segundos += registro!.tiempo[2]
        }
        
        var meta_tiempo = 3600
        //Meta aguante (tiempo) en base a actividad
        if registro!.actividad == "Bici" {
            meta_tiempo = 3600
        } else if registro!.actividad == "Correr" {
            meta_tiempo = 2000
        } else {
            meta_tiempo = 4400
        }
        
        if IMC < 18 {
            meta_tiempo -= 60 //peso inferior al normal, menos esfuerzo
        } else if IMC < 25 {
            meta_tiempo += 120 //peso ideal, más esfuerzo
        } else if IMC < 30 {
            meta_tiempo -= 60 //peso mayor al normal, menos esfuerzo
        } else {
            meta_tiempo -= 120 //obesidad, aún menos esfuerzo
        }
        
        if segundos > meta_tiempo {
            puntuacion += 10
        } else if segundos > (meta_tiempo / 2) {
            puntuacion += 7
        } else if segundos > (meta_tiempo / 3) {
            puntuacion += 5
        }
        
        if record {
            puntuacion += 20
        }
        
        if registro!.pausas == 0 {
            puntuacion += 5
        } else if registro!.pausas == 1 {
            puntuacion += 3
        } else if registro!.pausas == 2 {
            puntuacion += 1
        }
        
        //Puntos extra por el esfuerzo si el peso excede lo considerado 'peso ideal' (sobrepeso)
        
        var string_imagen_puntuacion = "rating-10"
        if puntuacion < 5 {
            string_imagen_puntuacion = "rating-10" //¡tienes que esforzarte más! half-star
            rating.text = "¡Tienes que esforzarte más! ¡Ánimo!"
        } else if puntuacion < 10 {
            string_imagen_puntuacion = "rating-11" //aceptable tic
            rating.text = "¡Bien! ¡Sigue mejorando!"
        } else if puntuacion < 16 {
            string_imagen_puntuacion = "rating-1" //¡bien hecho! star
            rating.text = "¡Buen trabajo!"
        } else if puntuacion < 21 {
            string_imagen_puntuacion = "rating-5" //¡muy bien! 3 stars
            rating.text = "¡Muy bien! Intenta superar tu record."
        } else {
            string_imagen_puntuacion = "rating-7" //¡genial! ¡estrella especial!
            rating.text = "¡Impresionante! ¡Has recibido la estrella especial!"
        }
        let imagen_puntuacion = UIImage(named: string_imagen_puntuacion)
        imagen_rating.image = imagen_puntuacion
        
    }

    //En caso de haber hecho pausas en el recorrido, la polyline no será una única línea, sino que habrá que crear una por cada recorrido entre pausas
    func crearVariasPolyline() {
        for lista in listaCoordenadasTotal {
            listaCoordenadas = lista
            crearBordePolyline() //ejecutamos primero el fondo para que haga de borde y no se superponga
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
            polyline.title = "main" //al ser main, la dibujará naranja y más fina
            mapa.addOverlay(polyline)
            
        } else {
            print("No hay suficientes coordenadas para crear la polyline")
        }
    }
    
    func crearBordePolyline() {
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
            //polyline.title = "main" //<- al no ser main, la dibujará en negro y más gorda por lo que parecerá el borde
            //info: https://stackoverflow.com/questions/58810993/how-to-add-border-to-mkpolyline
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
            if overlay.title == "test" {
                renderizadoPolyline.strokeColor = UIColor.purple.withAlphaComponent(1)
                renderizadoPolyline.lineWidth = 5
            } else {
                renderizadoPolyline.strokeColor = overlay.title == "main" ? UIColor.orange.withAlphaComponent(1) : .black
                renderizadoPolyline.lineWidth = overlay.title == "main" ? 5 : 7
            }
            
            print("Renderización exitosa")
            return renderizadoPolyline
        }
        
        print("Error con la renderización polyline")
        return MKPolylineRenderer()
    }
    
}
