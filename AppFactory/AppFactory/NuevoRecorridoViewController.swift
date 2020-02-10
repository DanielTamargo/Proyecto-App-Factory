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

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //TODO: Sustituir cargar usuario predeterminado por usuario loggeado
        let realm = try! Realm()
        let usuario = realm.objects(Usuario.self).first!
        print(usuario.nickname)
        
        let destino = segue.destination as! MapaViewController
        destino.usuario = usuario
        
        if (segue.identifier == "nuevoRecorridoCaminar") {
            destino.tipoActividad = "Caminar"
        } else if (segue.identifier == "nuevoRecorridoCorrer") {
            destino.tipoActividad = "Correr"
        } else if (segue.identifier == "nuevoRecorridoBici") {
            destino.tipoActividad = "Bici"
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
