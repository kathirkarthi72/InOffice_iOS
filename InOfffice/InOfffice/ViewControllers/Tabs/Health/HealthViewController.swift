//
//  HealthViewController.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

class HealthViewController: UIViewController {

    @IBOutlet var healthViewModel: HealthViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       healthViewModel.requestAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  /*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    */

    @IBAction func inTakeWaterButtonClicked(_ sender: Any) {
        
        let button = sender as! UIButton
        switch button.tag {
        case 100:
            healthViewModel.addWaterInTake(onces: 0.100) // 100 ml drunk
        case 200:
            healthViewModel.addWaterInTake(onces: 0.200) // 100 ml drunk
        case 300:
            healthViewModel.addWaterInTake(onces: 0.300) // 100 ml drunk
        case 400:
            healthViewModel.addWaterInTake(onces: 0.400) // 100 ml drunk
        case 500:
            healthViewModel.addWaterInTake(onces: 0.500) // 100 ml drunk
        default:
            break
        }
        
       button.isSelected = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            button.isSelected = false
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
