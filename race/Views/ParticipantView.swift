//
//  ParticipantView.swift
//  race
//
//  Created by Toto on 16.04.16.
//  Copyright © 2016 Toto. All rights reserved.
//

import Foundation
import UIKit


protocol ParticipantViewDataSource: class {
    func coordinateForParticipantView(sender:ParticipantView) -> CGPoint?
}

@IBDesignable
class ParticipantView: UIView {
    
    weak var dataSource: ParticipantViewDataSource?
    
}