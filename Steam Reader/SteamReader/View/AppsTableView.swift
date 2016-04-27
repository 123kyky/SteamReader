//
//  AppsTableView.swift
//  Steam Reader
//
//  Created by Kyle Roberts on 4/26/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import UIKit

protocol AppsTableViewDelegate {
    func gamesTableGameSelected(gamesTable: AppsTableView, game: AnyObject)
}

class AppsTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: AppsTableView!
    
    var games: [App]
    
    var delegate: AppsTableViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        games = App.MR_findAll() as? [App] ?? []
        
        super.init(coder: aDecoder)
        
        NSBundle.mainBundle().loadNibNamed("AppsTableView", owner: self, options: nil)
        self.addSubview(self.tableView)
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    // MARK: - UITableView Delegate & DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    let CellIdentifier = "Cell"
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: CellIdentifier)
        }
        
        let app = games[indexPath.row]
        cell!.textLabel!.text = app.name
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.gamesTableGameSelected(self, game: games[indexPath.row])
    }
    
}
