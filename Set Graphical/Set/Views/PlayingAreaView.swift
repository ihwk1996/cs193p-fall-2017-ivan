//
//  PlayingAreaView.swift
//  Set
//
//  Created by Ivan Ho on 7/7/19.
//  Copyright © 2019 Ivan Ho. All rights reserved.
//

import UIKit

class PlayingAreaView: UIView {
    
    private(set) var cardButtons = [SetCardButton]()
    private(set) var grid = Grid.init(layout: .aspectRatio(1.5))
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        grid.frame = self.bounds
        
        for i in cardButtons.indices {
            let button = cardButtons[i]
            if let frame = grid[i] {
                button.frame = frame
            }
        }
    }
    
    func addThreeButtonsToView() {
        for _ in 1...3 {
            let button = SetCardButton()
            self.addSubview(button)
            cardButtons.append(button)
            grid.cellCount += 1
        }
        setNeedsLayout()
    }
    
    func removeCardButtons(byAmount numberOfCards: Int) {
        guard cardButtons.count >= numberOfCards else { return }
        
        for index in 0..<numberOfCards {
            let button = cardButtons[index]
            button.removeFromSuperview()
        }
        
        cardButtons.removeSubrange(0..<numberOfCards)
        grid.cellCount = cardButtons.count
        
        setNeedsLayout()
    }
    
    func startNewGame() {
        for button in cardButtons {
            button.removeFromSuperview()
        }
        grid.cellCount = 0
        for _ in 1...4 {
            addThreeButtonsToView()
        }
    }
}

//
//
//// Only override draw() if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//override func draw(_ rect: CGRect) {
//    // Drawing code
//    let button = SetCardButton(frame: CGRect(x: 0, y: 0, width: 200, height: 500))
//    button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//    button.cardSymbolNumber = .three
//    button.cardSymbolColor = .green
//    button.cardSymbolShape = .oval
//    button.cardSymbolShade = .striped
//    self.addSubview(button)
//}
