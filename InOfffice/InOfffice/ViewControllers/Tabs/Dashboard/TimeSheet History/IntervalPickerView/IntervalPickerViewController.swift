//
//  IntervalPickerViewController.swift
//  InOfffice
//
//  Created by ktrkathir on 08/10/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

class IntervalPickerViewController: UIViewController {
    
    @IBOutlet weak var fromDate: UILabel!
    @IBOutlet weak var toDate: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var submitButton: UIButton!
    private var completionHandler: ( (_ from: Date, _ to: Date) -> Void )?
    
    var minmumDate: Date?
    var maximumDate: Date?
    
    var from: Date?
    var to: Date?
    
    private var selectedLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedLabel = fromDate
        
        datePicker.minimumDate = minmumDate
        datePicker.maximumDate = maximumDate
        
        if let min = minmumDate, let max = maximumDate {
            from = min
            fromDate.text = min.convert()
            
            to = max
            toDate.text = max.convert()
        }
        
        fromDate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGestureRegonizer(_:))))
        toDate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGestureRegonizer(_:))))
    }
    
    @objc func handleGestureRegonizer(_ regonizer: UIGestureRecognizer) {
        
        switch regonizer.view {
        case fromDate:
            selectedLabel = fromDate
            fromDate.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            toDate.backgroundColor = UIColor.white
            
        case toDate:
            selectedLabel = toDate
            fromDate.backgroundColor = UIColor.white
            toDate.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        default:
            break
        }
    }
    
    func picked(completed: @escaping ( (_ from: Date, _ to: Date) -> Void )) {
        completionHandler = completed
    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        switch selectedLabel {
        case fromDate:
            from = datePicker.date
            fromDate.text = datePicker.date.convert()
        case toDate:
            to = datePicker.date
            toDate.text = datePicker.date.convert()

        default:
            break
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func downloadButtonTapped(_ sender: Any) {
        
        guard let from = from, let to = to else { return }
        
        self.dismiss(animated: true, completion: nil)
        
        if let handler = completionHandler {
            handler(from, to)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first, let touchedView = touch.view, touchedView == self.view {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
