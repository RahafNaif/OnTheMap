//
//  SignupViewController.swift
//  OnTheMap
//
//  Created by Rahaf Naif on 26/03/1442 AH.
//  Copyright © 1442 Rahaf Naif. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController:UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username.delegate = self
        email.delegate = self
        password.delegate = self
        
//        if let hasSpecialCharacters =  "your string".range(of: ".*[^A-Za-z0-9].*", options: .regularExpression) != nil {}
//
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        username.text = ""
        email.text = ""
        password.text = ""
        password.isSecureTextEntry = true
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        setSigningIn(true)
        guard username.text != "" ,  email.text != "", password.text != "" else {
            showLoginFailure(message: "You should fill all textFields!")
            setSigningIn(false)
            return
        }
        
        if checkForIllegalCharacters(string: username.text!)==true {
            showLoginFailure(message: "Use letters only in your name!")
            setSigningIn(false)
            return
        }
        
        if isValidEmail(email.text!)==false{
            showLoginFailure(message: "invalid email format!")
            setSigningIn(false)
            return
        }
        
        
        
        let pass = password.text
        let valid = self.isValidPassword(pass: pass!)
        
    if valid {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (result, error) in
            
            guard error != nil  else {
                self.handleSignUpResponse(success: true, error:error)
                return
            }
            self.handleSignUpResponse(success: false, error:error)
        }
    }else{
        self.showLoginFailure(message: "You should enter stronger password!")
        setSigningIn(false)
    }
        
    }
    
    func handleSignUpResponse(success: Bool, error: Error?){
        setSigningIn(false)
        if success{
            performSegue(withIdentifier: "completeLogin", sender: nil)
        }else {
            showLoginFailure(message: "There is an Problem in your email or password")
        }
        
    }
    
    public func isValidPassword(pass:String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: pass)
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "SignUp Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func setSigningIn(_ SigningIn: Bool) {
        if SigningIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        email.isEnabled = !SigningIn
        password.isEnabled = !SigningIn
        signIn.isEnabled = !SigningIn
    }
    
    func checkForIllegalCharacters(string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "\\/:*?\"<>|@#$1234567890;[]{}!")
        .union(.newlines)
        .union(.illegalCharacters)
        .union(.controlCharacters)

        if string.rangeOfCharacter(from: invalidCharacters) != nil {
            return true
        } else {
            return false
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}
