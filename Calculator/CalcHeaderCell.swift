//
//  CalcHeaderCell.swift
//  Calculator
//
//  Created by Wilmer Núñez on 20/03/24.
//
import UIKit

class CalcHeaderCell: UICollectionReusableView {
    
    static let identifier =  "CalcHeaderCell"
    
    //MARK: - UI Components
    private var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 64, weight: .regular)
        label.text = "Title"
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(currentCalcText: String) {
        self.label.text = currentCalcText
    }
    
    //MARK: - UI Setup
    private func setupUI() {
        self.backgroundColor = .black
        self.addSubview(label)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.label.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            self.label.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            self.label.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
        ])
    }
}
