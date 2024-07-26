//
//  CalculatorButton.swift
//  Calculator
//
//  Created by Wilmer Núñez on 20/03/24.
//

import UIKit

enum CalculatorButton {
    case allClear
    case plusMinus
    case percentage
    case divide
    case multiply
    case substract
    case add
    case equals
    case number(Int)
    case decimal
    
    init(calcButton: CalculatorButton) {
        switch calcButton {
            case.allClear, .plusMinus, .percentage, .divide, .multiply, .add, .equals, .decimal, .substract:
                self = calcButton
            case .number(let int):
                if int.description.count == 1 {
                    self = calcButton
                } else {
                    fatalError("CalculatorButton.number Int wasnt 1 digit during init")
                }
        }
    }
}

extension CalculatorButton {
    var title: String {
        switch self {
            case .allClear:
                return "AC"
            case .plusMinus:
                return "+/-"
            case .percentage:
                return "%"
            case .divide:
                return "÷"
            case .multiply:
                return "x"
            case .substract:
                return "-"
            case .add:
                return "+"
            case .equals:
                return "="
            case .number(let int):
                return int.description
            case .decimal:
                return "."
        }
    }
    
    var color: UIColor {
        let colorButton = UIColor.hexaColor(hex: "#FFA552")
        let colorButton2 = UIColor.hexaColor(hex: "#475B5A")
        switch self {
            case .allClear, .plusMinus, .percentage:
                return colorButton2
            case .divide, .multiply, .substract, .add, .equals:
                return colorButton
            case .number, .decimal:
                return colorButton2
        }
    }
    
    var selectedColor: UIColor? {
        switch self {
            case .allClear, .plusMinus, .percentage, .equals, .number, .decimal:
                return nil
            case .divide, .multiply, .substract, .add:
                return .white
        }
    }
}

// Función para convertir hexadecimales a UIColor
    extension UIColor {
        static func hexaColor(hex: String) -> UIColor {
            var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
         
            if (cString.hasPrefix("#")) {
                cString.remove(at: cString.startIndex)
            }
         
            if ((cString.count) != 6) {
                return UIColor.gray
            }
         
            var rgbValue: UInt64 = 0
            Scanner(string: cString).scanHexInt64(&rgbValue)
         
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
     }
}
