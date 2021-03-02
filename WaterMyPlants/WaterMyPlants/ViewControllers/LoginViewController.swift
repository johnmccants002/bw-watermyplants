//
//  LoginViewController.swift
//  WaterMyPlants
//
//  Created by John McCants on 2/24/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    

    @IBOutlet weak var loginSignUpButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var loginSegmentedControl: UISegmentedControl!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    var user : User?
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func loginSignUpButtonTapped(_ sender: UIButton) {
        guard let emailText = emailTextField.text, !emailText.isEmpty else {
            presentAlert(missingField: "Email")
            return }
        guard let passwordText = passwordTextField.text, !passwordText.isEmpty else {
            presentAlert(missingField: "Password")
            return }
        if sender.currentTitle == "Sign Up" {
            guard let usernameText = self.usernameTextField.text, !usernameText.isEmpty else {
                self.presentAlert(missingField: "Username")
                return }
            
            Auth.auth().createUser(withEmail: emailText, password: passwordText) { (authDataResult, error) in
                
                if error != nil {
                    self.presentAlert(missingField: "Unable to create a user")
                }
                if let authData = authDataResult, let authEmail = authData.user.email {
                    print(authEmail)
                    var dict: [String: Any] = [
                        "uid": authData.user.uid,
                        "username": usernameText,
                        "email": authEmail                        ]

                    Database.database().reference().child("users").child(authData.user.uid).updateChildValues(dict, withCompletionBlock: { (error, _) in
                        if error == nil {
                            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let centerVC = mainStoryBoard.instantiateViewController(withIdentifier: "PlantTableViewController") as! PlantTableViewController
                            // setting the login status to true
                            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                            UserDefaults.standard.set(authData.user.uid, forKey: "uid")
                            UserDefaults.standard.synchronize()
                            self.user = User(username: usernameText, email: authEmail, uid: authData.user.uid)
                            let nav = UINavigationController(rootViewController: centerVC)
                            nav.modalPresentationStyle = .fullScreen
                            self.present(nav, animated: true, completion: nil)
                            
                            print("Done")
                        }
                })
        }
        }
        } else if sender.currentTitle == "Login" {
            Auth.auth().signIn(withEmail: emailText, password: passwordText) { (authData, error) in
                if error != nil {
                    self.presentAlert(missingField: "Error Signing In")
                }
                guard let authData = authData else { return }
                let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let centerVC = mainStoryBoard.instantiateViewController(withIdentifier: "PlantTableViewController") as! PlantTableViewController
                // setting the login status to true
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.set(authData.user.uid, forKey: "uid")
                UserDefaults.standard.synchronize()
                self.user = User(username: "", email: emailText, uid: authData.user.uid)
                let nav = UINavigationController(rootViewController: centerVC)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
                
            }
            }
    }
    
    @IBAction func loginSegmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            self.usernameLabel.isHidden = false
            self.usernameTextField.isHidden = false
            self.loginSignUpButton.setTitle("Sign Up", for: .normal)
        } else if sender.selectedSegmentIndex == 0 {
            self.usernameLabel.isHidden.toggle()
            self.usernameTextField.isHidden.toggle()
            self.loginSignUpButton.setTitle("Login", for: .normal)
        }
    }
    
    
    func updateViews() {
        if loginSegmentedControl.titleForSegment(at: 0) == "Login" {
            self.usernameLabel.isHidden = true
            self.usernameTextField.isHidden = true
            self.usernameTextField.text = nil
        } else if loginSegmentedControl.titleForSegment(at: 1) == "Sign Up" {
            self.usernameTextField.isHidden = false
            self.usernameLabel.isHidden = false
        }
    }
    
    func presentAlert(missingField: String) {
        let alert = UIAlertController(title: "Error", message: "Please enter proper \(missingField)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignedIn" {
            guard let destination = segue.destination as? PlantTableViewController else {return}
            destination.user = self.user
        }
    }


}
