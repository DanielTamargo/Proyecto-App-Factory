//
//  File.swift
//  AppFactory
//
//  Created by  on 13/02/2020.
//  Copyright © 2020 Daniel Tamargo Saiz. All rights reserved.
//

import Foundation
import CardParts

class CardPartButtonController: CardPartsViewController {
    
    let cardPartTextView = CardPartTextView(type: .normal)
    let cardPartButtonView = CardPartButtonView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartTextView.text = "Testing Botones"
        
        cardPartButtonView.setTitle("Botón!", for: .normal)
        cardPartButtonView.setTitleColor(UIColor.magenta, for: .normal)
        cardPartButtonView.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        setupCardParts([cardPartTextView, cardPartButtonView])
    }
    
    @objc func buttonTapped() {
        
        let alertController = UIAlertController(title: "Botón apretado!", message: "Has apretado el botón", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
