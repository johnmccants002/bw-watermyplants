//
//  SettingsViewController.swift
//  WaterMyPlants
//
//  Created by John McCants on 2/24/21.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingsViewController: UIViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    var user: User?
    let ref = PlantFirebaseController.shared.ref
    let uid = UserDefaults.standard.value(forKey: "uid")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameTextField.delegate = self
        updateViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
  func updateViews() {
    self.activityIndicator.isHidden = true
    self.saveButton.isEnabled = false
    self.usernameTextField.text = PlantFirebaseController.shared.username
  }
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            UserDefaults.standard.synchronize()

        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true) {
            let firebaseAuth = Auth.auth()
            do {
            try firebaseAuth.signOut()
            } catch let error as NSError {
                print("Error signing out: %@", error)
            }
    }
    }
    
    @IBAction func saveChangesButtonTapped(_ sender: Any) {
        guard let usernameText = usernameTextField.text, usernameText != "" else {
            return
        }
        

        let firebaseOp = BlockOperation {
            PlantFirebaseController.shared.updateUsername(username: usernameText)
            print("Successfully Completed 1")
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                let alert = UIAlertController(title: "Success", message: "Updated Profile", preferredStyle: .alert)
                            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                                 print("Successfully Completed 3")
                            
            }
            alert.addAction(action)
            self.present(alert, animated: true)
        }
        }

        let completeOp = BlockOperation {
            print("Successfully Completed 2")
        }
            OperationQueue.main.addOperations([firebaseOp, completeOp], waitUntilFinished: false)
        print("successfully saved changes")
    }
    

}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let textFieldText = textField.text else {return}
        if textFieldText.count > 3 {
            self.saveButton.isEnabled = true
        } else {
            self.saveButton.isEnabled = false
        }
    }
}
