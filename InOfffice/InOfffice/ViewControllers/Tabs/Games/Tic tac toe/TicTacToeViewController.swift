//
//  TicTacToeViewController.swift
//  InOfffice
//
//  Created by ktrkathir on 03/10/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit
import SpriteKit

class TicTacToeViewController: UIViewController {
    
    @IBOutlet weak var sceneView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.layer.borderColor = UIColor.lightText.cgColor
        sceneView.layer.borderWidth = 1.0
                
      //  sceneView.showsFPS = true
        sceneView.ignoresSiblingOrder = false
      //  sceneView.showsNodeCount = true
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension TicTacToeViewController {
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
