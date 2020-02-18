//
//  CardPartTextController.swift
//  AppFactory
//
//  Created by  on 13/02/2020.
//  Copyright © 2020 Daniel Tamargo Saiz. All rights reserved.
//

import UIKit
import CardParts

class CardPartTextController: CardPartsViewController {

    let cardPartTextView = CardPartTextView(type: .normal)
    var usuario = Usuario()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartTextView.text = "これはCardPartsのサンプルです。"
        
        setupCardParts([cardPartTextView])
    }

}
