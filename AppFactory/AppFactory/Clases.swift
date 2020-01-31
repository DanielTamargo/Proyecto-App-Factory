//
//  Clases.swift
//  AppFactory
//
//  Created by  on 30/01/2020.
//  Copyright © 2020 Daniel Tamargo Saiz. All rights reserved.
//

import Foundation
import RealmSwift

// Un usuario tendrá una lista de registros. Guardamos el id de cada registro en la lista.
class Usuario: Object {
    
    @objc dynamic var nombre: String = "Age of Empires"
    @objc dynamic var sexo: Int = -1
    @objc dynamic var altura: Double = -1
    @objc dynamic var edad: Int = -1
    @objc dynamic var icono: Int = 0 //<- Cada icono está enlazado a un número, 0 es el default
    dynamic var listaRegistros = [String]()

}

// Un registro guardará los datos de un recorrido
class Registro: Object {
    
    //básicas
    @objc dynamic var id: String = ""
    @objc dynamic var distancia: Int = -1
    @objc dynamic var tiempo: String = ""
    @objc dynamic var fecha: Date?
    @objc dynamic var actividad: String = ""
    
    //extras
    @objc dynamic var pausas: Int = 0
    
    
    
}
