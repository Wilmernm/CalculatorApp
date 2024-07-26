//
//  ButtonCell.swift
//  Calculator
//
//  Created by Wilmer Núñez on 20/03/24.
//

import UIKit

class ButtonCell: UICollectionViewCell {
    static let identifier = "ButtonCell"
    
    //MARK: - Variables
    private(set) var calculatorButton: CalculatorButton!
    
    //MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 34, weight: .regular)
        label.text = "Error"
        return label
    }()
    
    //MARK: - Configure
    public func configure(with calculatorButton: CalculatorButton) {
        self.calculatorButton = calculatorButton
        
        self.titleLabel.text = calculatorButton.title
        self.backgroundColor = calculatorButton.color
        
        switch calculatorButton {
        case .allClear, .plusMinus, .percentage:
            self.titleLabel.textColor = .white
        default:
            self.titleLabel.textColor = .white
        }
        
        self.setupUI()
    }
    
    public func setOperationSelected() {
        self.titleLabel.textColor = .orange
        self.backgroundColor = .white
    }
    
    //MARK: - UI Setup
    private func setupUI(){
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        switch self.calculatorButton {
            case let .number(int) where int == 0:
                self.layer.cornerRadius = 32
            
                let extraSpace = self.frame.width-self.frame.height
            
            NSLayoutConstraint.activate([
                self.titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor),
                self.titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
                self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -extraSpace),
            ])
            
            default:
                self.layer.cornerRadius = self.frame.size.width/2
        
            NSLayoutConstraint.activate([
                self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                self.titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor),
                self.titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            ])
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.removeFromSuperview()
    }
}
