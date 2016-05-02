//
//  AppViewController.swift
//  Steam Reader
//
//  Created by Kyle Roberts on 4/26/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import UIKit

class AppViewController: UIViewController, AppTableViewDelegate {
    @IBOutlet weak var appTableView: AppTableView!
    
    var app: App!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        appTableView.delegate = self
        appTableView.app = app
    }
    
    // MARK: - AppTableViewDelegate
    
    let NewsItemSegueIdentifier = "ShowNewsItem"
    func appTableNewsItemSelected(appTable: AppTableView, newsItem: NewsItem) {
        performSegueWithIdentifier(NewsItemSegueIdentifier, sender: newsItem)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == NewsItemSegueIdentifier {
            if let destinationViewController = segue.destinationViewController as? NewsItemViewController {
                destinationViewController.newsItem = sender as! NewsItem
            }
        }
    }

}
