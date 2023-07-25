//
//  CircleLayer.swift
//  GradientTest
//
//  Created by Арсений Кухарев on 20.07.2023.
//

import UIKit

class CircleView: UIView {

    //MARK: Properties
    private let index: CGFloat
    
    
    //MARK: - Init
    init(index: CGFloat) {
        self.index = index
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Drawing
    override func draw(_ rect: CGRect) {
        let radius = rect.width / 2.3 // выявлено методом научного тыка
        let arcCenter = CGPoint(x: rect.midX, y: rect.maxY - radius * 0.7) // выявлено методом научного тыка
        let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: .pi - 0.7, endAngle: 2 * .pi + 0.7 , clockwise: true) // выявлено методом научного тыка
        
        /// Серый круг отображающийся независимо от индеса
        let grayCircleLayer = CAShapeLayer()
        grayCircleLayer.path = path.cgPath
        grayCircleLayer.strokeColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        grayCircleLayer.fillColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0)
        grayCircleLayer.lineWidth = rect.width / 20 // выявлено методом научного тыка
        grayCircleLayer.frame = rect
        grayCircleLayer.lineCap = .round
        self.layer.addSublayer(grayCircleLayer)
        
        /// Разноцветный круг заполняется в зависимости от индекса
        let colorCircleLayer = CAShapeLayer()
        colorCircleLayer.path = path.cgPath
        colorCircleLayer.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        colorCircleLayer.strokeStart = 0
        colorCircleLayer.strokeEnd = index / 200 // выявлено методом научного тыка
        colorCircleLayer.lineCap = .round
        colorCircleLayer.fillColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 0)
        colorCircleLayer.lineWidth = rect.width / 20 // выявлено методом научного тыка
        colorCircleLayer.frame = rect

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).cgColor, #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1).cgColor, #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1).cgColor, #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1).cgColor, #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1).cgColor]
        gradientLayer.type = .conic
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.7) // от 0 до 1 // выявлено методом научного тыка
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1) // от 0 до 1 // выявлено методом научного тыка
        gradientLayer.frame = rect
        gradientLayer.mask = colorCircleLayer
        self.layer.addSublayer(gradientLayer)
    }
    
}
