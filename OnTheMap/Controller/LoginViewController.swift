//
//  ViewController.swift
//  OnTheMap
//
//  Created by Rahaf Naif on 13/10/1441 AH.
//  Copyright © 1441 Rahaf Naif. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var singupButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.delegate = self
        password.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        email.text = ""
        password.text = ""
        password.isSecureTextEntry = true
        
   
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(true)
        guard email.text != "", password.text != "" else {
            showLoginFailure(message: "you should fill all textFields!")
            setLoggingIn(false)
            return
        }
        //UdacityAPI.postSession(username: email.text!, password: password.text! ,completionHandler: handleLoginResponse(success:error:))
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!, completion: { [self]result,error in
            
            guard error != nil  else {
                handleLoginResponse(success: true, error:error)
                return
            }
            handleLoginResponse(success: false, error:error)
            
        })
    }
    
    func handleLoginResponse(success: Bool, error: Error?){
        setLoggingIn(false)
        if success{
            performSegue(withIdentifier: "completeLogin", sender: nil)
        }else {
            showLoginFailure(message: "Invalid email or password")
        }
        
    }
    
    @IBAction func singUpTapped(_ sender: Any) {
//        let url = URL(string: "https://auth.udacity.com/sign-up")
//        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        performSegue(withIdentifier: "signUp", sender: nil)
    }
    
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        email.isEnabled = !loggingIn
        password.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        singupButton.isEnabled = !loggingIn
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    


}




