//
//  UIColor+GetTemperatureColor.swift
//  Weather
//
//  Created by Арсений Кухарев on 05.07.2023.
//

import UIKit

extension UIColor {
    
    static func getTemperatureColor(Cº temperature: Double) -> UIColor {
        let parser = TemperatureParser()
        let values = parser.colorValues
    
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        for i in values {
            if i.value == temperature {
                r = CGFloat(i.r) / 255
                g = CGFloat(i.g) / 255
                b = CGFloat(i.b) / 255
                a = CGFloat(i.a) / 255 
            }
        }
    
        let color = UIColor(red: r, green: g, blue: b, alpha: a)
        return color
    }
    
    
}
