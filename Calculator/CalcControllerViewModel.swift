//
//  CalcControllerViewModel.swift
//  Calculator
//
//  Created by Wilmer Núñez on 20/03/24.
//

import Foundation

enum CurrentNumber {
    case firstNumber
    case secondNumber
}

class CalcControllerViewModel {
    
    var updateViews: (()->Void)?
    
    // MARK: - TableView DataSource Array
    let calcButtonCells: [CalculatorButton] = [
        .allClear, .plusMinus, .percentage, .divide,
        .number(7), .number(8), .number(9), .multiply,
        .number(4), .number(5), .number(6), .substract,
        .number(1), .number(2), .number(3), .add,
        .number(0), .decimal, .equals
    ]
    
    // MARK: - Normal Variables
    private(set) lazy var calcHeaderLabel: String = self.firstNumber ?? "0"
    private(set) var currentNumber: CurrentNumber = .firstNumber
    
    private(set) var firstNumber: String? = nil { didSet { self.calcHeaderLabel = self.firstNumber?.description ?? "0" } }
    private(set) var secondNumber: String? = nil { didSet { self.calcHeaderLabel = self.secondNumber?.description ?? "0" } }
    
    private(set) var operation: CalculatorOperation? = nil
    
    private(set) var firstNumberIsDecimal: Bool = false
    private(set) var secondNumberIsDecimal: Bool = false
    
    var eitherNumberIsDecimal: Bool {
        return firstNumberIsDecimal || secondNumberIsDecimal
    }
    
    // MARK: - Memory Variables
    private(set) var prevNumber: String? = nil
    private(set) var prevOperation: CalculatorOperation? = nil
}

extension CalcControllerViewModel {
    
    public func didSelectButton(with calcButton: CalculatorButton) {
        
        switch calcButton {
            case .allClear: self.optionAllClear()
            case .plusMinus: self.optionPlusOrMinus()
            case .percentage: self.optionPercentage()
            case .divide: self.optionOperation(with: .divide)
            case .multiply: self.optionOperation(with: .multiply)
            case .substract: self.optionOperation(with: .substract)
            case .add: self.optionOperation(with: .add)
            case .equals: self.optionEqualsButton()
            case .number(let number): self.optionNumber(with: number)
            case .decimal: self.optionDecimal()
        }
        self.updateViews?()
    }
    
    private func optionAllClear() {
        self.calcHeaderLabel = "0"
        self.currentNumber = .firstNumber
        self.firstNumber = nil
        self.secondNumber = nil
        self.operation = nil
        self.firstNumberIsDecimal = false
        self.secondNumberIsDecimal = false
        self.prevNumber = nil
        self.prevOperation = nil
    }
}

// MARK: - Selecting Numbers
extension CalcControllerViewModel {
    
    private func optionNumber(with number: Int) {
        if self.currentNumber == .firstNumber {
            if var firstNumber = self.firstNumber {
                firstNumber.append(number.description)
                self.firstNumber = firstNumber
                self.prevNumber = firstNumber
            } else {
                self.firstNumber = number.description
                self.prevNumber = number.description
            }
        } else {
            if var secondNumber = self.secondNumber {
                secondNumber.append(number.description)
                self.secondNumber = secondNumber
                self.prevNumber = secondNumber
            } else {
                self.secondNumber = number.description
                self.prevNumber = number.description
            }
        }
    }
}

// MARK: - Equals & Arithmetic Operations
extension CalcControllerViewModel {
    
