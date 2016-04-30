//
//  NewsItemView.swift
//  SteamReader
//
//  Created by Kyle Roberts on 4/29/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import UIKit

class NewsItemView: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var webView: UIWebView!
    
    var newsItem: NewsItem! {
        didSet {
            if newsItem.contents != nil {
                webView.loadHTMLString(newsItem.contents!, baseURL: nil)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSBundle.mainBundle().loadNibNamed("NewsItemView", owner: self, options: nil)
        addSubview(view)
        view.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }

}
