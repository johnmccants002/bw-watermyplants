//
//  EditViewController.swift
//  WaterMyPlants
//
//  Created by John McCants on 2/25/21.
//

import UIKit
import CoreData

class EditViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var speciesTextField: UITextField!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var frequencySegControl: UISegmentedControl!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    var newPlantImage: UIImage?
    var plant: Plant?
    var object: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        guard let plant = plant else { return }
        speciesTextField.text = plant.species
        nicknameTextField.text = plant.nickname
        
        guard let plantImage = plant.image else { return }
        plantImageView.image = UIImage(data: plantImage)
    }
    @IBAction func editPhotoButtonTapped(_ sender: UIButton) {
        cameraButtonPressed()
    }
    
    
    @IBAction func updateButtonTapped(_ sender: UIBarButtonItem) {
        guard let plant = plant else {return}
        guard let speciesText = speciesTextField.text, let nicknameText = nicknameTextField.text else { return }
        if let newPlantImage = newPlantImage {
            CoreDataStack.shared.updatePlant(id: plant.id, frequency: segControlString(), image: newPlantImage.pngData(), nickname: nicknameText, species: speciesText, timestamp: Date(), plant: plant)
            segueAndUpdate()
        } else {
            CoreDataStack.shared.updatePlant(id: plant.id, frequency: segControlString(), image: nil, nickname: nicknameText, species: speciesText, timestamp: Date(), plant: plant)
            segueAndUpdate()
        }
    }
    func segControlString() -> String {
        guard let title = self.frequencySegControl.titleForSegment(at: self.frequencySegControl.selectedSegmentIndex) else {return "Often"}
        print(title)
        return title
    }
    
    func segueAndUpdate() {
        self.navigationController?.popToRootViewController(animated: true)
        NotificationCenter.default.post(name: .plantUpdated, object: nil)
    }

}

extension EditViewController: UIImagePickerControllerDelegate {
    
    @objc func cameraButtonPressed() {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
    picker.sourceType = .photoLibrary
    present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    guard let userPickedImage = info[.editedImage] as? UIImage else { return }
    plantImageView.image = userPickedImage
    self.newPlantImage = userPickedImage
    picker.dismiss(animated: true)
    }
    
}
