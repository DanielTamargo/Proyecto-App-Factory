//
//  CardPartPagedViewController.swift
//  AppFactory
//
//  Created by  on 13/02/2020.
//  Copyright © 2020 Daniel Tamargo Saiz. All rights reserved.
//

import UIKit
import CardParts
import RealmSwift
import Foundation


class CardPartPagedViewController: CardPartsViewController {
    
    private var currentPage = 0
    private var imageName = ""
    private var timer: Timer?
    
    let cardPartTextView = CardPartTextView(type: .normal)
    let nombreUsuario = CardPartTextView(type: .header)
    let emojis: [String] = ["😎", "🤪", "🤩", "👻", "🤟🏽", "💋", "💃🏽"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        
        let usuarios = realm.objects(Usuario.self)
        
        cardPartTextView.text = "Selecciona tu usuario"
        cardPartTextView.textAlignment = .center
        cardPartTextView.textColor = UIColor.orange
        
        var stackViews: [CardPartStackView] = []
                
        for (index, usuario) in usuarios.enumerated() {
            
            let sv = CardPartStackView()
            sv.axis = .vertical
            sv.spacing = 8
            stackViews.append(sv)
            sv.tag = currentPage
            
            let title = CardPartTextView(type: .normal)
            title.text = "\(usuario.nickname)"
            title.textAlignment = .center
            sv.addArrangedSubview(title)

            imageName = "avatar-\(usuario.num_icono)"
            if usuario.num_icono == 0 {
                imageName = "avatar-1"
            }
            let image = CardPartImageView(image: UIImage(named: imageName))
            image.contentMode = .scaleAspectFit
            sv.addArrangedSubview(image)
            
            let emoji = CardPartTextView(type: .normal)
            emoji.text = emojis[Int.random(in: 0 ..< emojis.count)]
            emoji.textAlignment = .center
            sv.addArrangedSubview(emoji)

            currentPage += 1 //usamos esto para distintos colores de fondo?
        }
        
        let cardPartPagedView = CardPartPagedView(withPages: stackViews, andHeight: 400)
        
        self.cardTapped(forState: .empty) {
            
            print("Card was tapped in .empty state!")
        }

        self.cardTapped(forState: .hasData) {
            print("Card was tapped in .hasData state!")
        }

        // The default state for setupCardParts([]) is .none
        self.cardTapped {
            print("Card was tapped in .none state")
            print(cardPartPagedView.pagina)
           
            
        }
        /*
        // To animate through the pages
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: {[weak self] (_) in
            
            guard let this = self else { return }
            this.currentPage = this.currentPage == this.emojis.count - 1 ? 0 : this.currentPage + 1
            cardPartPagedView.moveToPage(this.currentPage)
        })
        */
        
        setupCardParts([cardPartTextView, cardPartPagedView])
    }

}

extension CardPartPagedViewController: ShadowCardTrait {
    func shadowOffset() -> CGSize {
        return CGSize(width: 1.0, height: 1.0)
    }
    
    func shadowColor() -> CGColor {
        return UIColor.lightGray.cgColor
    }
    
    func shadowRadius() -> CGFloat {
        return 10.0
    }
    
    func shadowOpacity() -> Float {
        return 0.8
    }
}

extension CardPartPagedViewController: RoundedCardTrait {
    func cornerRadius() -> CGFloat {
        return 10.0
    }
}

extension CardPartPagedViewController: GradientCardTrait {
    func gradientColors() -> [UIColor] {
        
        let color1: UIColor = UIColor.orange.withAlphaComponent(0.1)
        let color2: UIColor = UIColor.orange.withAlphaComponent(0.65)
        return [color1, color2]
    }
    
    func gradientAngle() -> Float {
        return 0.0
    }
}

extension CardPartPagedViewController: BorderCardTrait{
    func borderWidth() -> CGFloat {
        return 2.0
    }

    func borderColor() -> CGColor {
        return UIColor.darkGray.cgColor
    }
}

extension CardPartPagedViewController: CustomMarginCardTrait {
    func customMargin() -> CGFloat {
        return 10.0
    }
}
