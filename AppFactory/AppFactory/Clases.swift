//
//  Clases.swift
//  AppFactory
//
//  Created by  on 30/01/2020.
//  Copyright © 2020 Daniel Tamargo Saiz. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation


/*
 2 opciones:
    - Guardar una lista de registros en el usuario (entonces, si consigo guardarla, ¿necesito guardar los registros también?)
    - Guardar los usuarios con sus datos base, y los registros con sus datos base, y en cada registro guardar el id de usuario para vincularlo más tarde
 ¿¿¿Cuál uso???
 */



// Un usuario tendrá una lista de registros. ¿Guardamos el id de cada registro en la lista o directamente los registros?
class Usuario: Object {
    
    @objc dynamic var nickname: String = "Danielito :D"
    @objc dynamic var sexo: Int = -1 // -1 null, 0 desconocido, 1 mujer, 2 hombre
    @objc dynamic var altura: Int = -1 //Centímetros
    @objc dynamic var peso: Int = -1 //Kilogramos
    @objc dynamic var fecha_nac: Date?
    @objc dynamic var num_icono: Int = 0 // cada número señalará un avatar distinto (0 default)
    
    let listaRegistros = List<Registro>() //Probando a guardar los registros directamente

}

// Un registro guardará los datos de un recorrido. ¿Si ya he guardado los registros en la lista de registros del usuario, es necesario guardar el usuario?
class Registro: Object {
    
    //básicas
    @objc dynamic var id: Int = Int.random(in:10000 ... 100000000) //Por si falla al poner un id seguido, al menos que sea uno aleatorio
    @objc dynamic var distancia: Double = -1
    let tiempo = List<Int>() //Horas, Minutos, Segundos
    @objc dynamic var fecha: Date?
    @objc dynamic var actividad: String = ""
    @objc dynamic var usuario: Usuario? = Usuario()
    
    //guardo coordenadas para recrear el recorrido en el mapa si decido mostrar la imagen.
    //Ojo! no se guardan los puntos que haya saltado al pausar y reanudar
    let listaLatitudes = List<String>()
    let listaLongitudes = List<String>()
    
    //let listaPausasLatitudes = List<String>() //<- se podría usar para separar los recorridos por las pausas
    //let listaPausasLongitudes = List<String>() //<- se podría usar para separar los recorridos por las pausas
    //otra opción sería guardar la cadena "pausa" dentro de listaLatitudes y listaLongitudes, y al leerlas, si sale pausa, separarlo en listas
    
    //extras
    @objc dynamic var pausas: Int = 0
    
    
    
}
