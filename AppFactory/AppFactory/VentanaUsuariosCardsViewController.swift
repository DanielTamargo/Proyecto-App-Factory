//
//  VentanaUsuariosCardsViewController.swift
//  AppFactory
//
//  Created by  on 13/02/2020.
//  Copyright © 2020 Daniel Tamargo Saiz. All rights reserved.
//

import UIKit

import CardParts
import RxCocoa

class VentanaUsuariosCardsViewController: CardsViewController {

        override func viewDidLoad() {
        super.viewDidLoad()
        let cards: [CardPartsViewController] = [
            //CardPartTextController(),
            //ThemedCardViewController(title: "¡Usuarios!"),
            //CardPartTitleCardController(),
            //SecondCardPartTitleCardController(),
            CardPartPagedViewController(),
            //CardPartTableViewController(),
            //CardPartButtonController(),
            //CardPartsReactiveController()
        ]

        loadCards(cards: cards)
        
    }
    


}

func shadowColor() -> CGColor {
    return UIColor.lightGray.cgColor
}

func shadowRadius() -> CGFloat {
    return 10.0
}

// The value can be from 0.0 to 1.0.
// 0.0 => lighter shadow
// 1.0 => darker shadow
func shadowOpacity() -> Float {
    return 1.0
}

func shadowOffset() -> CGSize {
    return CGSize(width: 0, height: 5)
}

