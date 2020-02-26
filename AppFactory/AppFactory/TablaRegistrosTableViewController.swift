//
//  TablaRegistrosTableViewController.swift
//  AppFactory
//
//  Created by  on 31/01/2020.
//  Copyright © 2020 Daniel Tamargo Saiz. All rights reserved.
//

import UIKit
import RealmSwift

class TablaRegistrosTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var registros : Results<Registro>?
    var registro = Registro()
    
    //Cargamos todos los registros. La idea es que es una app para uso personal/familiar, así que se visualizarán todos los registros (mostraremos la imagen de cada usuario)
    //En próximos avances intentaré implementar una forma de filtrar
    //"Solo mis registros / Todos los registros" " <5km / >5km"
    func cargarRegistros() {
        
        print("Depuración de registros cuyo usuario haya sido eliminado...")
        let registrosADepurar = realm.objects(Registro.self)
        for registroDepurando in registrosADepurar {
            if registro.usuario == nil {
                try! realm.write {
                    realm.delete(registroDepurando)
                    print("Registro borrado")
                }
            }
        }
        //registros = realm.objects(Registro.self).filter(byKeyPath:descending:)
        registros = realm.objects(Registro.self).sorted(byKeyPath: "id", ascending: false)
        
    }
    
    
    func moverANuevoRecorrido() {
        self.tabBarController?.selectedIndex = 0
    }
    // Cargar aquí en una lista la lista de registros del usuario loggeado
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cargarRegistros()
        guard let regis = registros else { return }
        if regis.count <= 0 {
            let alertController = UIAlertController(title: "Aún no tienes registros", message: "¿No tienes registros aún? ¡Inicia un nuevo recorrido!", preferredStyle: .alert)
            let actionGuardar = UIAlertAction(title: "¡Vamos allá!", style: .cancel) { (_) in
                self.moverANuevoRecorrido()
            }
            alertController.addAction(actionGuardar)
            present(alertController, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1 //1 sección por ahora
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let registros = realm.objects(Registro.self)
        return registros.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CeldaRegistro", for: indexPath) as! CeldaRegistroTableViewCell
        
        // Configuramos cada celda
        cell.layer.borderWidth = 1.2
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.orange.withAlphaComponent(0.2)
            cell.layer.borderColor = UIColor.black.cgColor
        } else {
            cell.backgroundColor = UIColor.purple.withAlphaComponent(0.05)
            cell.layer.borderColor = UIColor.orange.cgColor
        }
        
        guard let registro = registros?[indexPath.row] else {
            return cell
        }
        
        //Titulo
        cell.titulo.text = "Registro nº\(registro.id)"
        
        //Actividad
        cell.actividad.text = "Actividad: \(registro.actividad)"
        
        //Distancia
        let distancia_total = registro.distancia
        var kilometros = 0
        kilometros = Int(distancia_total) / 1000
        let metros = Int(distancia_total) % 1000
        if kilometros > 0 {
            cell.distancia.text = "Distancia: \(kilometros)km \(metros)m"
        } else {
            cell.distancia.text = "Distancia: \(metros)m"
        }
        
        //Tiempo
         if registro.tiempo.count > 2 {
             cell.tiempo.text = "Tiempo: \(registro.tiempo[0])h \(registro.tiempo[1])m \(registro.tiempo[2])s"
         } else {
             cell.tiempo.text = "Tiempo: error"
         }
        
        
        //Fecha
        let df = DateFormatter()
        //df.dateStyle = .full
        //df.timeStyle = .full
        df.locale = Locale(identifier: "es_ES")
        df.dateFormat = "dd MMM yyyy"
        let fecha = df.string(from: registro.fecha)
        cell.fecha.text = fecha
        
        //Imagen usuario
        if (registro.usuario!.num_icono > 0 && registro.usuario!.num_icono < 16) {
            let imagenUsu = UIImage(named: "avatar-\(registro.usuario!.num_icono)")
            cell.imagen_usuario.image = imagenUsu
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let registro = registros?[indexPath.row] else { return }
        self.registro = registro
        self.performSegue(withIdentifier: "registroDesdeTabla", sender: indexPath.row)
        
        /*
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let pantallaRegistro = storyBoard.instantiateViewController(withIdentifier: "VistaRegistro") as! RegistroViewController
        pantallaRegistro.registro = registro
        navigationController?.pushViewController(pantallaRegistro, animated: true)
        */
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "registroDesdeTabla") {
            let destino = segue.destination as! RegistroViewController
            destino.registro = registro
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
