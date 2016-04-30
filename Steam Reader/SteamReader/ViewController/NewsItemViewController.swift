//
//  NewsItemViewController.swift
//  SteamReader
//
//  Created by Kyle Roberts on 4/28/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import UIKit

class NewsItemViewController: UIViewController {
    @IBOutlet weak var appHeaderView: AppHeaderView!
    @IBOutlet weak var newsItemView: NewsItemView!
    
    var newsItem: NewsItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        appHeaderView.configure(newsItem.app)
        newsItemView.newsItem = newsItem
    }

}

