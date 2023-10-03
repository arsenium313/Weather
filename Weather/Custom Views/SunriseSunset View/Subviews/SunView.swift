//
//  SunView.swift
//  GradientTest
//
//  Created by Арсений Кухарев on 12.07.2023.
//

import UIKit

class SunView: UIView {
      
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("Sun Init ✅")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Sun deinit ❌")
    }
    //MARK: - Drawing
    override func draw(_ rect: CGRect) {
        drawSun(rect)
    }
    
    ///Рисуем солнце и  его градиент
    func drawSun(_ rect: CGRect) {
        print("Sun 🎨")
        let center = CGPoint(x: rect.midX, y: rect.midY)
        // Коэфициент размера круга относительно всего вью, следить чтобы влезли черточки:
        let radius = rect.width < rect.height ? center.x * 0.7 : center.y * 0.7
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        // т.к gradient layer принимает маску другой layer, то создаём layer формы круг:
        let sunShapeLayer = CAShapeLayer()
        sunShapeLayer.path = path.cgPath
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = rect
        gradientLayer.colors = [#colorLiteral(red: 1, green: 0.7568627451, blue: 0, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0.5568627451, blue: 0, alpha: 1).cgColor]
        gradientLayer.locations = [0, 1]
        // Обрезаем слой с градиентом по форме круга:
        gradientLayer.mask = sunShapeLayer
        
        self.layer.addSublayer(gradientLayer)
        drawSunDashes(rect, radius: radius)
    }
    
    /// Рисуем чёрточки на окружности солнца
    func drawSunDashes(_ rect: CGRect, radius: CGFloat) {
        print("sunDashes 🎨")
        let dashesCount = 9
        let angle = CGFloat(Double.pi * 2) / CGFloat(dashesCount)
        
        let dashLayer = CALayer()
        dashLayer.backgroundColor = #colorLiteral(red: 1, green: 0.7568627451, blue: 0, alpha: 1)
        dashLayer.cornerRadius = 1.5
        
        let height = radius / 4 // чем меньше, тем длиннее линия
        let width = height * 0.35 // чем меньше, тем тоньше линия
        let yOffset = radius + radius / 3 // чем меньше, тем дальше от окружности солнца
        dashLayer.frame = CGRect(x: rect.midX - width / 2, y: rect.midY - yOffset, width: width, height: height)
        
        // Слой который дублирует другой слой
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.instanceCount = dashesCount
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1)
        replicatorLayer.addSublayer(dashLayer)
        replicatorLayer.frame = rect
        
        self.layer.addSublayer(replicatorLayer)
    }
    
}
