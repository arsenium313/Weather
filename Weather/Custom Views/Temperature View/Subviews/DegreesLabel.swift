//
//  DegreesLabel.swift
//  GradientTest
//
//  Created by Арсений Кухарев on 16.07.2023.
//

import UIKit

class DegreesLabel: UILabel {

    //MARK: Properties
   private let degree: Int
    
    
    //MARK: - Init
    init(degree: Int) {
        self.degree = degree
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - SetupUI
    private func setupUI() {
        configureSelf()
    }
    
    private func configureSelf() {
        self.text = String(degree) + "°"
        self.textAlignment = .center
        let fontSize = self.bounds.height
        self.font = .boldSystemFont(ofSize: fontSize)
        self.textColor = UIColor.createGradientColor(in: self.bounds,
                                                     for: getColors(for: degree))
    }
   
}


//MARK: - ConfigureViewProtocol
extension DegreesLabel: ConfigureViewProtocol {
    public func configureView() {
        setupUI()
    }
}


//MARK: - Find color for degree
extension DegreesLabel {
    private func getColors(for degree: Int) -> [CGColor] {
        switch degree {
            
        case -100 ... -35: return [#colorLiteral(red: 0.0897121951, green: 0.0002960140991, blue: 0.2586987913, alpha: 1).cgColor, #colorLiteral(red: 0.2257989347, green: 0.001808856265, blue: 0.4865512848, alpha: 1).cgColor]
        case -34 ... -30:  return [#colorLiteral(red: 0.2257989347, green: 0.001808856265, blue: 0.4865512848, alpha: 1).cgColor, #colorLiteral(red: 0.157881707, green: 0, blue: 0.6706417203, alpha: 1).cgColor]
        case -29 ... -25:  return [#colorLiteral(red: 0.157881707, green: 0, blue: 0.6706417203, alpha: 1).cgColor, #colorLiteral(red: 0.1055267528, green: 0.0526824221, blue: 0.8786177039, alpha: 1).cgColor]
        case -24 ... -20:  return [#colorLiteral(red: 0.1055267528, green: 0.0526824221, blue: 0.8786177039, alpha: 1).cgColor, #colorLiteral(red: 0.03713724762, green: 0.3068608344, blue: 0.9985254407, alpha: 1).cgColor]
        case -19 ... -15:  return [#colorLiteral(red: 0.03713724762, green: 0.3068608344, blue: 0.9985254407, alpha: 1).cgColor, #colorLiteral(red: 0.05564748496, green: 0.613144815, blue: 0.9894456267, alpha: 1).cgColor]
        case -14 ... -10:  return [#colorLiteral(red: 0.05564748496, green: 0.613144815, blue: 0.9894456267, alpha: 1).cgColor, #colorLiteral(red: 0.1921091974, green: 0.8194751143, blue: 0.9531494975, alpha: 1).cgColor]
        case -9 ... -5:    return [#colorLiteral(red: 0.1921091974, green: 0.8194751143, blue: 0.9531494975, alpha: 1).cgColor, #colorLiteral(red: 0.2421337366, green: 0.8589637876, blue: 0.8012353778, alpha: 1).cgColor]
        case -4 ... 0:     return [#colorLiteral(red: 0.2421337366, green: 0.8589637876, blue: 0.8012353778, alpha: 1).cgColor, #colorLiteral(red: 0.03187253699, green: 0.7762694955, blue: 0.4241903424, alpha: 1).cgColor]
        case 1 ... 5:      return [#colorLiteral(red: 0.03187253699, green: 0.7762694955, blue: 0.4241903424, alpha: 1).cgColor, #colorLiteral(red: 0.2964133322, green: 0.5832408667, blue: 0.03266612068, alpha: 1).cgColor]
        case 6 ... 10:     return [#colorLiteral(red: 0.2964133322, green: 0.5832408667, blue: 0.03266612068, alpha: 1).cgColor, #colorLiteral(red: 0.6965517402, green: 0.7870987058, blue: 0.02224986628, alpha: 1).cgColor]
        case 11 ... 15:    return [#colorLiteral(red: 0.6965517402, green: 0.7870987058, blue: 0.02224986628, alpha: 1).cgColor, #colorLiteral(red: 0.9219926596, green: 0.8971937299, blue: 0.08703450114, alpha: 1).cgColor]
        case 16 ... 20:    return [#colorLiteral(red: 0.9219926596, green: 0.8971937299, blue: 0.08703450114, alpha: 1).cgColor, #colorLiteral(red: 0.9422188997, green: 0.7904070616, blue: 0.1347100139, alpha: 1).cgColor]
        case 21 ... 25:    return [#colorLiteral(red: 0.9422188997, green: 0.7904070616, blue: 0.1347100139, alpha: 1).cgColor, #colorLiteral(red: 0.9386512637, green: 0.5158342123, blue: 0.1799608171, alpha: 1).cgColor]
        case 26 ... 30:    return [#colorLiteral(red: 0.9386512637, green: 0.5158342123, blue: 0.1799608171, alpha: 1).cgColor, #colorLiteral(red: 0.8817301989, green: 0.2942516208, blue: 0.1669972539, alpha: 1).cgColor]
        case 31 ... 35:    return [#colorLiteral(red: 0.8817301989, green: 0.2942516208, blue: 0.1669972539, alpha: 1).cgColor, #colorLiteral(red: 0.6703197956, green: 0.1246297881, blue: 0.1955948174, alpha: 1).cgColor]
        case 36 ... 40:    return [#colorLiteral(red: 0.6703197956, green: 0.1246297881, blue: 0.1955948174, alpha: 1).cgColor, #colorLiteral(red: 0.5096276999, green: 0.06809666008, blue: 0.1641784012, alpha: 1).cgColor]
        case 41...100:     return [#colorLiteral(red: 0.5096276999, green: 0.06809666008, blue: 0.1641784012, alpha: 1).cgColor, #colorLiteral(red: 0.2603037183, green: 0.066734083, blue: 0, alpha: 1).cgColor]
            
        default: return  [UIColor.white.cgColor, UIColor.black.cgColor]
        }
    }
}
