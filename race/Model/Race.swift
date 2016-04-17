//
//  Race.swift
//  Race
//
//  Created by Toto on 14.04.16.
//  Copyright © 2016 Toto. All rights reserved.
//

import Foundation

struct RaceResult{
    var name: String
    var resultTime: Double
}

class Race {    
    private var distance: Double
    private var startTime: NSDate! //init it with start time at race start!
    private var participants: Array<Participant>
    
    //***
    //Interface
    //***
    var participantsFinishCount = 0
    var raceFinished = true
    
    func setFinishedParticipantAtIndex(index: Int) {
        let participant = participants[index]
        participant.finishTime = NSDate()
        participantsFinishCount++
    }
    
    func start(){
        startTime = NSDate()
        participantsFinishCount = 0
        raceFinished = false
        var index = 1
        for participant in participants{
            participant.start(startTime, yourNumber: index++)
        }
    }
    
    init(raceDistance: Double, participantsCount: Int) {
        distance = raceDistance
        
        participantsFinishCount = 0
        participants = Array()
        for _ in 1...participantsCount{
            participants.append(Participant())
        }
    }
    
    func distanceForParticipantAtIndex(index: Int) -> Double{
        let participant = participants[index]
        
        var participantDistance = participant.distanceForTime(NSDate())
        if participantDistance >= distance {
            if participant.finishTime == nil {
                setFinishedParticipantAtIndex(index)
            }
            participantDistance = distance
        }
        return participantDistance
    }
    
    func speedForParticipantAtIndex(index:Int) -> Double?{
        let participant = participants[index]
        return participant.lastKnownSpeed()
    }
    
    func isFinishedAtIndex(index:Int) -> Bool{
        let participant = participants[index]
        return participant.finishTime != nil
    }
    
    func results() -> Array<RaceResult>{
        var results = Array<RaceResult>()
        for participant in participants{
            let name = "Participant \(participant.participantNumber)"
            let time = participant.finishTime.timeIntervalSinceDate(startTime)
            results.append(RaceResult(name: name, resultTime: time))
            
        }
        return results.sort{ (raceResult1, raceResult2) -> Bool in
            raceResult1.resultTime < raceResult2.resultTime
        }
    }
    
    deinit{
        if !raceFinished{
            for participant in participants{
                participant.cancel()
            }
        }
    }
}
