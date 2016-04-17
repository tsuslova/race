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
        static let RaceDistance = 100.0 //meters
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
    
    private var timer: NSTimer!
    @IBAction func startRace(sender: UIButton) {
        //Re-init model
        raceModel = Race(raceDistance: Configuration.RaceDistance,
            participantsCount: Configuration.ParticipantsCount)
        
        raceView.setupRace(Configuration.ParticipantsCount)
        
        raceModel.start()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(updateInterval(), target: self,
            selector: "updateRaceView", userInfo:nil, repeats: true)
    }
    
    func updateRaceView() {
        if raceModel.raceFinished {
            timer.invalidate()
            return
        }
        //TODO If race has all participants finishTime filled - show scoreboard
        if raceModel.participantsFinishCount == Configuration.ParticipantsCount{
            raceModel.raceFinished = true
            raceModel.printFinish()
        }
        raceView.setNeedsDisplay()
        
    }
    
    //RaceDataSource
    func distanceFractionForParticipantAtIndex(index:Int) -> Double?{
        let participantDistance = raceModel.distanceForParticipantAtIndex(index)
        return participantDistance / Configuration.RaceDistance
    }
    
    func speedForParticipantAtIndex(index:Int) -> String?{
        if raceModel.isFinishedAtIndex(index){
            return "Finished!"
        }
        let participantSpeed = raceModel.speedForParticipantAtIndex(index)
        let speedString = NSNumberFormatter().stringFromNumber(participantSpeed ?? 0.0)!+"m/s"
        return speedString
    }
}
