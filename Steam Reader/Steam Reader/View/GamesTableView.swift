//
//  GamesTableView.swift
//  Steam Reader
//
//  Created by Kyle Roberts on 4/26/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import UIKit

protocol GamesTableViewDelegate {
    func gamesTableGameSelected(gamesTable: GamesTableView, game: AnyObject)
}

class GamesTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: GamesTableView!
    
    var games = []
    
    var delegate: GamesTableViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSBundle.mainBundle().loadNibNamed("GamesTableView", owner: self, options: nil)
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.gamesTableGameSelected(self, game: games[indexPath.row])
    }
    
}
