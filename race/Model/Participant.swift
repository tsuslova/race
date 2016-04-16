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
        static let BoostFrequency = 50.0 //times per second
    }
    
    private var timer: NSTimer!
    private func updateInterval() -> NSTimeInterval{
        return 1.0 / Constants.BoostFrequency;
    }
    
    func getWith<T>(lock: AnyObject, closure: () -> T) -> T {
        //TODO non-blocking read? mutex?
        var value: T
        objc_sync_enter(lock)
        value = closure()
        objc_sync_exit(lock)
        return value
    }
    
    func setWith(lock: AnyObject, closure: () -> Void) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    //Total distance till previous speed change (may be it's better to store all the speed changes
    //and calculate on-fly...)
    //meters per second
    private var _lastBoostSpeed = 0.0
    private var lastBoostSpeed: Double {
        get {
            return getWith(_lastBoostSpeed, closure: {return self._lastBoostSpeed})
        }
        set {
            setWith(_lastBoostSpeed, closure: {self._lastBoostSpeed = newValue})
        }
    }
    
    private var _distanceTillLastBoost = 0.0
    private var distanceTillLastBoost: Double {
        get {
            return getWith(_distanceTillLastBoost, closure: {return self._distanceTillLastBoost})
        }
        set {
            setWith(_distanceTillLastBoost, closure: {self._distanceTillLastBoost = newValue})
        }
    }
    
    //init it with start time at race start!
    private var _lastBoostTime = NSDate()
    private var lastBoostTime: NSDate!  {
        get {
            return getWith(_lastBoostTime, closure: {return self._lastBoostTime})
        }
        set {
            setWith(_lastBoostTime, closure: {self._lastBoostTime = newValue})
        }
    }
    
    //***
    //Interface
    //***
    //Should be set from RaceController on "photo-finish")
    var finishTime: NSDate! //TODO atomic
    
    func distanceForTime(time: NSDate) -> Double{
        if lastBoostTime == nil {
            print("Debug log: not in race yet...");
            return 0.0
        }
        //If we already finished time used for calculation is:
        //let timeForCalculation = finishTime ?? time
        
        let currentTime = NSDate()
        let lastBoostInterval = currentTime.timeIntervalSinceDate(lastBoostTime!)
        //TODO: take lastBoostDistance and add timediff to find exact distance
        return distanceTillLastBoost+lastBoostInterval*lastBoostSpeed
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
        
        let lastBoostInterval = currentTime.timeIntervalSinceDate(lastBoostTime!)
        let lastBoostDistance =  lastBoostInterval * lastBoostSpeed
        
        distanceTillLastBoost += lastBoostDistance
        lastBoostSpeed = newSpeed
        
        //        print("lastBoostInterval = \(lastBoostInterval), currentTime= \(currentTime)")
        //        print("Debug log: \(newSpeed), distance= \(distanceTillLastBoost)");
        
    }
    
    func moving(){
        while true {
            boost()
            NSThread.sleepForTimeInterval(updateInterval())
        }
    }
    
    func start(startTime: NSDate){
        lastBoostTime = startTime
        NSThread.detachNewThreadSelector("moving", toTarget: self, withObject: nil)
    }
    
}
