//
//  ArcRenderer.swift
//  ImageRenderer
//
//  Created by Арсений Кухарев on 07.10.2023.
//

import UIKit

struct ArcRenderer {
    /**
     - Parameter rect: Размер полотна
     */
    public func createArcImage(in rect: CGRect, arcRadius: CGFloat) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: rect.width,
                                                            height: rect.height))
        let img = renderer.image { _ in
            let center = CGPoint(x: rect.midX, y: rect.maxY)
            let path =  UIBezierPath(arcCenter: center, 
                                     radius: arcRadius,
                                     startAngle: .pi,
                                     endAngle: 0,
                                     clockwise: true)
            
            path.lineWidth = arcRadius * 0.04
            path.lineCapStyle = CGLineCap.round
            
            //Рисуем пунктир
            let dashes: [CGFloat] = [6, 12]
            path.setLineDash(dashes, count: dashes.count, phase: 0)
            #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).setStroke()
            path.stroke()
        }
        
        return img
    }
}


