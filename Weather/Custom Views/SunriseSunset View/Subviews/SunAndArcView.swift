//
//  SunAndArcTogether.swift
//  GradientTest
//
//  Created by Арсений Кухарев on 13.07.2023.
//

import UIKit

class SunAndArcView: UIView {

    //MARK: Properties
    var startTimeStamp: Int = 0
    var endTimeStamp: Int = 0
  
    let arcImage = UIImage(named: "arcImage")
    private lazy var arcView = UIImageView(image: arcImage) //ArcView()
    private let sunImage = UIImage(named: "sunImage")
    private let sunView =  SunView()//UIImageView
    private var radius: CGFloat = 0

    
    //MARK: - Init
    override init(frame: CGRect) {
      //  self.sunView = UIImageView(image: sunImage)
        super.init(frame: frame)
        self.addSubview(arcView)
        self.addSubview(sunView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - SetupUI
    private func setupUI() {
        configureImageView()
    }
    private func configureImageView() {
        
    }
    
    //MARK: - Drawing
    override func draw(_ rect: CGRect) {
        print("sunAndArc 🎨")
        self.radius = rect.width - rect.width / 2 < rect.height ? (rect.width / 2) * 0.95 : rect.height * 0.95 // Коэфициент размера дуги относительно размера вью
      //  arcView.radius = radius
        
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
    private func configurePositionOfSunFor(_ angle: Int) -> CGPoint {
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
