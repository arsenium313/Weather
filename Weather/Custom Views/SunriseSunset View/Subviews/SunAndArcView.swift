//
//  SunAndArcTogether.swift
//  GradientTest
//
//  Created by Арсений Кухарев on 13.07.2023.
//

import UIKit

class SunAndArcView: UIView {
    
    // MARK: Properties
    private let arcImageView = UIImageView()
    private let sunImageView = UIImageView()
    
    private var startTime: Int
    private var endTime: Int
    private var arcRadius: CGFloat = 0
    
    
    //MARK: - Init
    init(startTime: Int, endTime: Int) {
        self.startTime = startTime
        self.endTime = endTime
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - SetupUI
    public func configureView() {
        arcRadius = findArcRadius()
        setupUI()
    }
    
    private func setupUI() {
        createArc()
        createSun()
    }
    
    private func createArc() {
        self.addSubview(arcImageView)
        arcImageView.frame = self.bounds
        let arcImage = ArcRenderer().createArcImage(in: self.bounds,
                                                    arcRadius: arcRadius)
        arcImageView.image = arcImage
    }
    
    private func createSun() {
        self.addSubview(sunImageView)
        /// Размер солнца относительно view
        let sunSizeRatio = 0.3
        let sunSize = self.bounds.width * sunSizeRatio
        sunImageView.bounds.size = CGSize(width: sunSize,
                                          height: sunSize)

        let sunImage = SunRenderer().createSunImage(in: CGRect(origin: .zero,
                                                            size: CGSize(width: sunSize,
                                                                         height: sunSize)))
        sunImageView.image = sunImage
        
        // Позиционируем imageView на superView
        let angle =  90 //findAngle(startTime: startTime, endTime: endTime)
        let center = findPositionOfSunFor(angle: angle, radius: arcRadius)
        sunImageView.center = center
    }
    
    
    // MARK: - Positioning of the sun
    
    /**
     Находим радиус дуги относительно размера view
     - Returns: Размер арки, которая впишется в размеры view,
     независимо что больше – ширина или высота view
     */
    private func findArcRadius() -> CGFloat {
        let rect = self.bounds
        /// Коэффициент радиуса арки относительно view
        let sizeRatio: CGFloat = 0.95 // чем больше, тем больше радиус арки относительно view
        return rect.width - rect.width / 2 < rect.height ?
        (rect.width / 2) * sizeRatio : rect.height * sizeRatio
    }
    
    /**
        Находим положение солнца на дуге
        - Parameter angle: Угол от центра дуги в градусах, на котором отобразить солнце
        - Parameter radius: Размер арки
        - Returns: center точку координат
    */
    private func findPositionOfSunFor(angle: Int, radius: CGFloat) -> CGPoint {
        // sin() и cos() принимают угол в радианах, в градусы переводим вручную
        let x = self.bounds.midX + radius * cos(CGFloat(angle) * (.pi / 180))
        let y = self.bounds.maxY - radius * sin(CGFloat(angle) * (.pi / 180))
        let center = CGPoint(x: x, y: y)
        return center
    }
    
    /// Находим на каком угле от центра дуги нарисовать солнце в зависимости от текущего времени
    private func findAngle(startTime: Int, endTime: Int) -> Int {
        let now = Date.now.timeIntervalSince1970
        let totalInDay = endTime - startTime
        guard totalInDay > 0 else { return 0 }
        let i = endTime - Int(now)
        let ratio = Double(i) / Double(totalInDay)
        let angle = 180 * ratio
        return Int(angle)
    }
}
