//
//  CalculatorOperation.swift
//  Calculator
//
//  Created by Wilmer Núñez on 22/03/24.
//

import Foundation

enum CalculatorOperation {
    case divide
    case multiply
    case substract
    case add
    
    var title: String {
        switch self {
        case .divide:
            return "÷"
        case .multiply:
            return "x"
        case .substract:
            return "-"
        case .add:
            return "+"
        }
    }
}
