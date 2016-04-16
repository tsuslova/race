//
//  Participant.swift
//  race
//
//  Created by Toto on 16.04.16.
//  Copyright © 2016 Toto. All rights reserved.
//

import Foundation

class Participant: NSObject{
    private struct Constants{
        static let BoostFrequency = 0.4 //times per second
    }
    
    private struct DistanceByTime {
        var time: NSDate
        var distanceMeters: Double
    }
    private var timer: NSTimer!
    
    //Total distance till previous speed change (may be it's better to store all the speed changes
    //and calculate on-fly...)
    private var lastBoostSpeed = 0.0 //meters per second
    
    
    private var distanceTillLastBoost: DistanceByTime!
    //init it with start time at race start!
    private var lastBoostTime: NSDate! {
        didSet {
            distanceTillLastBoost = DistanceByTime(time: lastBoostTime, distanceMeters: 0.0)
        }
    }
    
    private func updateInterval() -> NSTimeInterval{
        return 1.0 / Constants.BoostFrequency;
    }
    
    //***
    //Interface
    //***
    //Should be set from RaceController on "photo-finish")
    var finishTime: NSDate!
    
    func distanceForTime(time: NSDate) -> Double{
        //If we already finished time used for calculation is:
        //let timeForCalculation = finishTime ?? time
        
        //TODO: take lastBoostDistance and add timediff to find exact distance
        return distanceTillLastBoost?.distanceMeters ?? 0.0
    }
    
    func lastKnownSpeed() -> Double{
        return lastBoostSpeed
    }
    
    func boost(){
        if lastBoostTime == nil {
            print("Debug log: not in race yet...");
            return
        }
        if finishTime != nil {
            print("Great! On finish!");
            timer.invalidate()
            return
        }
        let currentTime = NSDate()
        let newSpeed = 10.0 //TODO simplest case - constant speed. Replace with speed generation
        
        //TODO: syncronized!
        let lastBoostInterval = currentTime.timeIntervalSinceDate(lastBoostTime!)
        let lastBoostDistance =  lastBoostInterval * lastBoostSpeed
        
        distanceTillLastBoost.distanceMeters += lastBoostDistance
        distanceTillLastBoost.time = currentTime
        lastBoostSpeed = newSpeed
        
        print("lastBoostInterval = \(lastBoostInterval), currentTime= \(currentTime)")
        print("Debug log: \(newSpeed), distance= \(distanceTillLastBoost.distanceMeters)");
        
    }
    
    func start(startTime: NSDate){
        lastBoostTime = startTime
        timer = NSTimer.scheduledTimerWithTimeInterval(updateInterval(), target: self,
            selector: "boost", userInfo:nil, repeats: true)
    }
    
}
