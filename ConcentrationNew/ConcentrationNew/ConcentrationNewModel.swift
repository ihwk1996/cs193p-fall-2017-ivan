//
//  ConcentrationNewModel.swift
//  ConcentrationNew
//
//  Created by Ivan Ho on 29/6/19.
//  Copyright © 2019 Ivan Ho. All rights reserved.
//

import Foundation

struct ConcentrationNewModel {
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init() crash, must have at least 1 pair of cards")

        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            let matchingCard = card
            cards.append(card)
            cards.append(matchingCard)
        }
        
        // TODO: Shuffle cards
        cards.shuffle()
    }
    
    private(set) var cards = [Card]()
    
    private(set) var score = 0
    
    private(set) var flipCount = 0
        
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
            
            
//            return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil
            
//            var foundIndex: Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        set(newValue) {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard() crash, chosen index not in cards")
        if !cards[index].isMatched {
            // If one card currently is face up
            if let matchedIndex = indexOfOneAndOnlyFaceUpCard, matchedIndex != index {
                // check if cards match
                if cards[matchedIndex] == cards[index] {
                    cards[matchedIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else {
                    // didnt match, check if visited, minus points
                    if cards[matchedIndex].isVisited == true {
                        score -= 1
                    }
                    if cards[index].isVisited == true {
                        score -= 1
                    }
                    
                    // mark as visited
                    cards[index].isVisited = true
                    cards[matchedIndex].isVisited = true
                }
                
                cards[index].isFaceUp = true
                
            } else {
                // either no cards or 2 cards are face up
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        

        // increment flipcount
        flipCount += 1
    }
    
    mutating func restartGame() {
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
            cards[index].isVisited = false
        }
        flipCount = 0
        score = 0
        cards.shuffle()
    }
}


extension Collection {
    var oneAndOnly: Element? {
        // count and first are Collection methods
        return count == 1 ? first : nil
    }
}
