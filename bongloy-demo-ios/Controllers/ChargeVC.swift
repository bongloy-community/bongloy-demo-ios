//
//  ChargeVC.swift
//  bongloy-demo-ios
//
//  Created by khomsovon on 9/3/18.
//  Copyright © 2018 bongloy. All rights reserved.
//

import UIKit
import Stripe
import CreditCardForm
import SCLAlertView

extension STPAPIClient {
    var apiURL: URL {
        get{
            return self.apiURL
        }
        set(newValue){
            self.apiURL = newValue
        }
    }
}

class ChargeVC: UIViewController {
    
    @IBOutlet weak var BuyButton: HighlightingButton!
    @IBOutlet weak var amount: TextField!
    @IBOutlet weak var cardHolder: TextField!
    @IBOutlet weak var creditCardView: CreditCardFormView!
    
    let theme = ThemeVC().theme.stpTheme
    let backendBaseUrl = BACKEND_BASE_URL
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    let paymentCardTextField = STPPaymentCardTextField()
    var window: UIWindow?
    
    var paymentInProgress: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                if self.paymentInProgress {
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.alpha = 1
                    self.BuyButton.alpha = 0
                }
                else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.alpha = 0
                    self.BuyButton.alpha = 1
                }
            }, completion: nil)
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        createTextField()
        //createDoneButton()
        self.activityIndicator.color = #colorLiteral(red: 0.5859152079, green: 0.7754819989, blue: 0.3899528384, alpha: 1)
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.alpha = 0
        cardHolder.addTarget(self, action: #selector(didChangeCardHolder), for: .editingChanged)
        ChargeService.instance.baseURLString = self.backendBaseUrl
        BuyButton.isEnabled = false
        cardHolder.delegate = self
        cardHolder.returnKeyType = .next
        amount.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.activityIndicator.center = self.BuyButton.center
    }
    
    @IBAction func pressBuy(_ sender: Any) {
        self.paymentInProgress = true
        
        let cardParam  = STPCardParams()
        cardParam.number = paymentCardTextField.cardNumber
        cardParam.expMonth = paymentCardTextField.expirationMonth
        cardParam.expYear = paymentCardTextField.expirationYear
        cardParam.cvc = paymentCardTextField.cvc
        BongloyAPIClient.sharedBongloy().createToken(withCard: cardParam){ (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else { return }
            guard let amountCharge = self.amount.text , self.amount.text != "" else { return }
            ChargeService.instance.createCharge(
                token: token,
                amount: Int(amountCharge)!,
                completion: {
                    (result) in
                    if let error = result {
                        self.paymentInProgress = false
                        SCLAlertView().showError("Error", subTitle: error.localizedDescription)
                    }else{
                        self.paymentInProgress = false
                        SCLAlertView().showSuccess("Success", subTitle: "Payment successful!")
                    }
            })
        }
    }
}

extension ChargeVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        view.endEditing(true)
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
}

extension ChargeVC: STPPaymentCardTextFieldDelegate {
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: textField.expirationYear, expirationMonth: textField.expirationMonth, cvc: textField.cvc)
        BuyButton.isEnabled = textField.isValid
    }
    
}

extension ChargeVC {
    func createTextField() {
        
        paymentCardTextField.frame = CGRect(x: 15, y: 199, width: self.view.frame.size.width - 30, height: 44)
        paymentCardTextField.delegate = self
        paymentCardTextField.translatesAutoresizingMaskIntoConstraints = false
        paymentCardTextField.borderWidth = 0
        
        view.backgroundColor = theme.primaryBackgroundColor
        paymentCardTextField.backgroundColor = theme.secondaryBackgroundColor
        paymentCardTextField.textColor = theme.primaryForegroundColor
        paymentCardTextField.placeholderColor = theme.secondaryForegroundColor
        paymentCardTextField.textErrorColor = theme.errorColor
        paymentCardTextField.layer.cornerRadius = 0
        
        view.addSubview(paymentCardTextField)
        
        NSLayoutConstraint.activate([
            paymentCardTextField.topAnchor.constraint(equalTo: creditCardView.bottomAnchor, constant: 20),
            paymentCardTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paymentCardTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-0),
            paymentCardTextField.heightAnchor.constraint(equalToConstant: 44)
            ])
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingExpiration(expirationYear: textField.expirationYear)
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingCVC()
    }
    
    @objc func didChangeCardHolder(textField: UITextField) {
        creditCardView.cardHolderString = textField.text!
    }
    
    func createDoneButton(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        let flexiblespace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: #selector(self.doneClicked))
        toolbar.setItems([flexiblespace, doneButton], animated: false)
    
        amount.inputAccessoryView = toolbar
    }
    
    @objc func doneClicked(){
        view.endEditing(true)
    }
}

