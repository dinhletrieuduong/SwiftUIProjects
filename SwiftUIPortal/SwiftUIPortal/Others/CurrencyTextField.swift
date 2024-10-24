//
//  CurrencyTextField.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 24/10/24.
//


import UIKit

class CurrencyTextField: UITextField {

    var passTextFieldText: ((String, Double?) -> Void)?

    var currency: Currency? {
        didSet {
            guard let currency = currency else { return }
            numberFormatter.currencyCode = currency.code
            numberFormatter.locale = Locale(identifier: currency.locale)
        }
    }

    //Used to send clean double value back
    private var amountAsDouble: Double?

    var startingValue: Double? {
        didSet {
            let nsNumber = NSNumber(value: startingValue ?? 0.0)
            self.text = numberFormatter.string(from: nsNumber)
        }
    }

    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        //locale and currencyCode set in currency property observer
        return formatter
    }()

    private var roundingPlaces: Int {
        return numberFormatter.maximumFractionDigits
    }

    private var isSymbolOnRight = false

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //If using in SBs
        setup()
    }

    private func setup() {
        self.textAlignment = .right
        self.keyboardType = .numberPad
        self.contentScaleFactor = 0.5
        delegate = self

        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    //AFTER entered string is registered in the textField
    @objc private func textFieldDidChange() {
        updateTextField()
    }

    //Placed in separate method so when the user selects an account with a different currency, it will immediately be reflected
    private func updateTextField() {
        var cleanedAmount = ""

        for character in self.text ?? "" {
            if character.isNumber {
                cleanedAmount.append(character)
            }
        }

        if isSymbolOnRight {
            cleanedAmount = String(cleanedAmount.dropLast())
        }

        //Format the number based on number of decimal digits
        if self.roundingPlaces > 0 {
            //ie. USD
            let amount = Double(cleanedAmount) ?? 0.0
            amountAsDouble = (amount / 100.0)
            let amountAsString = numberFormatter.string(from: NSNumber(value: amountAsDouble ?? 0.0)) ?? ""

            self.text = amountAsString
        } else {
            //ie. JPY
            let amountAsNumber = Double(cleanedAmount) ?? 0.0
            amountAsDouble = amountAsNumber
            self.text = numberFormatter.string(from: NSNumber(value: amountAsNumber)) ?? ""
        }

        passTextFieldText?(self.text!, amountAsDouble)
    }

    //Prevents the user from moving the cursor in the textField
    //Source: https://stackoverflow.com/questions/16419095/prevent-user-from-setting-cursor-position-on-uitextfield
    override func closestPosition(to point: CGPoint) -> UITextPosition? {
        let beginning = self.beginningOfDocument
        let end = self.position(from: beginning, offset: self.text?.count ?? 0)
        return end
    }
}


extension CurrencyTextField: UITextFieldDelegate {

    //BEFORE entered string is registered in the textField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let lastCharacterInTextField = (textField.text ?? "").last

        //Note - not the most straight forward implementation but this subclass supports both right and left currencies
        if string == "" && lastCharacterInTextField!.isNumber == false {
            //For hitting backspace and currency is on the right side
            isSymbolOnRight = true
        } else {
            isSymbolOnRight = false
        }

        return true
    }
}


struct Currency {
    let locale: String
    let amount: Double

    var code: String? {
        return formatter.currencyCode ?? "N/A"
    }

    var symbol: String? {
        return formatter.currencySymbol  ?? "N/A"
    }

    var format: String {
        return formatter.string(from: NSNumber(value: self.amount))!
    }

    var formatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: self.locale)
        numberFormatter.numberStyle = .currency

        return numberFormatter
    }

    //Used to populate the cells on the MainVC
    func retrieveDetailedInformation() -> [(description: String, value: String)] {
        let retrievedLocale = Locale(identifier: self.locale)

        let informationToReturn = [
            (description: "locale", value: self.locale),
            (description: "code", value: self.code ?? "N/A"),
            (description: "symbol", value: retrievedLocale.currencySymbol ?? "N/A"),
            (description: "groupingSep", value: retrievedLocale.groupingSeparator ?? "N/A"),
            (description: "decimalSeparator", value: retrievedLocale.decimalSeparator ?? "N/A")
        ]

        return informationToReturn
    }

    //MARK: Clean formatting from string
    //not used anymore but left for example
    //    static func cleanString(given formattedString: String) -> String {
    //        var cleanedAmount = ""
    //
    //        for character in formattedString {
    //            if character.isNumber {
    //                cleanedAmount.append(character)
    //            }
    //        }
    //
    //        return cleanedAmount
    //    }

    //MARK: Use when saving to a database which only requires numeric values
    static func formatCurrencyStringAsDouble(with localeString: String, for stringAmount: String) -> Double {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: localeString)
        numberFormatter.numberStyle = .currency

        return numberFormatter.number(from: stringAmount) as! Double
    }

    //MARK: Currency Input Formatting - called when the user enters an amount in the
    static func currencyInputFormatting(with localeString: String, for amount: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: localeString)
        numberFormatter.numberStyle = .currency

        let numberOfDecimalPlaces = numberFormatter.maximumFractionDigits

        //Clean the inputed string
        var cleanedAmount = ""

        for character in amount {
            if character.isNumber {
                cleanedAmount.append(character)
            }
        }

        //Format the number based on number of decimal digits
        if numberOfDecimalPlaces > 0 {
            //ie. USD
            let amountAsDouble = Double(cleanedAmount) ?? 0.0

            return numberFormatter.string(from: amountAsDouble / 100.0 as NSNumber) ?? ""
        } else {
            //ie. JPY
            let amountAsNumber = Double(cleanedAmount) as NSNumber?
            return numberFormatter.string(from: amountAsNumber ?? 0) ?? ""
        }
    }
}

struct Currencies {
    static func retrieveAllCurrencies() -> [Currency] {
        var currencies = [Currency]()
        for locale in Locale.availableIdentifiers {
            let loopLocale = Locale(identifier: locale)
            currencies.append(Currency(locale: loopLocale.identifier, amount: 1000.00))
        }

        return currencies.sorted(by: { $0.locale < $1.locale })
    }
}

extension String {
    func isLastCharANumber() -> Bool {
        let lastChar = self.last!

        if lastChar.isNumber {
            return true
        } else {
            return false
        }
    }
}

//var selectedCurrency: Currency? {
//    didSet {
//        exampleLbl.text = generateExampleFigures()
//        enterAmountTxt.text?.removeAll()
//        cleanAmtLbl.text = "0"
//        enterAmountTxt.currency = selectedCurrency
//        enterAmountTxt.becomeFirstResponder()
//
//        detailTableView.reloadData()
//    }
//}

//lazy var enterAmountTxt: CurrencyTextField = {
//    let textField = CurrencyTextField()
//    textField.frame = .zero  //will use auto-layout
//    textField.font = UIFont.systemFont(ofSize: 48, weight: .bold)
//    textField.textColor = .white
//    textField.placeholder = "0.00"
//
//    return textField
//}()
