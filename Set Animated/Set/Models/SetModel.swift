//
//  Set.swift
//  Set
//
//  Created by Ivan Ho on 2/7/19.
//  Copyright © 2019 Ivan Ho. All rights reserved.
//

import Foundation

struct SetModel {
    mutating private func createDeck() {
        for color in SetCard.Color.all {
            for number in SetCard.Number.all {
                for shade in SetCard.Shade.all {
                    for shape in SetCard.Shape.all {
                        cards.append(SetCard(color: color, number: number, shape: shape, shade: shade))
                    }
                }
            }
        }
        cards.shuffle()
    }
    
    mutating func startGame() {
        createDeck()
        for _ in 1...12 {
            cardsOnTable.append(cards.removeFirst())
        }
    }
    
    private(set) var cards = [SetCard]()
    private(set) var cardsOnTable = [SetCard]()
    private(set) var selectedCards = [SetCard]()
    private(set) var matchedCards = [SetCard]()
    private(set) var score = 0
    
    mutating func drawThreeCards() throws {

        for _ in 1...3 {
            if(!cards.isEmpty) {
                cardsOnTable.append(cards.removeFirst())
            } else {
                // deck is empty
                throw DealingError.deckEmptyError
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        let card = cardsOnTable[index]
        
        // Allow selection/deselection when 0,1,2 cards selected
        if selectedCards.count < 3 {
            if selectedCards.contains(card) {
                let selectedCardIndex = selectedCards.firstIndex(of: card)
                selectedCards.remove(at: selectedCardIndex!)
            } else {
                selectedCards.append(card)
            }
        } else {
            // 3 cards in selected cards
            if selectedCards.contains(card) {
                // do nothing
            } else {
                // try to match, reset the selected cards
                tryToMatchCards()
                selectedCards.append(card)

            }
        }
        
    }
    
    mutating func tryToMatchCards() {
        let isSet = isCardsASet(with: selectedCards)
        if isSet {
            matchedCards.append(contentsOf: selectedCards)
            score += 3
            // replace those cards with new ones
            if !cards.isEmpty {
                for i in 0..<3 {
                    let cardIndex = cardsOnTable.firstIndex(of: selectedCards[i])
                    cardsOnTable[cardIndex!] = cards.removeFirst()
                }
            } else {
                // deck is empty
                for i in 0..<3 {
                    let cardIndex = cardsOnTable.firstIndex(of: selectedCards[i])
                    cardsOnTable.remove(at: cardIndex!)
                }
                
            }
        } else {
            score -= 5
        }
        selectedCards.removeAll()
    }
    
    func isCardsASet(with cards: [SetCard]) -> Bool {
        assert(cards.count == 3)
//        let colors = Set(cards.map{ $0.color }).count
//        let shapes = Set(cards.map{ $0.shape }).count
//        let numbers = Set(cards.map{ $0.number }).count
//        let shades = Set(cards.map{ $0.shade }).count
//
//
//        return colors != 2 && shapes != 2 && numbers != 2 && shades != 2
        return true
    }
    
    mutating func startNewGame() {
        cards.removeAll()
        cardsOnTable.removeAll()
        selectedCards.removeAll()
        matchedCards.removeAll()
        startGame()
        score = 0
    }
    
    mutating func shuffleCardsOnTable() {
        cardsOnTable.shuffle()
    }

}

enum DealingError: Error {
    case deckEmptyError
//    case playingAreaFullError
}
