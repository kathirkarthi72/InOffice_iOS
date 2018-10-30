//
//  JumpGameViewController.swift
//  InOfffice
//
//  Created by ktrkathir on 11/10/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit
import SpriteKit

class JumpGameViewController: UIViewController {

    @IBOutlet weak var spriteView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        spriteView.showsFPS = true
//        spriteView.ignoresSiblingOrder = false
//        spriteView.showsNodeCount = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func dismissButtonTapped(_ sender: Any) {
        
        spriteView.removeFromSuperview()
        
       self.dismiss(animated: true, completion: nil)
    }
}
