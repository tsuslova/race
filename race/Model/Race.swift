//
//  Race.swift
//  Race
//
//  Created by Toto on 14.04.16.
//  Copyright © 2016 Toto. All rights reserved.
//

import Foundation

class Race {
    
    private var distance: Double
    private var startTime: NSDate! //init it with start time at race start!
    private var participants: Array<Participant>
    var participantsFinishCount = 0
    var finished = true
    
    //***
    //Interface
    //***
    func start(){
        startTime = NSDate()
        participantsFinishCount = 0
        finished = false
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
                finishParticipantAtIndex(index)
            }
            participantDistance = distance
        }
        //TODO think whether time synchronization should be in controller...
        return participantDistance
    }
    
    func finishParticipantAtIndex(index: Int) {
        let participant = participants[index]
        participant.finishTime = NSDate()
        participantsFinishCount++
    }
    
    func printFinish() {
        var index = 1
        for participant in participants{
            print("\(index) finished at \(participant.finishTime)")
            index++
        }
    }
}
