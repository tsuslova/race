//
//  ViewController.swift
//  Race
//
//  Created by Toto on 14.04.16.
//  Copyright © 2016 Toto. All rights reserved.
//

import UIKit

class RaceViewController: UIViewController, RaceDataSource {
    private struct Configuration{
        static let ParticipantsCount = 10
        static let UpdateFrequency = 50.0 //times per second
        static let RaceDistance = 1000.0 //meters
    }
    
    private func updateInterval() -> NSTimeInterval{
        return 1.0 / Configuration.UpdateFrequency;
    }
    
    private var raceModel: Race!
    
    @IBOutlet weak var raceView: RaceView!{
        didSet{
            raceView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
    }
    
    @IBAction func startRace(sender: UIButton) {
        //Re-init model
        raceModel = Race(raceDistance: Configuration.RaceDistance,
            participantsCount: Configuration.ParticipantsCount)
        
        raceView.setupRace(Configuration.ParticipantsCount)
        
        raceModel.start()
        
        NSTimer.scheduledTimerWithTimeInterval(updateInterval(), target: self,
            selector: "updateRaceView", userInfo:nil, repeats: true)
    }
    
    func updateRaceView() {
        //TODO If race has all participants finishTime filled - show scoreboard
        
        raceView.setNeedsDisplay()
    }
    
    //RaceDataSource
    func distanceFractionForParticipantAtIndex(index:Int) -> Double?{
        //TODO ask Model
        let participantDistance = raceModel.distanceForParticipantAtIndex(index)
        
        //TODO after reaching 1 set participant finishTime: assume that we have "photo finish":
        //participant finishes the race only when it becomes visible on screen
        
        return participantDistance / Configuration.RaceDistance
    }
    
    func speedForParticipantAtIndex(index:Int) -> Double?{
        //TODO ask Model
        return 1.0
    }
}
