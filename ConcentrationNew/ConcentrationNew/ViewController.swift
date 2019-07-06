//
//  ViewController.swift
//  ConcentrationNew
//
//  Created by Ivan Ho on 29/6/19.
//  Copyright © 2019 Ivan Ho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // set it only when someone needs it, so that i can use the cardButtons.count. Lazy cannot have didSet
    private lazy var game: ConcentrationNewModel = ConcentrationNewModel(numberOfPairsOfCards: numberOfPairsOfCards)
    var numberOfPairsOfCards: Int {
        get {
            return (cardButtons.count+1) / 2
        }
    }
    
    @IBAction func restartGame(_ sender: UIButton) {
        // restart the game
        game.restartGame()
        emoji.removeAll()
        currentEmojiChoice.removeAll()
        emojiThemeChoice = nil
        updateViewFromModel()
        
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("not in array")

        }
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 1, green: 0.6470588235, blue: 0.007843137255, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    private func updateViewFromModel() {
        scoreLabel.text = "Score: \(game.score)"
        updateFlipCountLabel()

        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.6470588235, blue: 0.007843137255, alpha: 1)
            }
        }
    }
        
    private var emojiThemes: Array<Array<String>> = [
        ["👻","🎃","🦇","🍭","🌑","🍬"],
        ["🍓","🍈","🍒","🍑","🥭","🍆"],
        ["🏑","⛸","🥎","🏓","⚽️","🏀"],
        ["🎹","🎤","🥁","🎻","🎷","🎸"],
        ["🚗","🚛","🚑","🚌","🚕","🚜"],
        ["❤️","💙","💜","🖤","💛","💔"]
    ]
    
    // Dictionary, hashmap
    private var emoji = [Card:String]()
    
    private var emojiThemeChoice: Int?
    
    private var currentEmojiChoice = Array<String>()
    
    private func emoji(for card: Card) -> String {
//        if emoji[card.identifier] != nil {
//            return emoji[card.identifier]!
//        } else {
//            return "?"
//        }
        
        if emojiThemeChoice == nil {
            emojiThemeChoice = emojiThemes.count.arc4random
            currentEmojiChoice = emojiThemes[emojiThemeChoice!]
        }
        
        if emoji[card] == nil {
            if currentEmojiChoice.count > 0 {
                emoji[card] = currentEmojiChoice.remove(at: currentEmojiChoice.count.arc4random)
            }
        }
        
        return emoji[card] ?? "?"
        
//
//
//        if emoji[card.identifier] == nil {
//            if emojiChoices.count > 0 {
//                emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
//            }
//
//        }
//        return emoji[card.identifier] ?? "?"
    }
    

    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}

