//
//  PlantDetailViewController.swift
//  WaterMyPlants
//
//  Created by John McCants on 2/24/21.
//

import UIKit
import CoreData
import UserNotifications


class PlantDetailViewController: UIViewController {
    
    @IBOutlet weak var plantButton: UIButton!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var h20Label: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    var plant: Plant?
    var object: NSManagedObject?
    var localNotifications: LocalNotifications?
    
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
        guard let plant = plant, let frequency = plant.frequency, let species = plant.species, let nickname = plant.nickname else { return }
        
        self.h20Label.text = "Frequency: \(frequency)"
        self.speciesLabel.text = "Species: \(species)"
        self.nicknameLabel.text = "Nickname: \(nickname)"
        guard let image = plant.image else {
            self.plantImageView.image = UIImage(named: "plant")
            return }
        self.plantImageView.image = UIImage(data: image)
        
    }
    
    func deletePlant() {
        guard let object = self.object else { return }
        CoreDataStack.shared.delete(object: object)
    }
    
    @IBAction func plantButtonTapped(_ sender: UIButton) {
        guard let plant = plant, let navigationController = self.navigationController else { return }
        guard let localNotifications = localNotifications else { return }
        let alertController = localNotifications.waterPlantNotification(plant: plant, navigationController: navigationController)
        guard let alertControllerNotNil = alertController else { return }
        
        self.present(alertControllerNotNil, animated: true, completion: nil)
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {

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
