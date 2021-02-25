//
//  AddPlantViewController.swift
//  WaterMyPlants
//
//  Created by John McCants on 2/24/21.
//

import UIKit

class AddPlantViewController: UIViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var frequencySegControl: UISegmentedControl!
    @IBOutlet weak var plantNicknameTextField: UITextField!
    @IBOutlet weak var speciesTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPhotoTapped(_ sender: UIButton) {
    }
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddPlantViewController: UITextFieldDelegate {

}
