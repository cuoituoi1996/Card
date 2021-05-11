//
//  ViewController.swift
//  Card
//
//  Created by Anh Dinh on 2/23/21.
//

import UIKit

class ViewController: UIViewController {
    
    var cardDeck = CardDeck()
    
    // maybe learn how to do multiple MVC and put a newgame screen?
    
    @IBOutlet weak var cardView: CardView! {
        didSet {
            // probably will need to remove the card that is currently being displayed from the deck
            let currentRank = Card.Rank(rawValue: cardView.rankString)
            let currentSuit = Card.Suit(rawValue: cardView.suit)
            let cardToBeDiscarded = Card(suit: currentSuit!, rank: currentRank!, isFaceUp: true)
            cardDeck.discardCard(cardToBeDiscarded)
            let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
            swipeGestureRecognizer.direction = [.left, .right]
            cardView.addGestureRecognizer(swipeGestureRecognizer)
        }
    }
    
    @objc func nextCard() {
        if let card = cardDeck.drawRandomCard() {
            cardView.rank = Int(card.rank.order)
            cardView.suit = String(card.suit.rawValue)
            cardView.isFaceUp = false
            cardView.isFaceUp = true
        }
    }
}

