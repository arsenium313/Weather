//
//  SunAndArcTogether.swift
//  GradientTest
//
//  Created by Арсений Кухарев on 13.07.2023.
//

import UIKit

class SunAndArcView: UIView {

    //MARK: Properties
    var startTimeStamp: Double = 0
    var endTimeStamp: Double = 0
  
    private let arcView = ArcView()
    private let sunView = SunView()
    private var radius: CGFloat = 0

    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(arcView)
        self.addSubview(sunView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Drawing
    override func draw(_ rect: CGRect) {
        self.radius = rect.width - rect.width / 2 < rect.height ? (rect.width / 2) * 0.95 : rect.height * 0.95 // Коэфициент размера дуги относительно размера вью
        arcView.radius = radius
        
        let sunSize = radius * 0.7 // Размер солнца
        sunView.bounds.size = CGSize(width: sunSize, height: sunSize)
    
        let angle = findAngle(startTime: startTimeStamp, endTime: endTimeStamp)
        let center = configurePositionOfSunFor(angle)
        sunView.center = center

        arcView.frame = rect
    }

    
    //MARK: - Configure Position of the sun
    /**
        Рисуем положение солнца на дуге
        - Parameter angle: Угол от центра дуги в градусах, на котором отобразить солнце
    */
    private func configurePositionOfSunFor(_ angle: Double) -> CGPoint {
        // sin() и cos() принимают угол в радианах, в градусы переводим вручную
        let x = self.bounds.midX + radius * cos(CGFloat(angle) * (.pi / 180))
        let y = self.bounds.maxY - radius * sin(CGFloat(angle) * (.pi / 180))
        let center = CGPoint(x: x, y: y)
        return center
    }
    
    /// Находим на каком угле от центра дуги нарисовать солнце в зависимости от текущего времени
    private func findAngle(startTime: Double, endTime: Double) -> Double {
        let now = Date.now.timeIntervalSince1970
        let totalInDay = endTime - startTime
        guard totalInDay > 0 else { return 0 }
        let i = endTime - now
        let ratio = i / totalInDay
        return 180 * ratio
    }
    
}
