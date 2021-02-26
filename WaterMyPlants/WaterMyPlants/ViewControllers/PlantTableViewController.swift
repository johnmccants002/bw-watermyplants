//
//  PlantTableViewController.swift
//  WaterMyPlants
//
//  Created by John McCants on 2/24/21.
//

import UIKit
import CoreData

class PlantTableViewController: UITableViewController {

    let plantController = PlantController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Plant> = {
            
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let moc = CoreDataStack.shared.managedObjectContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
            return frc
        } catch {
            fatalError("Error Fetching: \(error)")
        }
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .plantUpdated, object: nil)
        updateViews()
    }
    
    func updateViews() {
        self.tableView.reloadData()
    }
    
    @objc func reload() {
        self.tableView.reloadData()
    }
    

    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "plantCell", for: indexPath)
        
        let plant = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = plant.nickname

        // Configure the cell...

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddPlant" {
            guard let destination = segue.destination as? AddPlantViewController else { return }
            destination.plantController = self.plantController
        } else if segue.identifier == "PlantDetail" {
            guard let destination = segue.destination as? PlantDetailViewController else { return }
            guard let selectedNumber = self.tableView.indexPathForSelectedRow else {return}
            let selectedPlant = self.fetchedResultsController.object(at: selectedNumber)
            destination.plant = selectedPlant
            destination.object = CoreDataStack.shared.managedObjectContext.object(with: selectedPlant.objectID)
            
        }
    }
    

}

extension PlantTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
        
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
        
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
            
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
        
    }
        
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
            
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
            self.tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .delete:
            guard let indexPath = indexPath else { return }
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}
