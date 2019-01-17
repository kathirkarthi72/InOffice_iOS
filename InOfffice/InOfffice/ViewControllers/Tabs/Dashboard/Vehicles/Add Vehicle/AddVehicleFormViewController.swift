//
//  AddVehicleFormViewController.swift
//  InOfffice
//
//  Created by ktrkathir on 04/01/19.
//  Copyright © 2019 ktrkathir. All rights reserved.
//

import UIKit

class AddVehicleFormViewController: UITableViewController {

    @IBOutlet var viewModel: AddVehicleViewModel!
    
    @IBOutlet weak var bikeButton: UIButton!
    @IBOutlet weak var carButton: UIButton!
    
    
    @IBOutlet weak var plateNoPrefix: UITextField!
    @IBOutlet weak var plateNoSuffix: UITextField!
    
    @IBOutlet weak var bestMileageField: UITextField!
    
    @IBOutlet weak var initialKmField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        plateNoPrefix.becomeFirstResponder()
    }

    
    /// Bike button clicked
    ///
    /// - Parameter sender: sender button
    @IBAction func bikeButtonClicked(_ sender: Any) {
        carButton.isSelected = false
        bikeButton.isSelected = true
    }
    
    
    /// Car button clicked
    ///
    /// - Parameter sender: sender button
    @IBAction func carButtonClicked(_ sender: Any) {
        carButton.isSelected = true
        bikeButton.isSelected = false
    }
    
    /// Save bar button items
    ///
    /// - Parameter sender: sender button
    @IBAction func saveBarButtonItemClickedAction(_ sender: Any) {
        
        guard let prefix = plateNoPrefix.text, let suffix = plateNoSuffix.text, !prefix.isEmpty, !suffix.isEmpty else {
            plateNoPrefix.shake()
            plateNoSuffix.shake()
            return
        }
        
        guard let best = bestMileageField.text, !best.isEmpty else {
            bestMileageField.shake()
            return
        }
        
        guard let inital = initialKmField.text, !inital.isEmpty else {
            initialKmField.shake()
            return
        }

        VehicleManager.current.insert(vehicle: carButton.isSelected ? "Car" : "Bike",
                                      plate: prefix + " " + suffix,
                                      initialkm: Double(inital) ?? 0.0,
                                      bestMileage: Double(best) ?? 0.0) {
                                        
                                        self.navigationController?.popViewController(animated: true)
        }
       
    }
    
    // MARK: - Table view data source
    
 /*   override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
    
 /*   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
