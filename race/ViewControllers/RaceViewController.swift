//
//  ViewController.swift
//  Race
//
//  Created by Toto on 14.04.16.
//  Copyright © 2016 Toto. All rights reserved.
//

import UIKit

class RaceViewController: UIViewController, RaceDataSource {
    private struct Constants{
        static let ParticipantsCount = 10
        static let UpdateFrequency = 0.5 //times per second
    }
    
    private func updateInterval() -> NSTimeInterval{
        return 1.0 / Constants.UpdateFrequency;
    }
    
    @IBOutlet weak var raceView: RaceView!{
        didSet{
            raceView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
        raceView.setupRace(Constants.ParticipantsCount)
    }
    
    @IBAction func startRace(sender: UIButton) {
        NSTimer.scheduledTimerWithTimeInterval(updateInterval(), target: self,
            selector: "updateRaceView", userInfo:nil, repeats: true)
    }
    
    func updateRaceView() {
    }
    
    //RaceDataSource
    func distanceFractionForParticipantAtIndex(index:Int) -> Double?{
        //TODO ask Model
        return 0.5
    }
    
    func speedForParticipantAtIndex(index:Int) -> Double?{
        //TODO ask Model
        return 1.0
    }
}
