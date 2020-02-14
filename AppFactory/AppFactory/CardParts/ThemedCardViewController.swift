//
//  ThemedCardViewController.swift
//  AppFactory
//
//  Created by  on 13/02/2020.
//  Copyright © 2020 Daniel Tamargo Saiz. All rights reserved.
//

import UIKit
import CardParts

class ThemedCardViewController:  CardPartsViewController{
    
    let subTitleCP = CardPartTextView(type: .header)
    let titleCP = CardPartTextView(type: .header)
    var _title: String = ""
    
    convenience init(title: String) {
        self.init(nibName: nil, bundle: nil)
        self._title = title
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleCP.text = self._title
        titleCP.textAlignment = .center
        titleCP.textColor = .white
        
        subTitleCP.text = "2019夏\nランキング\n集計完了"
        subTitleCP.textAlignment = .center
        
        setupCardParts([titleCP, subTitleCP])
        
        view.addConstraint(NSLayoutConstraint(item: view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 280))
    }
}

extension ThemedCardViewController: ShadowCardTrait {
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

extension ThemedCardViewController: RoundedCardTrait {
    func cornerRadius() -> CGFloat {
        return 10.0
    }
}

extension ThemedCardViewController: GradientCardTrait {
    func gradientColors() -> [UIColor] {
        
        let color1: UIColor = UIColor(red: 181.0 / 255.0, green: 152.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
        let color2: UIColor = UIColor(red: 30.0 / 255.0, green: 211.0 / 255.0, blue: 212.0 / 255.0, alpha: 1.0)
        return [color1, color2]
    }
    
    func gradientAngle() -> Float {
        return 45.0
    }
}
