//
//  Card.swift
//  ConcentrationNew
//
//  Created by Ivan Ho on 29/6/19.
//  Copyright © 2019 Ivan Ho. All rights reserved.
//

import Foundation

struct Card {
    var isFaceUp = false
    var isMatched = false
    var isVisited = false
    var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}


// Structs - no inheritence, value types(copy when passed). (class is reference types)
