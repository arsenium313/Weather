//
//  SunView.swift
//  GradientTest
//
//  Created by Арсений Кухарев on 11.07.2023.
//

import UIKit

class ArcView: UIView {

    //MARK: Properties
    var radius: CGFloat = 0

    
    //MARK: - Drawing
    override func draw(_ rect: CGRect) {
        drawGradient(rect)
        drawArc(rect)
    }
    
    /// Рисуем градиент по всей вью
    func drawGradient(_ rect: CGRect) {
        let startColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.1607843137, alpha: 1)
        let endColor = #colorLiteral(red: 0.1843137255, green: 0.1921568627, blue: 0.2274509804, alpha: 1)
        let colors = [startColor.cgColor, endColor.cgColor] as CFArray
        
        let gradientStartPoint = CGPoint(x: rect.minX, y: rect.minY)
        let gradientEndPoint = CGPoint(x: rect.minX, y: rect.maxY)
        
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: [0.0, 1.0])
        
        guard let gradient = gradient, let context = context else { return }
        context.drawLinearGradient(gradient, start: gradientStartPoint, end: gradientEndPoint, options: [])
    }
    
    func drawArc(_ rect: CGRect) {
        let center = CGPoint(x: rect.midX, y: rect.maxY)
        let path =  UIBezierPath(arcCenter: center, radius: radius, startAngle: .pi, endAngle: 0, clockwise: true)
        
        path.lineWidth = radius * 0.04
        path.lineCapStyle = CGLineCap.round
        
        //Рисуем пунктир
        let dashes: [CGFloat] = [6, 12]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        #colorLiteral(red: 0.6078431373, green: 0.6196078431, blue: 0.6784313725, alpha: 1).setStroke()
        path.stroke()
    }
    
}
