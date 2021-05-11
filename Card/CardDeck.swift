//
//  CardDeck.swift
//  Card
//
//  Created by Anh Dinh on 2/23/21.
//

import Foundation

struct CardDeck {
    
    private(set) var cards = [Card]()
    
    init() {
        for suit in Card.Suit.all {
            for rank in Card.Rank.all {
                cards.append(Card(suit: suit, rank: rank, isFaceUp: true))
            }
        }
    }
    
    mutating func drawRandomCard() -> Card? {
        if cards.count > 0 {
            return cards.remove(at: Int.random(in: 0..<cards.count))
        } else {
            return nil
        }
    }
    
    mutating func discardCard(_ cardToBeDiscarded : Card) {
        var indexToRemove = -1
        for (index, card) in cards.enumerated() {
            if card.rank == cardToBeDiscarded.rank && card.suit == cardToBeDiscarded.suit {
                indexToRemove = index
            }
        }
        cards.remove(at: indexToRemove)
    }
}
