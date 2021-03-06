//
//  CardView.swift
//  Card
//
//  Created by Anh Dinh on 2/24/21.
//

import UIKit

@IBDesignable
class CardView: UIView {
    
    @IBInspectable
    var rank: Int = 12 { didSet {setNeedsDisplay(); setNeedsLayout()}}
    @IBInspectable
    var suit: String = "♥️" { didSet {setNeedsDisplay(); setNeedsLayout()}}
    @IBInspectable
    var isFaceUp: Bool = false { didSet {setNeedsDisplay(); setNeedsLayout()}}
    
    var faceCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize { didSet { setNeedsDisplay() } }
    
    // Create a handler for the pinch gesture
    @objc func adjustFaceCardScale(byHandlingGestureRecognizedBy recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .ended, .changed:
            faceCardScale *= recognizer.scale
            recognizer.scale = 1.0
        default: break
        }
    }
    
    private var cornerString: NSAttributedString {
        return centeredAttributedString(rankString+"\n"+suit, fontSize: cornerFontSize)
    }
    
    // Draw the card using subviews
    private lazy var upperLeftCornerLabel = createCornerLabel()
    private lazy var lowerRightCornerLabel = createCornerLabel()
//    private lazy var faceCardImageView = createUiImageView(for: "\(rankString)\(suit)")
    // Main function that will be called when this UI is drawn
    // If we let all of our subview draw itself, then we won't need to implement this method.
    // Leaving it blank will be expensive, therefore, we can comment this out if we don't use this draw func
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        if isFaceUp {
            if let faceCardImage = UIImage(named: rankString+suit, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                faceCardImage.draw(in: bounds.zoom(by: faceCardScale))
            } else {
                drawPips()
            }
        } else {
            let backOfCardImage = UIImage(named: "stanford-tree", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection)
            backOfCardImage!.draw(in: bounds.zoom(by: faceCardScale))
        }
        
        /* Draw corner using draw function instead of subview, which only works 75%
//        // Draw corners: upper left corner
//        let upperLeftCornerUiLabel = UILabel()
//        upperLeftCornerUiLabel.numberOfLines = 0 // 0 means use as many lines as you need
//        upperLeftCornerUiLabel.attributedText = cornerString
//        upperLeftCornerUiLabel.frame.size = CGSize.zero
//        upperLeftCornerUiLabel.sizeToFit()
//        upperLeftCornerUiLabel.isHidden = !isFaceUp
//        upperLeftCornerUiLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
//        upperLeftCornerUiLabel.drawText(in: upperLeftCornerUiLabel.frame)
//
//        // Draw corners: lower right corner
//        let lowerRightCornerUiLabel = UILabel()
//        lowerRightCornerUiLabel.numberOfLines = 0
//        lowerRightCornerUiLabel.attributedText = cornerString
//        lowerRightCornerUiLabel.frame.size = CGSize.zero
//        lowerRightCornerUiLabel.sizeToFit()
//        lowerRightCornerUiLabel.isHidden = !isFaceUp
//        lowerRightCornerUiLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
//        // i cannot for the life of me to get this fucking transformation working. Will work on it tmr... :(
//        lowerRightCornerUiLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
//                .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
//                .offsetBy(dx: -lowerRightCornerUiLabel.frame.width, dy: -lowerRightCornerUiLabel.frame.height)
//        lowerRightCornerUiLabel.drawText(in: lowerRightCornerUiLabel.frame)
         */
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        configureCornerLabel(upperLeftCornerLabel)
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        configureCornerLabel(lowerRightCornerLabel)
        lowerRightCornerLabel.transform = CGAffineTransform.identity
            .translatedBy(x: lowerRightCornerLabel.frame.width, y: lowerRightCornerLabel.frame.height)
            .rotated(by: CGFloat.pi)
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
                .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
                .offsetBy(dx: -lowerRightCornerLabel.frame.width, dy: -lowerRightCornerLabel.frame.height)
    }
        
    // Everytime System font is changed, detect and match the new font of the system
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    // -- Helper method -- //
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let color: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let attributedString = NSAttributedString(string: string, attributes: [.font: font,
                                                                               .paragraphStyle: paragraphStyle,
                                                                               .foregroundColor: color])
        return attributedString
    }
    
    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0 // 0 means use as many lines as you need
        self.addSubview(label) // add this label as a subview to this CardView
        return label
    }
    
    private func createUiImageView(for imageName: String) -> UIImageView? {
        if let image = UIImage(named: imageName, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
            let imageView = UIImageView(image: image)
            self.addSubview(imageView) // this line of code cannot be called in a draw_rect() function
            return imageView
        } else {
            return nil
        }
    }
    
    private func configureCornerLabel(_ label: UILabel) {
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFaceUp
    }
    
    private func configureFaceCardImage(_ imageView: UIImageView) {
        let imageBound = bounds.zoom(by: SizeRatio.faceCardImageSizeToBoundsSize)
        imageView.frame = imageBound
        imageView.layer.cornerRadius = 15.0
        imageView.layer.masksToBounds = true
    }
    
    private func drawPips()
        {
            let pipsPerRowForRank = [[0], [1], [1,1], [1,1,1], [2,2], [2,1,2], [2,2,2], [2,1,2,2], [2,2,2,2], [2,2,1,2,2], [2,2,2,2,2]]
            
            func createPipString(thatFits pipRect: CGRect) -> NSAttributedString {
                let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.count, $0)})
                let maxHorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.max() ?? 0, $0)})
                let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
                let attemptedPipString = centeredAttributedString(suit, fontSize: verticalPipRowSpacing)
                let probablyOkayPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
                let probablyOkayPipString = centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize)
                if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount {
                    return centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize /
                        (probablyOkayPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))
                } else {
                    return probablyOkayPipString
                }
            }
            
            if pipsPerRowForRank.indices.contains(rank) {
                let pipsPerRow = pipsPerRowForRank[rank]
                var pipRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset).insetBy(dx: cornerString.size().width, dy: cornerString.size().height / 2)
                let pipString = createPipString(thatFits: pipRect)
                let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
                pipRect.size.height = pipString.size().height
                pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
                for pipCount in pipsPerRow {
                    switch pipCount {
                    case 1:
                        pipString.draw(in: pipRect)
                    case 2:
                        pipString.draw(in: pipRect.leftHalf)
                        pipString.draw(in: pipRect.rightHalf)
                    default:
                        break
                    }
                    pipRect.origin.y += pipRowSpacing
                }
            }
        }
}

extension CardView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.55
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    
    var rankString: String {
        switch rank {
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}

extension CGRect {
    func zoom(by zoomFactor: CGFloat) -> CGRect {
        let zoomedWidth = size.width * zoomFactor
        let zoomedHeight = size.height * zoomFactor
        let originX = origin.x + (size.width - zoomedWidth) / 2
        let originY = origin.y + (size.height - zoomedHeight) / 2
        return CGRect(origin: CGPoint(x: originX,y: originY) , size: CGSize(width: zoomedWidth, height: zoomedHeight))
    }
    
    var leftHalf: CGRect {
        let width = size.width / 2
        return CGRect(origin: origin, size: CGSize(width: width, height: size.height))
    }
    
    var rightHalf: CGRect {
        let width = size.width / 2
        return CGRect(origin: CGPoint(x: origin.x + width, y: origin.y), size: CGSize(width: width, height: size.height))
    }
}

