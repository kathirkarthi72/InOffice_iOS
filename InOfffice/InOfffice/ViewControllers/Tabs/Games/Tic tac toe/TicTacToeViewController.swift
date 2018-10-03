//
//  TicTacToeViewController.swift
//  InOfffice
//
//  Created by ktrkathir on 03/10/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

class TicTacToeViewController: UIViewController {

    @IBOutlet var viewModel: TicTacToeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.newGame()
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
