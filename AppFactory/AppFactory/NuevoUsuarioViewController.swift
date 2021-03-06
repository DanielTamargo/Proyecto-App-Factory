//
//  NuevoUsuarioViewController.swift
//  AppFactory
//
//  Created by  on 04/02/2020.
//  Copyright © 2020 Daniel Tamargo Saiz. All rights reserved.
//

import UIKit
import RealmSwift

class NuevoUsuarioViewController: UIViewController {

    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var sexo: UISegmentedControl!
    @IBOutlet weak var altura: UITextField!
    @IBOutlet weak var peso: UITextField!
    @IBOutlet weak var fecha_nac: UIDatePicker!
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var guardar: UIButton!
    @IBOutlet weak var cancelar: UIButton!
    
    var numAvataresTotales = 15
    var contador = 1
    var finalizar = false
    
    var existe = false //esta variable cambia al comprobar que el id sea único
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let realm = try! Realm()
        if realm.objects(Usuario.self).count > 0 {
            let alertController = UIAlertController(title: "¡Cuidado!", message: "Si creas un nuevo usuario a partir de entonces este será el usuario predeterminado. Sé que quieres crear y elegir entre distintos usuarios, lo sé, pero es que las CardParts son duras de roer... ¿Quizás en próximas versiones? Si lo que quieres es continuar con el usuario que has usado hasta ahora, ¡corre y dale a cancelar para volver atrás!", preferredStyle: .alert)
            let actionGuardar = UIAlertAction(title: "¡Oído cocina!", style: .cancel) { (_) in
            }
            alertController.addAction(actionGuardar)
            present(alertController, animated: true, completion: nil)
        }
        
