//
//  VehicleManageViewController.swift
//  InOfffice
//
//  Created by ktrkathir on 03/01/19.
//  Copyright © 2019 ktrkathir. All rights reserved.
//

import UIKit

class MileageHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var plateNumber: String = ""
    
    var fuelDetails: [FuelDetail] = []
    
    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fuelDetails = VehicleManager.current.fetchAllFuels(plateNumber: plateNumber) ?? []
        
        DispatchQueue.main.async {
            self.historyTableView.reloadData()
        }
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fuelInfoSegue" {
            let addFuel = segue.destination as! AddMileageTableViewController
            addFuel.fuelInfo = sender as? FuelDetail
        }
        
    }
    
    
    // MARK: - Tableview data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fuelDetails.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fuelDetails[section].date?.convert()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fuelCell", for: indexPath)
        
        let valueStack = cell.contentView.subviews[1] as! UIStackView
        
        let record = fuelDetails[indexPath.section]
        
        (valueStack.subviews[0] as! UILabel).text = String(record.litre) + " L"
        (valueStack.subviews[1] as! UILabel).text = String(record.initialKm) + " Km"
        
        if record.currentKm <= 0 {
            (valueStack.subviews[2] as! UILabel).text = "-"
        } else {
            (valueStack.subviews[2] as! UILabel).text = String(record.currentKm) + " Km"
        }
        
        let drived = record.currentKm - record.initialKm
        if drived <= 0 {
            (valueStack.subviews[3] as! UILabel).text = "-"
        } else {
            (valueStack.subviews[3] as! UILabel).text = String(drived) + " Km"
        }
        
        if record.avgKm <= 0 {
            (valueStack.subviews[4] as! UILabel).text = "-"
        } else {
            (valueStack.subviews[4] as! UILabel).text = String.init(format: "%.2f Km", arguments: [record.avgKm])
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        self.performSegue(withIdentifier: "fuelInfoSegue", sender: fuelDetails[indexPath.section])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            VehicleManager.current.delete(fuelDetail: fuelDetails[indexPath.section])
            
            fuelDetails.remove(at: indexPath.section)

            DispatchQueue.main.async {
                self.historyTableView.reloadData()
                
            }
        }
    }

}
