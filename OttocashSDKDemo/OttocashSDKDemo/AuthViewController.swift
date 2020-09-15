//
//  AuthViewController.swift
//  ottocashsdktest
//
//  Created by Clapping Ape on 08/09/19.
//  Copyright © 2019 Clapping Ape. All rights reserved.
//

import UIKit

protocol AuthViewControllerDelegate {
    func didLogin(phone: String, hostName: String, clientID: String, clientSecret: String)
}

class AuthViewController: BaseViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var hostNameTextField: UITextField!
    @IBOutlet weak var clientIDTextField: UITextField!
    @IBOutlet weak var clientSecretTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerKeyboardNotification(scrollView: self.scrollView)
        hostNameTextField.text = "OttoCashSDK-IOS"
        clientIDTextField.text = "OoNMJ1Anq_2L9cqigWo_kCgEVLgHriwx5cKeYqZ84wQ"
        clientSecretTextField.text = "Q8A6fPRhUgvxGI6RQvsGhccaGOoZ0Kbodu1idcoKtIk"
    }
    

    @IBAction func loginAction(_ sender: Any) {
        self.view.endEditing(true)
        if !numberValidation(phoneNumberTextField.text) || phoneNumberTextField.text!.count < 9 || phoneNumberTextField.text == "" {
            basicAlertView(title: "", message: "Nomer Handphone Harus Angka dan Minimal 9 digit")
        } else {
            self.delegate?.didLogin(phone: self.phoneNumberTextField.text ?? "",
            hostName: self.hostNameTextField.text ?? "",
            clientID: self.clientIDTextField.text ?? "",
            clientSecret: self.clientSecretTextField.text ?? "")

        }
    }
    
    private func numberValidation(_ number: String?) -> Bool {
        guard let number = number else {return false}
        let letters = CharacterSet.letters
        let numbers = CharacterSet.decimalDigits
        let lettersTest = number.rangeOfCharacter(from: letters)
        let numbersTest = number.rangeOfCharacter(from: numbers)
        if lettersTest == nil && numbersTest != nil {
            return true
        } else {
            return false
        }
    }
    
}
