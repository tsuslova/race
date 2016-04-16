//
//  ViewController.swift
//  Race
//
//  Created by Toto on 14.04.16.
//  Copyright © 2016 Toto. All rights reserved.
//

import UIKit

class RaceViewController: UIViewController {
    
    @IBOutlet weak var raceView: RaceView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
    }
    
    @IBAction func startRace(sender: UIButton) {
    }
    
}

