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
    var id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartTextView.text = "Testing Botones"
        
        cardPartButtonView.setTitle("Botón!", for: .normal)
        cardPartButtonView.setTitleColor(UIColor.magenta, for: .normal)
        cardPartButtonView.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        cardPartButtonView.tag = MyVariables.currentButtonID
        id = MyVariables.currentButtonID
        MyVariables.currentButtonID += 1
        
        
        setupCardParts([cardPartTextView, cardPartButtonView])
    }
    
    @objc func buttonTapped() {
        if id != nil {
            print(id!)
        }
        let alertController = UIAlertController(title: "Botón apretado!", message: "Has apretado el botón", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
