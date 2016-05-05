//
//  AppTableView.swift
//  Steam Reader
//
//  Created by Kyle Roberts on 4/26/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import UIKit
import CoreData
import Async

protocol AppTableViewDelegate {
    func appTableNewsItemSelected(appTable: AppTableView, newsItem: NewsItem)
}

class AppTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    var app: App! {
        didSet {
            app.addObserver(self, forKeyPath: "newsItems", options: NSKeyValueObservingOptions.New, context: nil)
            NetworkManager.singleton.fetchNewsForApp(app)
            if app.newsItems.count > 0 { newsItems = app.newsItems.allObjects as! [NewsItem] }
            if oldValue != nil {
                oldValue.removeObserver(self, forKeyPath: "newsItems")
            }
        }
    }
    var newsItems: [NewsItem]! = []
    
    var delegate: AppTableViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSBundle.mainBundle().loadNibNamed("AppTableView", owner: self, options: nil)
        addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        tableView.registerClass(AppHeaderCell.self, forCellReuseIdentifier: HeaderIdentifier)
        tableView.registerClass(NewsItemHeaderCell.self, forCellReuseIdentifier: CellIdentifier)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "newsItems" && app!.newsItems.count > 0 {
            Async.main {
                self.newsItems = self.app!.newsItems.allObjects as! [NewsItem]
                self.tableView.reloadData()
            }
        }
    }
    
    deinit {
        app?.removeObserver(self, forKeyPath: "newsItems")
    }
    
    // MARK: - UITableView Delegate & DataSource
    
    let HeaderIdentifier = "AppHeaderCellIdentifier"
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cell = tableView.dequeueReusableCellWithIdentifier(HeaderIdentifier) as? AppHeaderCell
        if cell == nil {
            cell = AppHeaderCell(style: .Default, reuseIdentifier: CellIdentifier)
        }
        
        cell!.appView!.configureWithApp(app)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return app.name
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
    }
    
    let CellIdentifier = "NewsItemCell"
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? NewsItemHeaderCell
        if cell == nil {
            cell = NewsItemHeaderCell(style: .Default, reuseIdentifier: CellIdentifier)
        }
        
        let newsItem = newsItems[indexPath.row]
        cell!.newsItemView!.configure(newsItem)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.appTableNewsItemSelected(self, newsItem: newsItems[indexPath.row])
    }

}
