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

class RegistroViewController: UIViewController {

    var usuario: Usuario?
    var registro: Registro?
    
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var distancia: UILabel!
    @IBOutlet weak var tiempo: UILabel!
    @IBOutlet weak var calorias: UILabel!
    @IBOutlet weak var pausas: UILabel!
    
    @IBOutlet weak var imagen_usuario: UIImageView!
    @IBOutlet weak var imagen_rating: UIImageView!
    
    @IBOutlet weak var mapa: MKMapView!
    
    
    @IBAction func volverListaRegistros(_ sender: Any) {
        
    }
    
    
    @IBAction func borrarRegistro(_ sender: Any) {
        //Borrar registro y volver a la lista de registros
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        usuario = realm.objects(Usuario.self).first!
        print(usuario!.nickname)

        nickname.text = usuario?.nickname
        nickname.textColor = UIColor.purple.withAlphaComponent(1)
        
        //Faltan
        //- Fórmula para calcular las calorías
        //- Cálculo para saber qué rating mostrar
        
        //let imagenRating = UIImage(named: "rating-\(num_icono_rating)")
        //imagen_rating = imagenRating
        
        
        if (usuario!.num_icono > 0 && usuario!.num_icono < 16) {
        let imagenUsu = UIImage(named: "avatar-\(usuario!.num_icono)")
            imagen_usuario.image = imagenUsu
        }
        
        let distancia_total = registro!.distancia
        
        var kilometros = 0
        kilometros = Int(distancia_total) / 1000
        let metros = Int(distancia_total) % 1000
        
        if kilometros > 0 {
            distancia.text = "Distancia: \(kilometros)km \(metros)m"
        } else {
            distancia.text = "Distancia: \(metros)m"
        }
        
        calorias.text = "Calorías: "
        
        if registro!.tiempo.count > 2 {
            tiempo.text = "Tiempo: \(registro!.tiempo[0])h \(registro!.tiempo[1])m \(registro!.tiempo[2])s"
        }
        
    }
    

    

}
