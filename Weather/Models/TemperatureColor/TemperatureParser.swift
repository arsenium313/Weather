//
//  TemperatureParser.swift
//  Weather
//
//  Created by Арсений Кухарев on 05.07.2023.
//

import Foundation

struct TemperatureParser {
    
    let path = Bundle.main.path(forResource: "temperatureColors", ofType: "csv")
    var data = ""
    var colorValues: [TemperatureColor] = []
    
    init() {
        parse()
    }
    
    mutating func parse() {
        guard let path = path else { return }
        do {
            try data = String(contentsOfFile: path)
        } catch {
            print(error)
        }
        
        var rows = data.components(separatedBy: "\n")
        rows.removeFirst()
        
        for row in rows {
            let column = row.components(separatedBy: ",")
            if column.count == 6 {
                let value = Double(column[0]) ?? 0
                let r = Int(column[1]) ?? 0
                let g = Int(column[2]) ?? 0
                let b = Int(column[3]) ?? 0
                let a = Int(column[4]) ?? 0
                let hex = column[5]
                
                let color = TemperatureColor(value: value, r: r,
                                             g: g, b: b,
                                             a: a, hex: hex)
                colorValues.append(color)
            }
        }
        
    }
    
}
