//
//  InitialViewController.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit
import CoreData

class InitialViewController: UIViewController {
    
    @IBOutlet var viewModel: InitialViewModel!
    
    @IBOutlet weak var signupTableView: UITableView!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var tapGesture = UITapGestureRecognizer()
    
    var nameTextField: UITextField!
    var officeTextField: UITextField!
    
    var productionHourTapped: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.titleLabel?.textColor = UIColor.theme
        
        signupTableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: TapGesture
    @objc func tapGesture(recognizer: UITapGestureRecognizer) {
        productionHourTapped = true
        
        DispatchQueue.main.async {
            self.signupTableView.reloadData()
        }
    }

    // MARK: - Button Action
    /// Login button action
    @IBAction func loginButtonAction(_ sender: Any) {
        
        guard let name = nameTextField.text, !name.isEmpty else {
            nameTextField.shake()
            
            return
        }
        
        guard let officeName = officeTextField.text, !officeName.isEmpty else {
            officeTextField.shake()
            return
        }
        
        viewModel.userEnteredDetails.name = name
        viewModel.userEnteredDetails.office = officeName
        
        if InOfficeManager.current.saved(detail: viewModel.userEnteredDetails) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - Tableview Datasource
extension InitialViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productionHourTapped {
            return 4
        }
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)
            nameTextField = cell.contentView.viewWithTag(100) as! UITextField
            nameTextField.delegate = self
            nameTextField.text = viewModel.userEnteredDetails.name

            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "officeCell", for: indexPath)
            officeTextField = cell.contentView.viewWithTag(100) as! UITextField
            officeTextField.delegate = self
            
            return cell
            
        case 2:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
            
            cell.textLabel?.text = "Daily produciton hours"
            cell.detailTextLabel?.text = viewModel.userEnteredDetails.productionHourString
            
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(recognizer:)))
            cell.addGestureRecognizer(tapGesture)
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell", for: indexPath)
            let picker = cell.contentView.viewWithTag(100) as! UIPickerView
            
            picker.reloadAllComponents()
            return cell
        }
    }
}

// MARK: - UIPickerView
extension InitialViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TimeSheetManager.current.productionHourString.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let production = TimeSheetManager.current.productionHourString[row]
        return production.description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selectedProductionHour = TimeSheetManager.current.productionHourList[row]
        viewModel.userEnteredDetails.productionHours = selectedProductionHour
        
        let selectedProductionHourString = TimeSheetManager.current.productionHourString[row]
        viewModel.userEnteredDetails.productionHourString = selectedProductionHourString
        
        productionHourTapped = false
        
        DispatchQueue.main.async {
            self.signupTableView.reloadData()
        }
    }
}

// MARK: - TextField Delegate
extension InitialViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


