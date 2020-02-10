//
//  CeldaRegistroTableViewCell.swift
//  AppFactory
//
//  Created by  on 31/01/2020.
//  Copyright © 2020 Daniel Tamargo Saiz. All rights reserved.
//

import UIKit

class CeldaRegistroTableViewCell: UITableViewCell {

    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var distancia: UILabel!
    @IBOutlet weak var tiempo: UILabel!
    @IBOutlet weak var imagen_usuario: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
