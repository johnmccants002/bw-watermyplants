//
//  PlantDetailViewController.swift
//  WaterMyPlants
//
//  Created by John McCants on 2/24/21.
//

import UIKit
import CoreData


class PlantDetailViewController: UIViewController {
    
    @IBOutlet weak var plantButton: UIButton!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var h20Label: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    var plant : Plant?
    var object : NSManagedObject?
    var editMode : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

    }
    
    func notificationSetUp() {
        guard let plant = plant else { return }
        let content = UNMutableNotificationContent()
        content.title = "Water \(String(describing: plant.nickname))"
        content.body = "You got this"
    }
    
    func updateViews() {
        guard let plant = plant else { return }
        
        self.h20Label.text = plant.frequency
        self.speciesLabel.text = plant.species
        self.nicknameLabel.text = plant.nickname
        guard let image = plant.image else { return }
        self.plantImageView.image = UIImage(data: image)
        
    }
    
    func deletePlant() {
        guard let object = self.object else { return }
        CoreDataStack.shared.delete(object: object)
    }
    
    @IBAction func plantButtonTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == "Delete Plant" {
            deletePlant()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
//        if editMode == false {
//            editMode.toggle()
//            plantButton.setTitle("Delete Plant", for: .normal)
//            sender.title = "Done" }
//        else if editMode == true {
//            editMode.toggle()
//            plantButton.setTitle("Water Plant", for: .normal)
//            sender.title = "Edit"
//        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditPlant" {
            guard let destination = segue.destination as? EditViewController else {return}
            destination.plant = self.plant
            destination.object = self.object
        }
    }

}
