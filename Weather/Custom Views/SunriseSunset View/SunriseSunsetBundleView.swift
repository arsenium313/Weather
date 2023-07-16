//
//  SunriseView.swift
//  GradientTest
//
//  Created by Арсений Кухарев on 11.07.2023.
//

import UIKit

class SunriseSunsetBundleView: UIView {
 
    //MARK: Properties
    private var titleLabel: UILabel!
    private var leftLabel: UILabel!
    private var rightLabel: UILabel!
    let sunAndArcView = SunAndArcView()

    let startTimeStamp: Double
    let endTimeStamp: Double
 
    enum SunCase {
        case sunrise
        case sunset
    }
    
    //MARK: - Init
    init(startTimeStamp: Double, endTimeStamp: Double) {
        self.startTimeStamp = startTimeStamp
        self.endTimeStamp = endTimeStamp
        sunAndArcView.startTimeStamp = startTimeStamp
        sunAndArcView.endTimeStamp = endTimeStamp
        
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Drawing
    override func draw(_ rect: CGRect) {
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
        let timeString = getTimeStringFromTimeStamp(startTimeStamp)
        let attributedString = getAttributedStringForLabel(timeString, sunCase: .sunrise)
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
        let timeString = getTimeStringFromTimeStamp(endTimeStamp)
        let attributedString = getAttributedStringForLabel(timeString, sunCase: .sunset)
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
    }
    
    
    //MARK: - Get Attributed string
    private func getTimeStringFromTimeStamp(_ timeStamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let formatted = date.formatted(date: .omitted, time: .shortened)
        return formatted
    }
    /**
     - Parameter timeString: Строка в формате HH:MM
     - Parameter sunCase: Определяет какую дополнительную строку вернет метод
     */
    private func getAttributedStringForLabel(_ timeString: String, sunCase: SunCase) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: timeString)
        let timeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let additionalColor = #colorLiteral(red: 0.6078431373, green: 0.6196078431, blue: 0.6784313725, alpha: 1)
        let timeStringRange = NSRange(location: 0, length: 5) // Сделать динамически
        
        let attributedStringRange = {
            switch sunCase {
            case .sunrise : return NSRange(location: 6, length: 7) // Сделать динамически
            case .sunset : return NSRange(location: 6, length: 6) // Сделать динамически
            }
        }()
        
        let additionalString = {
            switch sunCase {
            case .sunrise : return NSMutableAttributedString(string: "\nSunrise")
            case .sunset : return NSMutableAttributedString(string: "\nSunset")
            }
        }()
        attributedText.append(additionalString)
        
        let timeAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : timeColor,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25)
        ]
        attributedText.addAttributes(timeAttributes, range: timeStringRange)
        
        let additionalStringAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : additionalColor,
            NSAttributedString.Key.kern : 1.5
        ]
        attributedText.addAttributes(additionalStringAttributes, range: attributedStringRange)

        return attributedText
    }
    
}