    private func optionEqualsButton() {
        if let operation = self.operation,
           let firstNumber = self.firstNumber?.toDouble,
           let secondNumber = self.secondNumber?.toDouble {
                // Equals is pessed normally after firstNumber, then an operation, then a secondNumber
                let result = self.getOperationResult(operation, firstNumber, secondNumber)
                let resultString = self.eitherNumberIsDecimal ? result.description : result.toInt?.description
                
                self.secondNumber = nil
                self.prevOperation = operation
                self.operation = nil
                self.firstNumber = resultString
                self.currentNumber = .firstNumber
            }
            else if let prevOperation =
                    self.prevOperation,
                    let firstNumber = self.firstNumber?.toDouble,
                    let prevNumber = self.prevNumber?.toDouble {
                        // This will update the calculated based on previously selected number and arithmatic operation
                        let result = self.getOperationResult(prevOperation, firstNumber, prevNumber)
                        let resultString = self.eitherNumberIsDecimal ? result.description : result.toInt?.description
            self.firstNumber = resultString
        }
    }
    
    private func optionOperation(with operation: CalculatorOperation) {
        if self.currentNumber == .firstNumber {
            self.operation = operation
            self.currentNumber = .secondNumber
            
        } else if self.currentNumber == .secondNumber {
            if let prevOperation = self.operation,
               let firstNumber = self.firstNumber?.toDouble,
               let secondNumber = self.secondNumber?.toDouble {
                    // Do Previous Operation first
                    let result = self.getOperationResult(prevOperation, firstNumber, secondNumber)
                    let resultString = self.eitherNumberIsDecimal ? result.description : result.toInt?.description
                    
                    self.secondNumber = nil
                    self.firstNumber = resultString
                    self.currentNumber = .secondNumber
                    self.operation = operation
                } else {
                    // Else switch operation
                    self.operation = operation
                }
        }
    }
    
    // MARK: - Helper
    private func getOperationResult(_ operation: CalculatorOperation, _ firstNumber: Double?, _ secondNumber: Double?) -> Double {
        guard let firstNumber = firstNumber, let secondNumber = secondNumber else { return 0 }

        switch operation {
            case .divide:
                return (firstNumber / secondNumber)
            case .multiply:
                return (firstNumber * secondNumber)
            case .substract:
                return (firstNumber - secondNumber)
            case .add:
                return (firstNumber + secondNumber)
        }
    }
}

// MARK: - Action Buttons
extension CalcControllerViewModel {
    
    private func optionPlusOrMinus() {
        if self.currentNumber == .firstNumber, var number = self.firstNumber {
            if number.contains("-") {
                number.removeFirst()
            } else {
                number.insert("-", at: number.startIndex)
            }
            self.firstNumber = number
            self.prevNumber = number
            
        } else if self.currentNumber == .secondNumber, var number = self.secondNumber {
            if number.contains("-") {
                number.removeFirst()
            } else {
                number.insert("-", at: number.startIndex)
            }
            self.secondNumber = number
            self.prevNumber = number
        }
    }
    
    private func optionPercentage() {
        if self.currentNumber == .firstNumber,
            var number = self.firstNumber?.toDouble {
                number /= 100
            
            if number.isInteger {
                self.firstNumber = number.toInt?.description
            } else {
                self.firstNumber = number.description
                self.firstNumberIsDecimal = true
            }
            
        }
        else if self.currentNumber == .secondNumber,
                    var number = self.secondNumber?.toDouble {
                        number /= 100
            
            if number.isInteger {
                self.secondNumber = number.toInt?.description
            } else {
                self.secondNumber = number.description
                self.secondNumberIsDecimal = true
            }
        }
    }
    
    private func optionDecimal() {
        if self.currentNumber == .firstNumber {
            self.firstNumberIsDecimal = true
            if let firstNumber = self.firstNumber, !firstNumber.contains(".") {
                self.firstNumber = firstNumber.appending(".")
            } else if self.firstNumber == nil {
                self.firstNumber = "0."
            }
            
        } else if self.currentNumber == .secondNumber {
            self.secondNumberIsDecimal = true
            if let secondNumber = self.secondNumber, !secondNumber.contains(".") {
                self.secondNumber = secondNumber.appending(".")
            } else if self.secondNumber == nil {
                self.secondNumber = "0."
            }
        }
    }
}
