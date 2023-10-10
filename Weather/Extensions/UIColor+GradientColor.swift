//
//  UIColor+GradientColor.swift
//  Weather
//
//  Created by Арсений Кухарев on 09.10.2023.
//

import UIKit

extension UIColor {
    static func createGradientColor(in rect: CGRect,
                                    for colors: [CGColor]) -> UIColor {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: rect.width,
                                                            height: rect.height))
        let gradient = CGGradient(colorsSpace: .none,
                                  colors: colors as CFArray,
                                  locations: nil)
        
        let img = renderer.image { uiContext in
            guard let gradient = gradient else { return }
            let ctx = uiContext.cgContext
            ctx.drawLinearGradient(gradient,
                                   start: CGPoint(x: rect.midX, y: rect.minY),
                                   end: CGPoint(x: rect.midX, y: rect.maxY),
                                   options: .drawsAfterEndLocation)
        }
        
        let color = UIColor(patternImage: img)
        return color
    }

}
