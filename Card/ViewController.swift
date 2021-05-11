//
//  ViewController.swift
//  Card
//
//  Created by Anh Dinh on 2/23/21.
//

import UIKit

class ViewController: UIViewController {
    
    // probably will need to have like, multiple cardDeck?
    // each UIItem is a cardDeck of its own...
    var cardDeck = CardDeck()
    
    @IBOutlet weak var cardView: CardView! {
        didSet {

            if let card = cardDeck.drawRandomCard() {
                cardView.rank = card.rank.order
                cardView.suit = card.suit.rawValue
            }

            let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
            swipeGestureRecognizer.direction = [.left, .right]
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: cardView, action: #selector(CardView.adjustFaceCardScale(byHandlingGestureRecognizedBy:)))
            cardView.addGestureRecognizer(swipeGestureRecognizer)
            cardView.addGestureRecognizer(pinchGestureRecognizer)
        }
    }
    
    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            cardView.isFaceUp = !cardView.isFaceUp
        default: break
        }
    }
    
    @objc func nextCard() {
        if let card = cardDeck.drawRandomCard() {
            cardView.rank = Int(card.rank.order)
            cardView.suit = String(card.suit.rawValue)
            cardView.isFaceUp = false
        }
    }
}

