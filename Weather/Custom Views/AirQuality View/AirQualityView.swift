//
//  AirQualityView.swift
//  GradientTest
//
//  Created by Арсений Кухарев on 20.07.2023.
//

import UIKit

class AirQualityView: UIView {

    //MARK: Properties
    private let index: CGFloat  //  от 0 до 1? а не 5?  из JSON
    
    private var indexLabel: IndexLabel! //  индекс и строка описания под ним
    private var circleView: CircleView! // цветной круг
    private var nameLabel: UILabel!
    
    
    //MARK: - Init
    init(dataModel: AirQualityViewDataModel) {
        self.index = CGFloat(dataModel.index)
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - SetupUI
    internal func setupUI() {
        setupSelf()
        configureCircleView()
        configureIndexLabel()
        configureNameLabel()
    }
    
    private func setupSelf() {
        self.backgroundColor = UIColor.createGradientColor(in: self.bounds,
                                                           for: [#colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.1607843137, alpha: 1).cgColor,
                                                                 #colorLiteral(red: 0.1843137255, green: 0.1921568627, blue: 0.2274509804, alpha: 1).cgColor])
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
        circleView.layoutIfNeeded()
        circleView.configureView()
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
}


//MARK: - ConfigureViewProtocol
extension AirQualityView: ConfigureViewProtocol {
    public func configureView() {
        setupUI()
    }
}
