//
//  AddPlantViewController.swift
//  WaterMyPlants
//
//  Created by John McCants on 2/24/21.
//

import UIKit

class AddPlantViewController: UIViewController, UINavigationControllerDelegate {
    
    var user: User?
    var plantImage: UIImage?

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var frequencySegControl: UISegmentedControl!
    @IBOutlet weak var plantNicknameTextField: UITextField!
    @IBOutlet weak var speciesTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addPhotoTapped(_ sender: UIButton) {
        cameraButtonPressed()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let plantNickname = plantNicknameTextField.text, !plantNickname.isEmpty else {
            return
        }
        
        guard let plantSpecies = speciesTextField.text, !plantSpecies.isEmpty else {return}
        
        guard let plantImage = plantImage else {
            Plant(frequency: segControlString(), id: UserDefaults.standard.string(forKey: "uid"), image: nil, nickname: plantNickname, species: plantSpecies, timestamp: Date())
            do {
                try CoreDataStack.shared.managedObjectContext.save()
            } catch {
                print("Error saving the object")
            }

        self.navigationController?.popViewController(animated: true)
            return

        }
        Plant(frequency: segControlString(), id: UserDefaults.standard.string(forKey: "uid"), image: plantImage.pngData(), nickname: plantNickname, species: plantSpecies, timestamp: Date())
        
        do {
            try CoreDataStack.shared.managedObjectContext.save()
        } catch {
            print("Error saving object: \(error)")
        }

        
        self.navigationController?.popViewController(animated: true)
        
        
    }
        
    func segControlString() -> String {
        guard let title = self.frequencySegControl.titleForSegment(at: self.frequencySegControl.selectedSegmentIndex) else {return "Often"}
        print(title)
        return title
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

extension AddPlantViewController: UIImagePickerControllerDelegate {
    
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
    self.plantImage = userPickedImage
    picker.dismiss(animated: true)
    }
    
}
                                
