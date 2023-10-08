//
//  CircleViewRenderer.swift
//  Weather
//
//  Created by Арсений Кухарев on 08.10.2023.
//

import UIKit

struct CircleRenderer {
    public func createCircle(in rect: CGRect, 
                             forIndex index: CGFloat) -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: rect.width,
                                                            height: rect.height))
        
        let arcRadius = rect.width * 0.45 // чем больше, тем больше радиус арки
        let arcCenter = CGPoint(x: rect.midX,
                                y: rect.maxY - arcRadius * 0.7) // чем выше, тем арка выше относительно view
        
        let path = UIBezierPath(arcCenter: arcCenter,
                                radius: arcRadius,
                                startAngle: .pi - 0.7, // чем выше, тем левая часть арки больше
                                endAngle: 2 * .pi + 0.7, // чем выше, тем правая часть арки больше
                                clockwise: true)
        
        let img = renderer.image { uiContext in
            let ctx = uiContext.cgContext
            
            let grayCircleLayer = createGrayCircleLayer(in: rect,
                                                        withPath: path)
            grayCircleLayer.render(in: ctx)
            
            let colorCircleLayer = createColorCircleLayer(in: rect,
                                                          withPath: path,
                                                          forIndex: index)
            colorCircleLayer.render(in: ctx)
            
            let gradientLayer = createGradientLayer(in: rect)
            gradientLayer.mask = colorCircleLayer
            gradientLayer.render(in: ctx)
        }
        
        return img
    }
    
    
    //MARK: - Create layers
    /// Серый круг отображающийся независимо от индеса
    private func createGrayCircleLayer(in rect: CGRect, 
                                       withPath path: UIBezierPath) -> CALayer {
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        layer.fillColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0)
        layer.lineWidth = rect.width * 0.05 // чем больше, тем шире линия
        layer.lineCap = .round
        layer.frame = rect
        return layer
    }
    
    /// Разноцветный круг заполняется в зависимости от индекса
    private func createColorCircleLayer(in rect: CGRect,
                                        withPath path: UIBezierPath,
                                        forIndex index: CGFloat) -> CALayer {
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.strokeStart = 0
        // index может быть от 0 до 5, а strokeEnd принимает от 0 до 1
        layer.strokeEnd = index / 5 // делим на максимальное число которое может придти в index
        layer.fillColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 0)
        layer.lineWidth = rect.width * 0.05 // чем больше, тем шире линия
        layer.lineCap = .round
        layer.frame = rect
        return layer
    }
    
    private func createGradientLayer(in rect: CGRect) -> CALayer {
        let layer = CAGradientLayer()
        layer.colors = [#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).cgColor, #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1).cgColor,
                        #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1).cgColor,
                        #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1).cgColor, #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1).cgColor]
        layer.type = .conic
        
        // от 0 до 1, относительно view
        layer.startPoint = CGPoint(x: 0.5, // чем больше, тем левее относительно view
                                   y: 0.7) // чем больше, тем ниже относительно view
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        
        layer.frame = rect
        return layer
    }
    
}
