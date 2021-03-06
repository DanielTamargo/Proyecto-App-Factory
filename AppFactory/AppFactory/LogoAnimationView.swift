//
//  LogoAnimationView.swift
//  AppFactory
//
//  Created by  on 27/02/2020.
//  Copyright © 2020 Daniel Tamargo Saiz. All rights reserved.
//

import UIKit
import SwiftyGif

class LogoAnimationView: UIView {
    
    //cambiar la ruta aquí y en gifImage (no sé por qué no deja mandar la ruta como variable, te obliga a ponerla manualmente)
    let ruta = "Intro-Running-Alfada-GIF-Far.gif"
    
    let logoGifImageView: UIImageView = {
        guard let gifImage = try? UIImage(gifName: "Intro-Running-Alfada-GIF-Far.gif") else {
            return UIImageView()
        }
        return UIImageView(gifImage: gifImage, loopCount: 1)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        //backgroundColor = UIColor(white: 246.0 / 255.0, alpha: 1)
        //backgroundColor = UIColor(gradient)
        addSubview(logoGifImageView)
        logoGifImageView.translatesAutoresizingMaskIntoConstraints = false
        logoGifImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoGifImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        if ruta == "Intro-Running-Alfada-GIF-Close.gif" {
            logoGifImageView.widthAnchor.constraint(equalToConstant: 528).isActive = true
            logoGifImageView.heightAnchor.constraint(equalToConstant: 281).isActive = true
        } else {
            logoGifImageView.widthAnchor.constraint(equalToConstant: 902).isActive = true
            logoGifImageView.heightAnchor.constraint(equalToConstant: 480).isActive = true
        }
    }
}
