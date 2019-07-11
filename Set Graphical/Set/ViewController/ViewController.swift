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
        game.startNewGame()
        playingAreaView.startNewGame()
        assignActionToButtons()
        updateViewFromModel()
    }
    
    @IBOutlet weak var playingAreaView: PlayingAreaView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dealThreeCards))
            swipe.direction = .down
            playingAreaView.addGestureRecognizer(swipe)
            
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCardsOnTable))
            playingAreaView.addGestureRecognizer(rotate)

            
        }
    }
    @IBOutlet weak var scoreLabel: UILabel!
    
    private func updateViewFromModel() {
        scoreLabel.text = "Score: \(game.score)"
        if playingAreaView.cardButtons.count > game.cardsOnTable.count {
            playingAreaView.removeCardButtons(byAmount: playingAreaView.cardButtons.count - game.cardsOnTable.count)
        }
        
        for index in game.cardsOnTable.indices {
            let button = playingAreaView.cardButtons[index]
            let card = game.cardsOnTable[index]
            
            if game.selectedCards.contains(card) {
                button.layer.cornerRadius = 10
                button.layer.borderWidth = 3.0
                button.layer.borderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            } else {
                button.layer.cornerRadius = 10
                button.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                button.layer.borderWidth = 0.5
            }
            
            switch card.color {
            case .green: button.cardSymbolColor = SetCardButton.CardSymbolColor.green
            case .purple: button.cardSymbolColor = SetCardButton.CardSymbolColor.purple
            case .red: button.cardSymbolColor = SetCardButton.CardSymbolColor.red
            }
            
            switch card.number {
            case.one: button.cardSymbolNumber = SetCardButton.CardSymbolNumber.one
            case.two: button.cardSymbolNumber = SetCardButton.CardSymbolNumber.two
            case.three: button.cardSymbolNumber = SetCardButton.CardSymbolNumber.three
            }
            
            switch card.shade {
            case.filled: button.cardSymbolShade = SetCardButton.CardSymbolShade.filled
            case.stroked: button.cardSymbolShade = SetCardButton.CardSymbolShade.stroked
            case.striped: button.cardSymbolShade = SetCardButton.CardSymbolShade.striped
            }
            
            switch card.shape {
            case.diamond: button.cardSymbolShape = SetCardButton.CardSymbolShape.diamond
            case.oval: button.cardSymbolShape = SetCardButton.CardSymbolShape.oval
            case.squiggle: button.cardSymbolShape = SetCardButton.CardSymbolShape.squiggle
            }
        }
        
        if game.selectedCards.count == 3  {
            if game.isCardsASet(with: game.selectedCards) {
                for index in game.selectedCards.indices {
                    let cardButtonIndex = game.cardsOnTable.firstIndex(of: game.selectedCards[index])
                    let button = playingAreaView.cardButtons[cardButtonIndex!]
                    button.layer.borderColor = UIColor.green.cgColor
                }
            } else {
                for index in game.selectedCards.indices {
                    let cardButtonIndex = game.cardsOnTable.firstIndex(of: game.selectedCards[index])
                    let button = playingAreaView.cardButtons[cardButtonIndex!]
                    button.layer.borderColor = UIColor.red.cgColor
                }
            }

        }
    }
    
    private func assignActionToButtons() {
        for button in playingAreaView.cardButtons {
            button.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        }
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        if let cardNumber = playingAreaView.cardButtons.firstIndex(of: sender as! SetCardButton) {
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
                playingAreaView.addThreeButtonsToView()
            } catch DealingError.deckEmptyError {
                let alert = UIAlertController(title: "Oops", message: "Deck is empty!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } catch {
                print("Other errors")
            }
        }
        
        assignActionToButtons()
        updateViewFromModel()
    }
    
    @objc func shuffleCardsOnTable(byHandlingGestureRecognizedBy recognizer: UIRotationGestureRecognizer) {
        if recognizer.state == UIRotationGestureRecognizer.State.ended {
            game.shuffleCardsOnTable()
            updateViewFromModel()
        }
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        playingAreaView.startNewGame()
        assignActionToButtons()
        game.startNewGame()
        updateViewFromModel()
    }
}

