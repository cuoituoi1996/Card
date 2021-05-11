//
//  Card.swift
//  Card
//
//  Created by Anh Dinh on 2/23/21.
//

import Foundation

struct Card: CustomStringConvertible {
    
    var description: String {
        return "\(rank)\(suit)"
    }
    
    var suit: Suit
    var rank: Rank
    var isFaceUp: Bool
    
    enum Suit: String, CustomStringConvertible {
        
        var description: String {
            return "\(self.rawValue)"
        }
        
        case hearts = "♥️"
        case diamonds = "♦️"
        case spades = "♠️"
        case clubs = "♣️"
        
        static var all: [Suit] {
            return [Suit.hearts, .diamonds, .spades, .clubs]
        }
    }
    
    enum Rank: String, CustomStringConvertible {
        
        var description: String {
            return "\(self.rawValue)"
        }
        
        var order: Int {
            switch self {
            case .ace: return 1
            case .two: return 2
            case .three: return 3
            case .four: return 4
            case .five: return 5
            case .six: return 6
            case .seven: return 7
            case .eight: return 8
            case .nine: return 9
            case .ten: return 10
            case .jack: return 11
            case .queen: return 12
            case .king: return 13
            }
        }
        
        case ace = "A"
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
        case six = "6"
        case seven = "7"
        case eight = "8"
        case nine = "9"
        case ten = "10"
        case jack = "J"
        case queen = "Q"
        case king = "K"
        
        static var all: [Rank] {
            return [Rank.ace, .two, .three, .four, .five, .six, .seven,
                    .eight, .nine, .ten, .jack, .queen, .king]
        }
    }
}
