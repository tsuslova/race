//
//  Participant.swift
//  race
//
//  Created by Toto on 16.04.16.
//  Copyright © 2016 Toto. All rights reserved.
//

import Foundation

class Participant: NSObject{
    
    //***
    //Interface
    //***
    //Should be set from RaceController on "photo-finish")
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
    
    func start(startTime: NSDate, yourNumber: Int){
        lastBoostTime = startTime
        worker = NSThread(target: self, selector: "moving", object: nil)
        worker.threadPriority = Double(yourNumber)/10.0
        participantNumber = yourNumber
        worker.start()
    }
    
    var participantNumber: Int {
        get {
            return getWith(_participantNumber, closure: {return self._participantNumber}) ?? 0
        }
        set {
            setWith(_participantNumber, closure: {self._participantNumber = newValue})
        }
    }
    
    func cancel(){
        worker.cancel()
    }
    
    //***
    //Implementation
    //***
    
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
    
    private func getWith<T>(lock: AnyObject?, closure: () -> T?) -> T? {
        var value: T?
        objc_sync_enter(lock)
        value = closure()
        objc_sync_exit(lock)
        return value
    }
    
    private func setWith(lock: AnyObject?, closure: () -> Void) {
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
            return getWith(_lastBoostSpeed, closure: {return self._lastBoostSpeed}) ?? 0.0
        }
        set {
            setWith(_lastBoostSpeed, closure: {self._lastBoostSpeed = newValue})
        }
    }
    
    private var _distanceTillLastBoost = 0.0
    private var distanceTillLastBoost: Double {
        get {
            return getWith(_distanceTillLastBoost, closure: {return self._distanceTillLastBoost}) ?? 0.0
        }
        set {
            setWith(_distanceTillLastBoost, closure: {self._distanceTillLastBoost = newValue})
        }
    }
    
    //init it with start time at race start!
    private var _lastBoostTime = NSDate()
    private let _lastBoostTimeQueue = dispatch_queue_create("com.test.LockQueue", nil)
    private var lastBoostTime: NSDate!  {
        get {
            var time = NSDate()
            dispatch_sync(_lastBoostTimeQueue) {
                time = self._lastBoostTime
            }
            return time
        }
        set {
            dispatch_barrier_async(_lastBoostTimeQueue) {self._lastBoostTime = newValue}
        }
    }
    
    private var worker: NSThread!
    
    private var _participantNumber = 0
    
    private let _finishTimeLock = "_finishTimeLock"
    private var _finishTime: NSDate!
    
    private func generateSpeed() -> Double!{
        let speedMultiplier = drand48() + 0.55
        
        var newSpeed = lastBoostSpeed*(speedMultiplier)
        if newSpeed > Constants.MaxSpeed {//Driver got afraid...
            newSpeed = Constants.MaxSpeed - 10
        } else if newSpeed < Constants.MinSpeed {
            newSpeed = Constants.MinSpeed
        }
        return newSpeed
    }
    
    private func boost(){
        if lastBoostTime == nil {
            print("Debug log: not in race yet...");
            return
        }
        if finishTime != nil {
            //print("Great! On finish!");
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
    
}
