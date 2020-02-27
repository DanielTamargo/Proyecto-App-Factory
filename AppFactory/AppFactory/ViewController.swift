//
//  ViewController.swift
//  AppFactory
//
//  Created by  on 17/01/2020.
//  Copyright © 2020 Daniel Tamargo Saiz. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyGif

class ViewController: UIViewController {

    var logoAnimationView = LogoAnimationView()

    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewDidLoad()
        let colorTop = UIColor.orange.withAlphaComponent(0.05)
        let colorBot = UIColor.orange.withAlphaComponent(0.65)
        let gradiente = CAGradientLayer()
        gradiente.colors = [colorTop.cgColor, colorBot.cgColor]
        gradiente.startPoint = CGPoint(x: 1,y: 0)
        gradiente.endPoint = CGPoint(x: 0,y: 1)
        gradiente.frame = view.bounds
        view.layer.addSublayer(gradiente)
        //cargarLogo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        logoAnimationView = LogoAnimationView()
        viewDidAppear(true)
    }

    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        cargarLogo()
    }
    
    func cargarLogo() {
        view.addSubview(logoAnimationView)
        logoAnimationView.pinEdgesToSuperView()
        logoAnimationView.isHidden = false
        logoAnimationView.logoGifImageView.delegate = self
        logoAnimationView.logoGifImageView.startAnimatingGif()
    }
}

extension ViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true
        self.performSegue(withIdentifier: "launchScreenOff", sender: nil)
    }
}