        guardar.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5);
        cancelar.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5);
        
        self.nickname.placeholder = "Ejemplo: Trueno"
        self.altura.placeholder = "Ejemplo: 172"
        self.peso.placeholder = "Ejemplo: 70"
        
        self.nickname.delegate = self
        self.altura.delegate = self
        self.peso.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func siguiente(_ sender: Any) {
        if (contador < numAvataresTotales) {
            contador += 1
        } else {
            contador = 1
        }
        actualizarImagen()
    }
    
    @IBAction func anterior(_ sender: Any) {
        if (contador > 1) {
            contador -= 1
        } else {
            contador = numAvataresTotales
        }
        actualizarImagen()
    }
    
    func actualizarImagen() {
        let imagen = UIImage(named: "avatar-\(contador)")
        avatar.image = imagen
    }
    
    @IBAction func nicknameChanged(_ sender: Any) {
        if nickname.text!.count > 16 {
            nickname.deleteBackward()
        }
    }
    
    @IBAction func alturaChanged(_ sender: Any) {
        if altura.text!.count > 3 {
            altura.deleteBackward()
        }
    }
    
    @IBAction func pesoChanged(_ sender: Any) {
        if peso.text!.count > 3 {
            peso.deleteBackward()
        }
    }
    
    @IBAction func guardar(_ sender: Any) {
        print("Nickname: \(nickname.text ?? "")")
        print("Sexo: \(sexo.selectedSegmentIndex)")
        print("Altura: \(altura.text ?? "")") //falta <- sacar solo
        print("Fecha Nac: \(fecha_nac.date)") //falta <- sacar solo año mes dia
        print("Contador: \(contador)")
        print()
        
        let fecha_nac_usuario = fecha_nac.date
        let numImagen_usuario = contador
        let sexo_usuario = sexo.selectedSegmentIndex
        let nickname_usuario = nickname.text
        
        //Hay que convertirlas a Double la altura y a Int el peso
        let altura_string = altura.text
        let peso_string = peso.text
        
        if (altura.text == "" || peso.text == "" || nickname.text == "") {
            let alertController = UIAlertController(title: "¡Faltan datos!", message: "¡Eh colega! Necesitamos que rellenes todos los datos para que la aplicación funcione correctamente :(", preferredStyle: .alert)
            let actionGuardar = UIAlertAction(title: "Vale", style: .cancel) { (_) in
            }
            alertController.addAction(actionGuardar)
            present(alertController, animated: true, completion: nil)
        } else {
        
            let altura_usuario = Int(altura_string!)
            let peso_usuario = Int(peso_string!)
            
            
            let usuario = Usuario()
            usuario.nickname = nickname_usuario!
            usuario.altura = altura_usuario!
            usuario.peso = peso_usuario!
            usuario.fecha_nac = fecha_nac_usuario
            usuario.num_icono = numImagen_usuario
            usuario.sexo = sexo_usuario
            
            let realm = try! Realm()
            
            existe = false //<- reseteamos el valor por si clica en el botón varias veces
            let usuarios = realm.objects(Usuario.self)
            print(usuarios.count)
            for usuario in usuarios {
                print(usuario.nickname)
                if (usuario.nickname == nickname_usuario) {
                    existe = true //<- si existe, no se guardará
                }
            }
            
            if (!existe) {
                try! realm.write {
                    realm.add(usuario)
                    print("Usuario añadido")
                    let alertController = UIAlertController(title: "¡Usuario guardado!", message: "A partir de ahora este será el usuario predeterminado.", preferredStyle: .alert)
                    let actionGuardar = UIAlertAction(title: "¡Bien!", style: .cancel) { (_) in
                        //let firstTextField = alertController.textFields![0] as UITextField
                        self.volverANuevoRecorrido()
                    }
                    alertController.addAction(actionGuardar)
                    present(alertController, animated: true, completion: nil)
                }
            } else {
                let alertController = UIAlertController(title: "Usuario ya existente", message: "Ese nombre de usuario tan molón ya está cogido :(, ¡pero seguro que encuentras otro mejor aún!", preferredStyle: .alert)
                let actionGuardar = UIAlertAction(title: "Vale", style: .cancel) { (_) in
                }
                alertController.addAction(actionGuardar)
                present(alertController, animated: true, completion: nil)
            }
            
            /*
            print()
            print(type(of: fecha_nac_usuario)) // Date
            print(type(of: altura_usuario_cm!)) // Double
            print(type(of: altura_usuario_cm)) // Optional<Double>
            print(type(of: peso_usuario!)) // Int
            */
        }
    }
    
    
    @IBAction func cancelar(_ sender: Any) {
        
        //let alertController = UIAlertController(title: "Cancelando...", message: "Si quieres crear un usuario, puedes hacerlo en cualquier momento", preferredStyle: .alert)
        let realm = try! Realm()
        
        if realm.objects(Usuario.self).count <= 0 {
            let alertController = UIAlertController(title: "¡Necesitas tener un usuario!", message: "¡Ey! ¡Necesitas registrar por lo menos un usuario para que la aplicación funcione!, ¡perdón por las molestias colega!", preferredStyle: .alert)
            let actionGuardar = UIAlertAction(title: "Okay", style: .cancel) { (_) in
                //self.volverANuevoRecorrido()
            }
            alertController.addAction(actionGuardar)
            present(alertController, animated: true, completion: nil)
            
        } else {
            let alertController = UIAlertController(title: "Cancelando...", message: "Usuario no guardado.", preferredStyle: .alert)
            let actionGuardar = UIAlertAction(title: "Okay", style: .cancel) { (_) in
                self.volverANuevoRecorrido()
            }
            alertController.addAction(actionGuardar)
            present(alertController, animated: true, completion: nil)
        }
        
        //dismiss(animated: true, completion: nil)
        //super.dismiss(animated: true, completion: nil)
        //self.dismiss(animated: true, completion: nil)
        //.dismiss no funciona, pero no quiero hacer un show a la ventana anterior desde el botón cancelar porque si no, al volver con el menú de navegación volveremos a esta ventana y no debería ser así
    }
    
    func volverANuevoRecorrido() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.navigationController?.popViewController(animated: true)
        /*let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NuevoRecorrido")// as NextViewController
        nextViewController.modalPresentationStyle = .automatic
        self.present(nextViewController, animated:true, completion:nil)*/
    }
    
}

extension NuevoUsuarioViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var caraceteres_permitidos = CharacterSet.decimalDigits
        var coleccion_caracteres = CharacterSet(charactersIn: string)
        if (textField == self.nickname) {
            caraceteres_permitidos = CharacterSet.alphanumerics
            coleccion_caracteres = CharacterSet(charactersIn: string)
            
            //checkMaxLength(textField: textField, maxLength: 16)
            print("nickname")
        } else {
            //checkMaxLength(textField: textField, maxLength: 3)
            print("peso o altura")
        }
        return caraceteres_permitidos.isSuperset(of: coleccion_caracteres)
    }
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        guard let text = textField.text else { return }
        if (text.count > maxLength) {
            textField.deleteBackward()
        }
    }
}
