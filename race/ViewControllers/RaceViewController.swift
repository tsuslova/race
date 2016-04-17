//
//  ViewController.swift
//  Race
//
//  Created by Toto on 14.04.16.
//  Copyright © 2016 Toto. All rights reserved.
//

import UIKit

class RaceViewController: UIViewController, RaceDataSource {
    
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    private var timer: NSTimer!
    
    @IBAction func startRace(sender: UIButton) {
        timer?.invalidate()
        
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
            performSegueWithIdentifier("scoreboardSegue", sender: self)
            return
        }
        if raceModel.participantsFinishCount == Configuration.ParticipantsCount{
            raceModel.raceFinished = true
        }
        raceView.setNeedsDisplay()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let scoreboardVC = segue.destinationViewController as? ScoreboardViewController{
            scoreboardVC.resultsList = raceModel.results()
        }
    }

}
