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
    func speedForParticipantAtIndex(index:Int) -> String?
}

@IBDesignable
class RaceView: UIView {
    
    weak var dataSource: RaceDataSource?
    
    func setupRace(participantsCount: Int) {
        //Re-init
        if subviews.count > 0{
            for view in subviews {
                view.removeFromSuperview()
            }
        }
        
        let participantViewHeight = frame.size.height / CGFloat(participantsCount)
        var y = CGFloat(0.0)
        for i in 1...participantsCount {
            let participantView = ParticipantView(frame: CGRectMake(0, y,
                ParticipantView.prefferedWidth(), participantViewHeight))
            y += participantViewHeight
            participantView.text = dataSource?.speedForParticipantAtIndex(i-1)
            addSubview(participantView)
        }
        
    }
    
    func raceWidth() -> CGFloat {
        return frame.size.width - ParticipantView.prefferedWidth()
    }
    
    func finishLine() -> UIBezierPath{
        let path = UIBezierPath()
        let x = raceWidth()
        path.moveToPoint(CGPoint(x: x, y: 0))
        path.addLineToPoint(CGPoint(x:x, y:frame.size.height))
        path.lineWidth = 1
        return path
    }
    
    override func drawRect(rect: CGRect) {
        var index = 0
        for view in subviews {
            if let participantView = view as? ParticipantView {
                participantView.text = dataSource?.speedForParticipantAtIndex(index)
            }
            let distanceFraction = dataSource?.distanceFractionForParticipantAtIndex(index) ?? 0.0
            var x = raceWidth() * CGFloat(distanceFraction)
            if x < 0 {
                x = 0
            }
            view.frame.origin.x = x
            index++
        }
        finishLine().stroke()
    }
    
}
