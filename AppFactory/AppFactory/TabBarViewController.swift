//
//  TabBarViewController.swift
//  AppFactory
//
//  Created by  on 07/02/2020.
//  Copyright © 2020 Daniel Tamargo Saiz. All rights reserved.
//

import UIKit
import RealmSwift

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        super.delegate = self
        
        let realm = try! Realm()
        
        let usuarios = realm.objects(Usuario.self)
        if usuarios.count <= 0 {
            let alertController = UIAlertController(title: "¡Tu primera vez!", message: "Vaya, veo que es la primera vez que vienes por aquí. Vas a tener que realizar un pequeño registro para que podamos calcular tus progresos correctamente. ¡Incluso podrás elegir tu avatar personalizado!", preferredStyle: .alert)
            let actionGuardar = UIAlertAction(title: "¡Vamos a ello!", style: .cancel) { (_) in
                //let firstTextField = alertController.textFields![0] as UITextField
                self.nuevoUsuario()
            }
            alertController.addAction(actionGuardar)
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func nuevoUsuario() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let pantallaRegistro = storyBoard.instantiateViewController(withIdentifier: "NuevoUsuario") as! NuevoUsuarioViewController
        navigationController?.pushViewController(pantallaRegistro, animated: true)
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

extension TabBarViewController: UITabBarControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
          return false // Make sure you want this as false
        }

        if fromView != toView {
          UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }

        return true
    }
}
