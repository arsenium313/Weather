//
//  SunriseView.swift
//  GradientTest
//
//  Created by Арсений Кухарев on 11.07.2023.
//

import UIKit

class SunriseSunsetView: UIView {
 
    //MARK: Properties
    private var titleLabel: UILabel!
    private var leftLabel: UILabel! // вынести в отдельный класс
    private var rightLabel: UILabel! // вынести в отдельный класс
    let sunAndArcView: SunAndArcView!

    let startTimeStamp: Int
    let endTimeStamp: Int
 
    enum SunCase {
        case sunrise
        case sunset
    }
    
    //MARK: - Init
    init(_ weather: SunriseSunsetViewDataModel) { // переименовать weather
        self.startTimeStamp = weather.startTimeStamp
        self.endTimeStamp = weather.endTimeStamp
        sunAndArcView = SunAndArcView(startTime: startTimeStamp,
                                      endTime: endTimeStamp)
    
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Drawing
    override func draw(_ rect: CGRect) {
        print("sunriseSunset gradient 🎨")
        // Рисуем градиент:
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
    
    
    //MARK: - SetupUI
    private func setupUI() {
        configureSelf()
        configureMainLabel()
        configureLeftLabel()
        configureRightLabel()
        configureSunriseSunsetView()
    }
    
    private func configureSelf() {
        self.layer.cornerRadius = 10 // сделать динамически? чем больше вью, тем больше нужен радиус?
        self.layer.masksToBounds = true
    }
    
    private func configureMainLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Sun & Moon"
        titleLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20)
        ])
    }
    
    private func configureLeftLabel() {
        let attributedString = getAtrributedString(timeStamp: startTimeStamp, sunCase: .sunrise)
        leftLabel = UILabel()
        leftLabel.attributedText = attributedString
        leftLabel.numberOfLines = 2
        leftLabel.textAlignment = .center
        leftLabel.adjustsFontSizeToFitWidth = true
        
        self.addSubview(leftLabel)
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            leftLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            leftLabel.widthAnchor.constraint(equalToConstant: 61) // сделать динамическую
        ])
    }
    
    private func configureRightLabel() {
        let attributedString = getAtrributedString(timeStamp: endTimeStamp, sunCase: .sunset)
        rightLabel = UILabel()
        rightLabel.attributedText = attributedString
        rightLabel.numberOfLines = 2
        rightLabel.textAlignment = .center
        rightLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(rightLabel)
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            rightLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            rightLabel.widthAnchor.constraint(equalToConstant: 61) // сделать динамическую
        ])
    }
    
    private func configureSunriseSunsetView() {
        self.addSubview(sunAndArcView)
        sunAndArcView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sunAndArcView.leadingAnchor.constraint(equalTo: leftLabel.trailingAnchor, constant: 10),
            sunAndArcView.trailingAnchor.constraint(equalTo: rightLabel.leadingAnchor, constant: -10),
            sunAndArcView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            sunAndArcView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.62)
        ])
        sunAndArcView.layoutIfNeeded()
        print(sunAndArcView.bounds)
        sunAndArcView.configureView()
    }
    
    
    //MARK: - Get Attributed string
    /// Возвращает готовую строку c атрибутами в UIlabel
    private func getAtrributedString(timeStamp: Int, sunCase: SunCase) -> NSMutableAttributedString {
        let timeString = getTimeStringFromTimeStamp(timeStamp)
        let attributedString = getAttributedStringFromTimeString(timeString, sunCase: sunCase)
        return attributedString
    }
    ///Конвертирует timeStamp в  строку формата HH:MM
    private func getTimeStringFromTimeStamp(_ timeStamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let formatted = date.formatted(date: .omitted, time: .shortened)
        return formatted
    }
    /**
     - Parameter timeString: Строка в формате HH:MM
     - Parameter sunCase: Определяет какую дополнительную строку вернет метод
     */
    private func getAttributedStringFromTimeString(_ timeString: String, sunCase: SunCase) -> NSMutableAttributedString {
        let additionalString = {
            switch sunCase {
            case .sunrise : return "\nSunrise"
            case .sunset : return "\nSunset"
            }
        }()
        
        let attributedText = NSMutableAttributedString()
        let timeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let additionalColor = #colorLiteral(red: 0.6078431373, green: 0.6196078431, blue: 0.6784313725, alpha: 1)
      
        let timeAtrributedString = NSAttributedString(string: timeString, attributes: [
            NSAttributedString.Key.foregroundColor : timeColor
        ])
        
        let additionalAttributedString = NSAttributedString(string: additionalString, attributes: [
            NSAttributedString.Key.foregroundColor : additionalColor,
            NSAttributedString.Key.kern : 1.5
        ])
        
        attributedText.append(timeAtrributedString)
        attributedText.append(additionalAttributedString)

        return attributedText
    }
    
}
