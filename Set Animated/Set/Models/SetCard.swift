//
//  SetCard.swift
//  Set
//
//  Created by Ivan Ho on 2/7/19.
//  Copyright © 2019 Ivan Ho. All rights reserved.
//

import Foundation

struct SetCard: CustomStringConvertible, Equatable {
    var description: String  { return "\(number)\(color)\(shade)\(shape)" }
    
    static func ==(lhs: SetCard, rhs: SetCard) -> Bool {
        return lhs.color == rhs.color &&
            lhs.shape == rhs.shape &&
            lhs.number == rhs.number &&
            lhs.shade == rhs.shade
    }

    
    let color: Color
    let number: Number
    let shape: Shape
    let shade: Shade
    
    enum Color: String, CustomStringConvertible {
        var description: String { return rawValue }

        case red
        case green
        case purple
        
        static var all = [Color.red,.green,.purple]
    }
    
    enum Number: Int, CustomStringConvertible {
        var description: String { return String(rawValue) }
        
        case one = 1
        case two = 2
        case three = 3
        
        static var all = [Number.one,.two,.three]
    }
    
    enum Shape: String, CustomStringConvertible {
        var description: String { return rawValue }
        
        case diamond
        case squiggle
        case oval
        
        static var all = [Shape.diamond,.squiggle,.oval]
    }
    
    enum Shade: String, CustomStringConvertible {
        var description: String { return rawValue }

        case filled
        case stroked
        case striped
        
        static var all = [Shade.filled,.stroked,.striped]
    }
    
    
}
