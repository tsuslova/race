//
//  RaceView.swift
//  race
//
//  Created by Toto on 16.04.16.
//  Copyright © 2016 Toto. All rights reserved.
//

import Foundation
import UIKit

protocol RaceDataSource: class {
    func distanceFractionForParticipantAtIndex(index:Int) -> Double?
    func speedForParticipantAtIndex(index:Int) -> Double?
}

@IBDesignable
class RaceView: UIView {
    
    weak var dataSource: RaceDataSource?
    
    func setupRace(participantsCount: Int) {
        let participantViewHeight = frame.size.height / CGFloat(participantsCount)
        var y = CGFloat(0.0)
        for i in 1...participantsCount {
            let participantView = ParticipantView(frame: CGRectMake(0, y, 100, 20))
            y += participantViewHeight
            let speed = dataSource?.speedForParticipantAtIndex(i-1)
            participantView.text = NSNumberFormatter().stringFromNumber(speed ?? 0.0)
            addSubview(participantView)
        }
        
    }
    
    override func drawRect(rect: CGRect) {
        var index = 0
        for view in subviews {
            if let participantView = view as? ParticipantView {
                let speed = dataSource?.speedForParticipantAtIndex(index)
                participantView.text = NSNumberFormatter().stringFromNumber(speed ?? 0.0)
            }
            let distanceFraction = dataSource?.distanceFractionForParticipantAtIndex(index) ?? 0.0
            var x = frame.size.width * CGFloat(distanceFraction)
            if x < 0{
                x = 0
            }
            if x > frame.size.width - view.frame.size.width{
                x  = frame.size.width - view.frame.size.width
            }
            view.frame.origin.x = x
            index++
        }
    }
    
}
