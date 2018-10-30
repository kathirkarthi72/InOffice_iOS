//
//  CollectGameViewController.swift
//  InOfffice
//
//  Created by ktrkathir on 30/10/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit
import SpriteKit

class CollectGameViewController: UIViewController {

    @IBOutlet weak var gameView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gameView.showsFPS = true
        gameView.ignoresSiblingOrder = false
        gameView.showsNodeCount = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.GameUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.GameUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
