//
//  AddPlantViewController.swift
//  WaterMyPlants
//
//  Created by John McCants on 2/24/21.
//

import UIKit

class AddPlantViewController: UIViewController, UINavigationControllerDelegate {
    
    var plantController : PlantController?
    var plantImage : UIImage?

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var frequencySegControl: UISegmentedControl!
    @IBOutlet weak var plantNicknameTextField: UITextField!
    @IBOutlet weak var speciesTextField: UITextField!
    var id : Int = 1000
    override func viewDidLoad() {
        super.viewDidLoad()

        segControlString()
    }
    
    @IBAction func addPhotoTapped(_ sender: UIButton) {
        cameraButtonPressed()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let plantController = plantController else { return }
        guard let plantNickname = plantNicknameTextField.text, !plantNickname.isEmpty else {
            return
        }
        
        guard let plantSpecies = speciesTextField.text, !plantSpecies.isEmpty else {return}
        
        let plantID = id + plantController.plants.count
        
        guard let plantImage = plantImage else {
            Plant(frequency: segControlString(), id: plantID, image: nil, nickname: plantNickname, species: plantSpecies, timestamp: Date())
            do {
                try CoreDataStack.shared.managedObjectContext.save()
            } catch {
                print("Error saving the object")
            }

        self.navigationController?.popViewController(animated: true)
            return

        }
        Plant(frequency: segControlString(), id: plantID, image: plantImage.pngData(), nickname: plantNickname, species: plantSpecies, timestamp: Date())
        
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let userPickedImage = info[.editedImage] as? UIImage else { return }
    plantImageView.image = userPickedImage
    self.plantImage = userPickedImage
    picker.dismiss(animated: true)
    }
    
}
                                
