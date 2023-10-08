//
//  SunImage.swift
//  ImageRenderer
//
//  Created by Арсений Кухарев on 07.10.2023.
//

import UIKit

struct SunRenderer {
    /// View должно быть квадратным!
    public func createSunImage(in rect: CGRect) -> UIImage {
        /// Размер полотна
        let rendererSize = CGSize(width: rect.width,
                                  height: rect.height)
        /// Размер круга без черточек, относительно полотна
        let sunSize = CGSize(width: rendererSize.width * 0.7,
                             height: rendererSize.height * 0.7)
        
        let sunCenterX = rect.midX - sunSize.width / 2
        let sunCenterY = rect.midY - sunSize.height / 2
        let sunOrigin = CGPoint(x: sunCenterX, y: sunCenterY)
        
        let gradient = CGGradient(colorsSpace: nil,
                                  colors: [#colorLiteral(red: 0.9977391362, green: 0.7576897144, blue: 0, alpha: 1).cgColor, #colorLiteral(red: 0.9983323216, green: 0.5765205026, blue: 0, alpha: 1).cgColor] as CFArray,
                                  locations: [0, 1])
        
        let renderer = UIGraphicsImageRenderer(size: rendererSize)
        
        let img = renderer.image { uiContext in
            let ctx = uiContext.cgContext
            // Рисуем круг
            ctx.addEllipse(in: CGRect(origin: sunOrigin, size: sunSize))
            ctx.saveGState()
            ctx.clip()
            ctx.drawLinearGradient(gradient!,
                                   start: CGPoint(x: rect.midX, y: rect.minY),
                                   end: CGPoint(x: rect.midX, y: rect.maxY),
                                   options: .drawsBeforeStartLocation)
            ctx.restoreGState()
            // Рисуем лучи
            let dashLayer = createSunDashesLayer(in: rect)
            dashLayer.render(in: ctx)
        }
        
        return img
    }
    

    private func createSunDashesLayer(in rect: CGRect) -> CALayer {
        let dashLayer = CALayer()
        let dashDefaultSize = rect.width * 0.35
        let dashesCount = 9
        dashLayer.backgroundColor = #colorLiteral(red: 0.9977391362, green: 0.7576897144, blue: 0, alpha: 1)
        dashLayer.cornerRadius = 1.5
        
        let height = dashDefaultSize * 0.2 // чем больше, тем длиннее линия
        let width = dashDefaultSize * 0.09 // чем больше, тем толще линия
        let yOffset = dashDefaultSize + dashDefaultSize * 0.3 // чем больше, тем дальше от окружности солнца
       
        dashLayer.frame = CGRect(x: rect.midX - width / 2,
                                 y: rect.midY - yOffset,
                                 width: width,
                                 height: height)
        
        // Слой который дублирует другой слой
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.instanceCount = dashesCount
        let angle = CGFloat(Double.pi * 2) / CGFloat(dashesCount)
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1)
        replicatorLayer.addSublayer(dashLayer)
        replicatorLayer.frame = rect
        
        return replicatorLayer
    }
    
}
