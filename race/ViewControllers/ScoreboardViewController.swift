//
//  ScoreboardViewController.swift
//  Race
//
//  Created by Toto on 17.04.16.
//  Copyright © 2016 Toto. All rights reserved.
//

import UIKit

class ScoreCell: UITableViewCell {
    
    @IBOutlet weak var lblIndex: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
}

class ScoreboardViewController: UITableViewController {
    
    //***
    //Interface
    //***
    var resultsList: Array<RaceResult>! {
        didSet{
            tableView.reloadData()
        }
    }

    //***
    //Implementation
    //***

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsList != nil ? resultsList.count : 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScoreCell", forIndexPath: indexPath)
        if let scoreCell = cell as? ScoreCell{
            let result = resultsList[indexPath.row]
            scoreCell.lblIndex.text = "\(indexPath.row+1)."
            scoreCell.lblName.text = result.name
            scoreCell.lblTime.text = "\(result.resultTime)"
        }

        return cell
    }

}
