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
        
        //Gameplay
        static let InitialSpeed = 10.0
        static let MaxSpeed = 100.0
        static let MinSpeed = 10.0
    }
    
    private func updateInterval() -> NSTimeInterval{
        return 1.0 / Constants.BoostFrequency;
    }
    
    func getWith<T>(lock: AnyObject, closure: () -> T) -> T {
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
    private var _lastBoostSpeed = Constants.InitialSpeed
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
    
    private var worker: NSThread!
    
    private var _participantNumber = 0
    private var participantNumber: Int {
        get {
            return getWith(_participantNumber, closure: {return self._participantNumber})
        }
        set {
            setWith(_participantNumber, closure: {self._participantNumber = newValue})
        }
    }
    
    //***
    //Interface
    //***
    //Should be set from RaceController on "photo-finish")
    private let _finishTimeLock = "_finishTimeLock"
    private var _finishTime: NSDate!
    var finishTime: NSDate!{
        get {
            return getWith(_finishTimeLock, closure: {return self._finishTime})
        }
        set {
            setWith(_finishTimeLock, closure: {self._finishTime = newValue})
        }
    }
    
    func distanceForTime(time: NSDate) -> Double{
        if lastBoostTime == nil {
            print("Debug log: not in race yet...");
            return 0.0
        }
        
        let currentTime = NSDate()
        let lastBoostInterval = currentTime.timeIntervalSinceDate(lastBoostTime!)
        return distanceTillLastBoost+lastBoostInterval*lastBoostSpeed
    }
    
    func lastKnownSpeed() -> Double{
        return lastBoostSpeed
    }
    
    func generateSpeed() -> Double!{
        let speedMultiplier = drand48() + 0.55
        
        var newSpeed = lastBoostSpeed*(speedMultiplier)
        if newSpeed > Constants.MaxSpeed {//Driver got afraid...
            newSpeed = Constants.MaxSpeed - 10
        } else if newSpeed < Constants.MinSpeed {
            newSpeed = Constants.MinSpeed
        }
        return newSpeed
    }
    
    func boost(){
        if lastBoostTime == nil {
            print("Debug log: not in race yet...");
            return
        }
        if finishTime != nil {
            print("Great! On finish!");
            worker.cancel()
            return
        }
        let currentTime = NSDate()
        let newSpeed = generateSpeed()
        
        let lastBoostInterval = currentTime.timeIntervalSinceDate(lastBoostTime!)
        let lastBoostDistance =  lastBoostInterval * lastBoostSpeed
        
        distanceTillLastBoost += lastBoostDistance
        lastBoostTime = NSDate()
        lastBoostSpeed = newSpeed
        
        //        print("lastBoostInterval = \(lastBoostInterval), currentTime= \(currentTime)")
        //        print("Debug log: \(newSpeed), distance= \(distanceTillLastBoost)");
        
    }
    
    func moving(){
        while !worker.cancelled {
            boost()
            NSThread.sleepForTimeInterval(updateInterval())
        }
    }
    
    func start(startTime: NSDate, yourNumber: Int){
        lastBoostTime = startTime
        worker = NSThread(target: self, selector: "moving", object: nil)
        worker.threadPriority = Double(yourNumber)/10.0
        participantNumber = yourNumber
        worker.start()
    }
    
}
