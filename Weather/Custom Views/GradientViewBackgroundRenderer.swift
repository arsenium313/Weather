//
//  GradientViewBackgroundRenderer.swift
//  Weather
//
//  Created by Арсений Кухарев on 08.10.2023.
//

import UIKit

struct GradientViewBackgroundRenderer {
    public func createBackgroundImage(in rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: rect.width,
                                                            height: rect.height))
        
        let img = renderer.image { uiContext in
            let ctx = uiContext.cgContext
            
            let startColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.1607843137, alpha: 1)
            let endColor = #colorLiteral(red: 0.1843137255, green: 0.1921568627, blue: 0.2274509804, alpha: 1)
            let colors = [startColor.cgColor, endColor.cgColor] as CFArray
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                      colors: colors,
                                      locations: [0.0, 1.0])
            
            let startPoint = CGPoint(x: rect.minX, y: rect.minY)
            let endPoint = CGPoint(x: rect.minX, y: rect.maxY)
            
            guard let gradient = gradient else { return }
            ctx.drawLinearGradient(gradient, 
                                   start: startPoint,
                                   end: endPoint,
                                   options: [])
        }
        
        return img
    }
}
