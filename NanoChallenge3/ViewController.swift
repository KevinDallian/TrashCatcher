//
//  ViewController.swift
//  NanoChallenge3
//
//  Created by Kevin Dallian on 17/07/23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        let nextViewController = GameViewController()
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    
    
}

