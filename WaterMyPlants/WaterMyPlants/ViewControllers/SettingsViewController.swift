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

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
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

}
