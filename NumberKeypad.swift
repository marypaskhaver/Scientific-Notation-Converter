//
//  NumberKeypad.swift
//  Scientific Notation Converter
//
//  Created by Mary Paskhaver on 12/29/19.
//  Copyright © 2019 Nostaw. All rights reserved.
//

import UIKit

class NumberKeypadWithMinus: UIView {
    weak var target: UIKeyInput?

    var numericButtons: [DigitButton] = (0...9).map {
        let button = DigitButton(type: .system)
        button.digit = $0
        button.setTitle("\($0)", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        button.setTitleColor(.black, for: .normal)
        
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor(red: 202/255, green: 212/255, blue: 210/255, alpha: 1.0).cgColor
        
        button.layer.backgroundColor = UIColor.white.cgColor

        button.accessibilityTraits = [.keyboardKey]
        button.addTarget(self, action: #selector(didTapDigitButton(_:)), for: .touchUpInside)
        return button
    }
    
    var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("⌫", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        button.setTitleColor(.black, for: .normal)

        button.layer.borderColor = UIColor.darkGray.cgColor
        
        button.accessibilityTraits = [.keyboardKey]
        button.accessibilityLabel = "Delete"
        button.addTarget(self, action: #selector(didTapDeleteButton(_:)), for: .touchUpInside)
        return button
    }()

    var minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(".", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        button.setTitleColor(.black, for: .normal)
       
        button.layer.borderColor = UIColor.darkGray.cgColor
        
        button.accessibilityTraits = [.keyboardKey]
        button.accessibilityLabel = "Decimal"
        button.addTarget(self, action: #selector(didTapDecimalButton(_:)), for: .touchUpInside)
        return button
    }()

    init(target: UIKeyInput) {
        self.target = target
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Actions

extension NumberKeypadWithMinus {
    @objc func didTapDigitButton(_ sender: DigitButton) {
        target?.insertText("\(sender.digit)")
    }
    
    @objc func didTapDeleteButton(_ sender: DigitButton) {
        target?.deleteBackward()
    }
}

// MARK: - Private initial configuration methods

private extension NumberKeypadWithMinus {
    func configure() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addButtons()
    }

    func addButtons() {
        let stackView = createStackView(axis: .vertical)
        stackView.frame = bounds
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(stackView)

        for row in 0 ..< 3 {
            let subStackView = createStackView(axis: .horizontal)
            stackView.addArrangedSubview(subStackView)

            for column in 0 ..< 3 {
                subStackView.addArrangedSubview(numericButtons[row * 3 + column + 1])
            }
        }

        let subStackView = createStackView(axis: .horizontal)
        stackView.addArrangedSubview(subStackView)
        
        subStackView.addArrangedSubview(numericButtons[0])
        subStackView.addArrangedSubview(deleteButton)
        
        let nonClickable = createStackView(axis: .horizontal)
        stackView.addArrangedSubview(nonClickable)
        
        let blank = UIView()
        nonClickable.addArrangedSubview(blank)

    }

    func createStackView(axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }
}

