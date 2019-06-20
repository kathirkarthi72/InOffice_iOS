//
//  AddMileageTableViewController.swift
//  InOfffice
//
//  Created by ktrkathir on 07/01/19.
//  Copyright © 2019 ktrkathir. All rights reserved.
//

import UIKit

class AddMileageTableViewController: UITableViewController {
    
    @IBOutlet var viewModel: AddMileageViewModel!
    
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    
    var fuelInfo: FuelDetail?
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var filledLitreTextField: UITextField!
    @IBOutlet weak var initialKmTextField: UITextField!
    @IBOutlet weak var finalKmTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var plateNumber:String = ""
    
    var showDatePicker: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        if let fuel = fuelInfo {
            datePicker.date = fuel.date!
            
            filledLitreTextField.text = String(fuel.litre)
            initialKmTextField.text = String(fuel.initialKm)
            finalKmTextField.text = String(fuel.currentKm)
            
            finalKmTextField.becomeFirstResponder()
            
            saveBarButtonItem.title = "Update"
            
        }
            let date = datePicker.date.convert()
            dateButton.setTitle(date, for: .normal)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func pickerValueChanged(_ sender: Any) {
        let date = datePicker.date.convert()
        dateButton.setTitle(date, for: .normal)
    }
    
    @IBAction func dateButtonClickedAction(_ sender: Any) {
        showDatePicker = !showDatePicker
        if showDatePicker {
            tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .bottom)
        } else {
            tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .top)
        }
    }
    
    @IBAction func saveBarButtonItemClickedAction(_ sender: Any) {
        let date = datePicker.date
        
        guard let litres = filledLitreTextField.text, !litres.isEmpty else {
            filledLitreTextField.shake()
            return
        }
        
        guard let inital = initialKmTextField.text, !inital.isEmpty  else {
            initialKmTextField.shake()
            return
        }
        
        let litre = Double(litres) ?? 0.0
        let initalKm = Double(inital) ?? 0.0
        let finalKm = Double(finalKmTextField.text ?? "0") ?? 0.0
        
        var result: Double = 0.0
        
        if finalKm != 0.0 {
            
            if finalKm <= initalKm {
                finalKmTextField.shake()
                return
            }
            
            result = finalKm - initalKm
        }

        if let fuel = fuelInfo {
            // Update record
            
            fuel.date = date
            fuel.litre = litre
            fuel.initialKm = initalKm
            fuel.currentKm = finalKm
            fuel.avgKm = result
            
            fuel.avgKm = result / litre
            
            VehicleManager.current.saveFuelInfo {
                self.navigationController?.popViewController(animated: true)
            }
            
        } else {
            // Save new record to DB
            
            VehicleManager.current.insertFuel(filled: Double(litres) ?? 0.0,
                                              plate: plateNumber,
                                              date: date,
                                              intialkm: initalKm,
                                              finalKm: finalKm,
                                              mileage: result) {
                                                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Plate number - " + plateNumber
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 1 {
            if showDatePicker {
                return 220
            } else {
                return 0
            }
        }
        return 44
    }
    
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
    }
*/
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

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
