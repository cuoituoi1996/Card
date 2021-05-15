//
//  ViewController.swift
//  Card
//
//  Created by Anh Dinh on 2/23/21.
//

import UIKit

class ViewController: UIViewController {
    
    // make the card really big if they match, and disappear!
    
    var cardDeck = CardDeck()
    var cards = [Card]()
    @IBOutlet private var cardViews: [CardView]!
    
    private var faceUpCardViews : [CardView] {
        return cardViews.filter { $0.isFaceUp && !$0.isHidden }
    }
    
    override func viewDidLoad() {
        
        for _ in 1...((cardViews.count+1)/2) {
            let card = cardDeck.drawRandomCard()!
            cards += [card, card]
        }
        
        for cardView in cardViews {
            let card = cards.remove(at: Int.random(in: 0..<cards.count))
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            cardView.isFaceUp = false
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
        }
    }
    
    @objc func flipCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
//            print("Just tapped on card number: \(sender.view!)")
            if let tappedCard = sender.view as? CardView {
                UIView.transition(with: tappedCard,
                                  duration: 0.4,
                                  options: [.transitionFlipFromLeft],
                                  animations: {tappedCard.isFaceUp = !tappedCard.isFaceUp},
                                  completion: { finished in
                                    if self.faceUpCardViews.count >= 2 {
                                        self.faceUpCardViews.forEach { cardView in
                                            UIView.transition(with: cardView,
                                                              duration: 0.3,
                                                              options: [.transitionFlipFromLeft],
                                                              animations: {cardView.isFaceUp = !cardView.isFaceUp}
                                            )
                                        }
                                    }
                                  }
                )
            }
        default: break
        }
    }
    
//    // don't need this function for now
//    @objc func nextCard() {
//        if let card = cardDeck.drawRandomCard() {
//            cardView.rank = Int(card.rank.order)
//            cardView.suit = String(card.suit.rawValue)
//            cardView.isFaceUp = false
//        }
//    }

    
//        @IBOutlet weak var cardView: CardView! {
//        didSet {
//
//            if let card = cardDeck.drawRandomCard() {
//                cardView.rank = card.rank.order
//                cardView.suit = card.suit.rawValue
//            }
//
//            let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
//            swipeGestureRecognizer.direction = [.left, .right]
//            cardView.addGestureRecognizer(swipeGestureRecognizer)
//            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: cardView, action: #selector(CardView.adjustFaceCardScale(byHandlingGestureRecognizedBy:)))
//            cardView.addGestureRecognizer(pinchGestureRecognizer)
//        }
//    }

}

