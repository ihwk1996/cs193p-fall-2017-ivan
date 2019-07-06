//
//  ViewController.swift
//  Set
//
//  Created by Ivan Ho on 2/7/19.
//  Copyright © 2019 Ivan Ho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var game: SetModel = SetModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for button in cardButtons {
            clearAndDisableButton(button: button)
        }
        updateViewFromModel()
        
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    private func updateViewFromModel() {
        scoreLabel.text = "Score: \(game.score)"
        for index in game.cardsOnTable.indices {
            let button = cardButtons[index]
            button.isEnabled = true
            let card = game.cardsOnTable[index]
            
            drawCardButton(button: button, card: card)
        }
        
        if game.selectedCards.count == 3  {
            if game.isCardsASet(with: game.selectedCards) {
                for index in game.selectedCards.indices {
                    let cardButtonIndex = game.cardsOnTable.firstIndex(of: game.selectedCards[index])
                    let button = cardButtons[cardButtonIndex!]
                    button.layer.borderColor = UIColor.green.cgColor
                }
            } else {
                for index in game.selectedCards.indices {
                    let cardButtonIndex = game.cardsOnTable.firstIndex(of: game.selectedCards[index])
                    let button = cardButtons[cardButtonIndex!]
                    button.layer.borderColor = UIColor.red.cgColor
                }
            }
            
        }
    }
    
    private func drawCardButton(button: UIButton, card: SetCard) {
        if game.selectedCards.contains(card) {
            button.layer.borderWidth = 3.0
            button.layer.borderColor = UIColor.blue.cgColor
        } else {
            button.layer.borderWidth = 0
        }
        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = 8.0
        
        var attributes: [NSAttributedString.Key:Any] = [:]
        var title = ""
        var color = UIColor.black
        switch(card.color) {
        case .blue: color = #colorLiteral(red: 0.07843137255, green: 0.5568627451, blue: 1, alpha: 1)
        case .green: color = #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)
        case .red: color = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }
        
        switch(card.shape) {
        case .circle: title = "●"
        case .square: title = "■"
        case .diamond: title = "▲"
        }
        
        switch(card.shade) {
        case .fill: attributes[.strokeWidth] = -5
                    attributes[.foregroundColor] = color
        case .shaded: attributes[.strokeWidth] = -5
                      attributes[.foregroundColor] = color.withAlphaComponent(0.15)
        case .stroke: attributes[.strokeWidth] = 5
                      attributes[.foregroundColor] = color
        }
        
        switch(card.number) {
        case .one: break
        case .two: title = title + title
        case .three: title = title + title + title
        }
        
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        if game.matchedCards.contains(card) {
            // blank this
           clearAndDisableButton(button: button)
        }
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    @IBAction func dealThreeCards(_ sender: UIButton) {
        if game.selectedCards.count == 3 {
            game.tryToMatchCards()
        } else {
            do {
                try game.drawThreeCards()
            } catch DealingError.deckEmptyError {
                let alert = UIAlertController(title: "Oops", message: "Deck is empty!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } catch DealingError.playingAreaFullError {
                let alert = UIAlertController(title: "Oops", message: "Playing area is full!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } catch {
                print("Other errors")
            }
        }
        
        
        updateViewFromModel()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        for button in cardButtons {
            clearAndDisableButton(button: button)
        }
        game.startNewGame()
        updateViewFromModel()
    }
    
    
    private func clearAndDisableButton(button: UIButton) {
        button.backgroundColor = UIColor.clear
        button.isEnabled = false
        button.setAttributedTitle(nil, for: .normal)
    }
}

