//
//  CardPartTableViewController.swift
//  AppFactory
//
//  Created by  on 13/02/2020.
//  Copyright © 2020 Daniel Tamargo Saiz. All rights reserved.
//

import Foundation
import CardParts
import RxCocoa
import RxSwift

class CardPartTableViewController: CardPartsViewController {
    
    let cardPartTextView = CardPartTextView(type: .title)
    let cardPartTableView = CardPartTableView()
    let viewModel = CardPartTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartTextView.text = "コメント"
        
        viewModel.listData.asObservable().bind(to: cardPartTableView.tableView.rx.items) { tableView, index, data in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: IndexPath(item: index, section: 0)) as? CardPartTableViewCell else { return UITableViewCell() }
            
            cell.leftTitleLabel.text = data
            
            return cell
            }.disposed(by: bag)
        
        setupCardParts([cardPartTextView, cardPartTableView])
    }
}

class CardPartTableViewModel {
    let name: [String] = ["あいう", "エオ", "かき", "くけこ", "さし", "すせそ", "たちつ"]
    let comment: [String] = ["いいですね！","行ってみたい","これはどこの部分ですか","普通だった","セーブオンも良いですよ","。。。","！！！！"]
    
    let listData: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    init() {
        
        var tempData: [String] = []
        
        for i in 0...5 {
            
            tempData.append("\(name[i]):  \(comment[i])")
        }
        
        listData.accept(tempData)
    }
}
