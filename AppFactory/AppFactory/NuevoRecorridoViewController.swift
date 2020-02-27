//
//  NuevoRecorridoViewController.swift
//  AppFactory
//
//  Created by  on 10/02/2020.
//  Copyright © 2020 Daniel Tamargo Saiz. All rights reserved.
//

import UIKit
import RealmSwift

class NuevoRecorridoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //TODO: Sustituir cargar usuario predeterminado por usuario loggeado cuando las cardparts no me destrocen las ganas de vivir
        let realm = try! Realm()
        
        let usuarios = realm.objects(Usuario.self)
        if usuarios.count > 0 {
            let usuario = realm.objects(Usuario.self).last!
            print(usuario.nickname)
            
            if (segue.identifier == "nuevoRecorridoCaminar") {
                let destino = segue.destination as! MapaViewController
                destino.usuario = usuario
                destino.tipoActividad = "Caminar"
            } else if (segue.identifier == "nuevoRecorridoCorrer") {
                let destino = segue.destination as! MapaViewController
                destino.usuario = usuario
                destino.tipoActividad = "Correr"
            } else if (segue.identifier == "nuevoRecorridoBici") {
                let destino = segue.destination as! MapaViewController
                destino.usuario = usuario
                destino.tipoActividad = "Bici"
            }
        } else {
            print("Segue desconocido (?)")
        }

    }

}
