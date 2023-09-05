//
//  MainView.swift
//  Weather
//
//  Created by Арсений Кухарев on 11.07.2023.
//

import UIKit

class GradientRootView: UIView {
    
    //MARK: Properties
    private let startColor = #colorLiteral(red: 0.2831242383, green: 0.2937351763, blue: 0.3573759198, alpha: 1)
    private let endColor = #colorLiteral(red: 0.1725490196, green: 0.1764705882, blue: 0.2078431373, alpha: 1)
    private lazy var colors = [startColor.cgColor, endColor.cgColor] as CFArray
    
    //MARK: - Drawing
    override func draw(_ rect: CGRect) {
        let startPoint = CGPoint(x: rect.minX, y: rect.minY)
        let endPoint = CGPoint(x: rect.minX, y: rect.maxY)
        
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: [0.0, 1.0])
        
        guard let context = context, let gradient = gradient else { return }
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
    }
}
