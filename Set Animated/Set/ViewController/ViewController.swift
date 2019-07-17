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
    lazy var animator = UIDynamicAnimator(referenceView: playingAreaView)
    lazy var cardBehavior = CardBehavior(in: animator)
    @IBOutlet weak var deckView: UIView!
    @IBOutlet weak var matchedSetsView: UIView!
    
    @IBAction func tapDeck(_ sender: UITapGestureRecognizer) {
        if game.selectedCards.count == 3 {
            game.tryToMatchCards()
        } else {
            do {
                try game.drawThreeCards()
            } catch DealingError.deckEmptyError {
                let alert = UIAlertController(title: "Oops", message: "Deck is empty!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } catch {
                print("Other errors")
            }
        }
        updateViewFromModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deckView.layer.cornerRadius = 10
        matchedSetsView.layer.cornerRadius = 10
        game.startNewGame()
        updateViewFromModel()
    }
    
    @IBOutlet weak var playingAreaView: PlayingAreaView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    
    private func updateViewFromModel() {
        scoreLabel.text = "Score: \(game.score)"

        if playingAreaView.cardButtons.count != game.cardsOnTable.count {
            if playingAreaView.cardButtons.count > game.cardsOnTable.count {
                playingAreaView.removeCardButtons(byAmount: playingAreaView.cardButtons.count - game.cardsOnTable.count)
            } else if playingAreaView.cardButtons.count < game.cardsOnTable.count {
                playingAreaView.addCardButtons(byAmount: game.cardsOnTable.count - playingAreaView.cardButtons.count)
                assignActionToButtons()
            }
            // Layout animation
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.3,
                delay: 0,
                options: [.curveEaseInOut],
                animations: {
                    self.playingAreaView.layoutIfNeeded()
            },
                completion: { finished in
                    // For cards with alpha = 0
                    self.dealCardsAnimation()
            })
            drawButtonAccordingToModel()
        } else {
            // For cards with alpha = 0
            dealCardsAnimation()
            drawButtonAccordingToModel()
            
            // Drawing the selected cards
            if game.selectedCards.count == 3  {
                if game.isCardsASet(with: game.selectedCards) {
                    for index in game.selectedCards.indices {
                        let cardButtonIndex = game.cardsOnTable.firstIndex(of: game.selectedCards[index])
                        let card = game.cardsOnTable[cardButtonIndex!]
                        let button = playingAreaView.cardButtons[cardButtonIndex!]
                        button.alpha = 0
                        let fakeButton = SetCardButton()
                        drawButtonWithCard(card, fakeButton)
                        playingAreaView.addSubview(fakeButton)
                        fakeButton.frame = button.frame
                        fakeButton.layer.cornerRadius = 10
                        fakeButton.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                        fakeButton.layer.borderWidth = 0.5
                        fakeButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                        fakeButton.isFaceUp = true
                        cardBehavior.addItem(fakeButton)
                        
                        Timer.scheduledTimer(
                            withTimeInterval: 1.0,
                            repeats: false,
                            block: { _ in
                                self.cardBehavior.removeItem(fakeButton)
                                UIViewPropertyAnimator.runningPropertyAnimator(
                                    withDuration: 0.3,
                                    delay: 0,
                                    options: [],
                                    animations: {
                                        fakeButton.transform = CGAffineTransform.identity
                                        fakeButton.frame = self.matchedSetsView.frame
                                    },
                                    completion: { finished in
                                        UIView.transition(
                                            with: fakeButton,
                                            duration: 0.5,
                                            options: [.transitionFlipFromLeft],
                                            animations: {
                                                fakeButton.isFaceUp = false
                                            },
                                            completion: { finished in
                                                fakeButton.removeFromSuperview()
                                            }
                                        )
                                    }
                                )
                        }
                        )
                        
                        
                    }
                    game.tryToMatchCards()
                    updateViewFromModel()
                } else {
                    for index in game.selectedCards.indices {
                        let cardButtonIndex = game.cardsOnTable.firstIndex(of: game.selectedCards[index])
                        let button = playingAreaView.cardButtons[cardButtonIndex!]
                        button.layer.borderColor = UIColor.red.cgColor
                    }
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
            } catch DealingError.deckEmptyError {
                let alert = UIAlertController(title: "Oops", message: "Deck is empty!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } catch {
                print("Other errors")
            }
        }
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
    
    private func drawButtonAccordingToModel() {
        // Drawing the SetCard on table
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
            
            drawButtonWithCard(card, button)
        }
    }
    
    private func drawButtonWithCard(_ card: SetCard, _ button: SetCardButton) {
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
    
    private func dealCardsAnimation() {

        let buttonsToBeDealt = playingAreaView.cardButtons.filter{$0.alpha == 0}
        var count = 0
        
        if !buttonsToBeDealt.isEmpty {
            if !game.cards.isEmpty {
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){ t in
                    let button = buttonsToBeDealt[count]
                    let originalFrame = button.frame
                    
                    button.isFaceUp = false
                    button.frame = self.deckView.frame
                    button.alpha = 1
                    
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 1.0,
                        delay: 0,
                        options: [.curveEaseInOut],
                        animations: {
                            
                            
                            button.frame = originalFrame
                            
                    },
                        completion: { finished in
                            UIView.transition(
                                with: button,
                                duration: 0.5,
                                options: [.transitionFlipFromLeft],
                                animations: {
                                    button.isFaceUp = true
                            }
                            )
                    })
                    count += 1
                    if count >= buttonsToBeDealt.count {
                        t.invalidate()
                    }
                }
            } else {
                for button in buttonsToBeDealt {
                    button.alpha = 1
                }
            }
        }
    }
}


