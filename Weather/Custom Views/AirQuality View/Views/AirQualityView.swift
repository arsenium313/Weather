//
//  AirQualityView.swift
//  GradientTest
//
//  Created by Арсений Кухарев on 20.07.2023.
//

import UIKit

class AirQualityView: UIView {

    //MARK: Properties
    private let index: CGFloat  //  от 0 до 1  из JSON
    
    private var indexLabel: IndexLabel! //  индекс и строка описания под ним
    private var circleView: CircleView! // цветной круг
    private var nameLabel: UILabel!
    
    //MARK: - Init
    init(responce: AirQualityViewDataModel) { // принимает протокол со свойством индекс
        self.index = CGFloat(responce.index)
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - SetupUI
    private func setupUI() {
        setupSelf()
        configureCircleView()
        configureIndexLabel()
        configureNameLabel()
    }
    
    private func setupSelf() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 15 // сделать автоматически
    }
    
    private func configureCircleView() {
        circleView = CircleView(index: index)
        self.addSubview(circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            circleView.heightAnchor.constraint(equalTo: self.heightAnchor),
            circleView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    private func configureIndexLabel() {
        indexLabel = IndexLabel(index: Int(index))
        self.addSubview(indexLabel)
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indexLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indexLabel.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            indexLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.65),
            indexLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7)
        ])
    }
    
    private func configureNameLabel() {
        nameLabel = UILabel()
        self.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Air Quality"
        nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor)
        
        ])
    }
    
    
    //MARK: - Drawing
    override func draw(_ rect: CGRect) {
//      // Рисуем градиент:
    let startColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.1607843137, alpha: 1)
    let endColor = #colorLiteral(red: 0.1843137255, green: 0.1921568627, blue: 0.2274509804, alpha: 1)
    let colors = [startColor.cgColor, endColor.cgColor] as CFArray
    
    let startPoint = CGPoint(x: rect.minX, y: rect.minY)
    let endPoint = CGPoint(x: rect.minX, y: rect.maxY)
    
    let context = UIGraphicsGetCurrentContext()
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: [0.0, 1.0])
    
    guard let gradient = gradient, let context = context else { return }
    context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
    }

}


