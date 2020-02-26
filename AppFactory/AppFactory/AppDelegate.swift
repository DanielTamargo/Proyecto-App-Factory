//
//  AppDelegate.swift
//  AppFactory
//
//  Created by  on 17/01/2020.
//  Copyright © 2020 Daniel Tamargo Saiz. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Para las migraciones
        let config = Realm.Configuration(
            //Cada vez que haga falta una migración (cambios en la estructura de las clases a guardar), hay que aumentar en 1 el número de schemaVersion
            //La migración inicial por defecto es la 0
            schemaVersion: 4,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config

        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        //let realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        do {
            let realm = try Realm()
            
            //OJO, IMPLEMENTAR ESTA PARTE DEL CÓDIGO DONDE DEMOS LA OPCIÓN DE ELIMINAR CUALQUIER USUARIO
            print("Depuración de registros cuyo usuario haya sido eliminado...")
            let registros = realm.objects(Registro.self)
            for registro in registros {
                if registro.usuario == nil {
                    try realm.write {
                        realm.delete(registro)
                        print("Registro borrado")
                    }
                }
            }
            /*
            let borrarUltimoUsuario = realm.objects(Usuario.self).last!
            try realm.write {
                realm.delete(borrarUltimoUsuario)
                print("Usuario borrado")
            }
            */
            //print(Realm.Configuration.defaultConfiguration.fileURL)
        } catch {
            print("Error al ejecutar Realm en AppDelegate, \(error)")
        }
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

