//
//  VentanaUsuarioTestCardsViewController.swift
//  AppFactory
//
//  Created by  on 13/02/2020.
//  Copyright © 2020 Daniel Tamargo Saiz. All rights reserved.
//

import UIKit
import CardParts

class CardViewController: CardsViewController {

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
