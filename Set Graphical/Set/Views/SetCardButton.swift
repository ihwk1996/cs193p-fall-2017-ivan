//
//  SetCardView.swift
//  Set
//
//  Created by Ivan Ho on 7/7/19.
//  Copyright © 2019 Ivan Ho. All rights reserved.
//

import UIKit

class SetCardButton: UIButton {
    // MARK: Properties
    /// The rect in which each path is drawn.
    private var drawableRect: CGRect {
        let drawableWidth = frame.size.width * 0.80
        let drawableHeight = frame.size.height * 0.90
        
        return CGRect(x: frame.size.width * 0.1,
                      y: frame.size.height * 0.05,
                      width: drawableWidth,
                      height: drawableHeight)
    }
    
    /// properties for the drawing spacing
    private var shapeHorizontalMargin: CGFloat {
        return drawableRect.width * 0.05
    }
    
    private var shapeVerticalMargin: CGFloat {
        return drawableRect.height * 0.05 + drawableRect.origin.y
    }
    
    private var shapeWidth: CGFloat {
        return (drawableRect.width - (2 * shapeHorizontalMargin)) / 3
    }
    
    private var shapeHeight: CGFloat {
        return drawableRect.size.height * 0.9
    }
    
    private var drawableCenter: CGPoint {
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }

    
    var cardSymbolShape: CardSymbolShape? { didSet { setNeedsDisplay() } }
    var cardSymbolColor: CardSymbolColor? { didSet { setNeedsDisplay() } }
    var cardSymbolShade: CardSymbolShade? { didSet { setNeedsDisplay() } }
    var cardSymbolNumber: CardSymbolNumber? { didSet { setNeedsDisplay() } }

    var path: UIBezierPath?
    
    override func draw(_ rect: CGRect) {
        guard let shape = cardSymbolShape else { return }
        guard let color = cardSymbolColor?.getColor() else { return }
        guard let shading = cardSymbolShade else { return }
        guard let number = cardSymbolNumber else { return }

        switch shape {
        case .squiggle:
            drawSquiggles(byAmount: number.rawValue)
            
        case .diamond:
            drawDiamonds(byAmount: number.rawValue)
            
        case .oval:
            drawOvals(byAmount: number.rawValue)
        }
        
        path!.lineCapStyle = .round
        
        switch shading {
        case .filled:
            color.setFill()
            path!.fill()
            
        case .stroked:
            color.setStroke()
            path!.lineWidth = 1 // TODO: Calculate the line width
            path!.stroke()
            
        case .striped:
            path!.lineWidth = 0.01 * frame.size.width
            color.setStroke()
            path!.stroke()
            path!.addClip()
            
            var currentX: CGFloat = 0
            
            let stripedPath = UIBezierPath()
            stripedPath.lineWidth = 0.005 * frame.size.width
            
            while currentX < frame.size.width {
                stripedPath.move(to: CGPoint(x: currentX, y: 0))
                stripedPath.addLine(to: CGPoint(x: currentX, y: frame.size.height))
                currentX += 0.03 * frame.size.width
            }
            
            color.setStroke()
            stripedPath.stroke()
            
            break
        }
    }
    
    
    // MARK: Draw functions
    /// Draws the squiggles to the drawable rect.
    private func drawSquiggles(byAmount amount: Int) {
        let path = UIBezierPath()
        let allSquigglesWidth = CGFloat(amount) * shapeWidth + CGFloat(amount - 1) * shapeHorizontalMargin
        let beginX = (frame.size.width - allSquigglesWidth) / 2
        
        for i in 0..<amount {
            let currentShapeX = beginX + (shapeWidth * CGFloat(i)) + (CGFloat(i) * shapeHorizontalMargin)
            let currentShapeY = shapeVerticalMargin
            let curveXOffset = shapeWidth * 0.35
            
            path.move(to: CGPoint(x: currentShapeX, y: currentShapeY))
            
            path.addCurve(to: CGPoint(x: currentShapeX, y: currentShapeY + shapeHeight),
                          controlPoint1: CGPoint(x: currentShapeX + curveXOffset, y: currentShapeY + shapeHeight / 3),
                          controlPoint2: CGPoint(x: currentShapeX - curveXOffset, y: currentShapeY + (shapeHeight / 3) * 2))
            
            path.addLine(to: CGPoint(x: currentShapeX + shapeWidth, y: currentShapeY + shapeHeight))
            
            path.addCurve(to: CGPoint(x: currentShapeX + shapeWidth, y: currentShapeY),
                          controlPoint1: CGPoint(x: currentShapeX + shapeWidth - curveXOffset, y: currentShapeY + (shapeHeight / 3) * 2),
                          controlPoint2: CGPoint(x: currentShapeX + shapeWidth + curveXOffset, y: currentShapeY + shapeHeight / 3))
            
            path.addLine(to: CGPoint(x: currentShapeX, y: currentShapeY))
        }
        
        self.path = path
    }
    
    /// Draws the ovals to the drawable rect.
    private func drawOvals(byAmount amount: Int) {
        let allOvalsWidth = CGFloat(amount) * shapeWidth + CGFloat(amount - 1) * shapeHorizontalMargin
        let beginX = (frame.size.width - allOvalsWidth) / 2
        path = UIBezierPath()
        
        for i in 0..<amount {
            let currentShapeX = beginX + (shapeWidth * CGFloat(i)) + (CGFloat(i) * shapeHorizontalMargin)
            
            path!.append(UIBezierPath(roundedRect: CGRect(x: currentShapeX,
                                                          y: shapeVerticalMargin,
                                                          width: shapeWidth,
                                                          height: shapeHeight),
                                      cornerRadius: shapeWidth))
        }
    }
    
    /// Draws the diamonds to the drawable rect.
    private func drawDiamonds(byAmount amount: Int) {
        let allDiamondsWidth = CGFloat(amount) * shapeWidth + CGFloat(amount - 1) * shapeHorizontalMargin
        let beginX = (frame.size.width - allDiamondsWidth) / 2
        
        let path = UIBezierPath()
        
        for i in 0..<amount {
            let currentShapeX = beginX + (shapeWidth * CGFloat(i)) + (CGFloat(i) * shapeHorizontalMargin)
            
            path.move(to: CGPoint(x: currentShapeX + shapeWidth / 2, y: shapeVerticalMargin))
            path.addLine(to: CGPoint(x: currentShapeX, y: drawableCenter.y))
            path.addLine(to: CGPoint(x: currentShapeX + shapeWidth / 2, y: shapeVerticalMargin + shapeHeight))
            path.addLine(to: CGPoint(x: currentShapeX + shapeWidth, y: drawableCenter.y))
            path.addLine(to: CGPoint(x: currentShapeX + shapeWidth / 2, y: shapeVerticalMargin))
        }
        
        self.path = path
    }
 

    // MARK: Internal types
    enum CardSymbolShape {
        case diamond
        case oval
        case squiggle
    }
    
    enum CardSymbolShade {
        case filled
        case stroked
        case striped
    }
    
    enum CardSymbolNumber: Int {
        case one = 1
        case two = 2
        case three = 3
    }
    
    enum CardSymbolColor {
        case red
        case green
        case purple
        
        func getColor() -> UIColor {
            switch self {
            case .red: return #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
            case .green: return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            case .purple: return #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            }
        }
    }
}
