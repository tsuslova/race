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
    private var participantsFinishCount = 0
    
    //***
    //Interface
    //***
    func start(){
        startTime = NSDate()
        for participant in participants{
            participant.start(startTime)
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
        //TODO thick whether time synchronization should be in controller...
        return participant.distanceForTime(NSDate())
    }
}
