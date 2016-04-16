//
//  Participant.swift
//  race
//
//  Created by Toto on 16.04.16.
//  Copyright © 2016 Toto. All rights reserved.
//

import Foundation

class Participant {
    
    private struct DistanceByTime {
        var time: NSDate
        var distanceMeters: Double
    }
    
    //Total distance till previous speed change (may be it's better to store all the speed changes
    //and calculate on-fly...)
    private var lastBoostSpeed = 0.0 //meters per second
    private var lastBoostTime: NSDate! //init it with start time at race start!
    private var lastBoostDistance: DistanceByTime!
    
    //***
    //Interface
    //***
    //Should be set from RaceController on "photo-finish")
    var finishTime: NSDate!
    
    func distanceForTime(time: NSDate) -> Double{
        //TODO: take lastBoostDistance and add timediff to find exact distance
        return lastBoostDistance?.distanceMeters ?? 0.0
    }
    
    func boost(){
        //TODO:
        // - store current time
        // - generate new speed
        // - syncronously
        //   - append lastBoostDistance
        //   - update lastBoostTime & lastBoostSpeed to currentTime/speed
    }
    
    func start(raceDistance: Double){
        //TODO:
        // - create a thread performing boost e.g. every second
        // - thread must work till RaceController defines that the participant reach the finish
    }
}
