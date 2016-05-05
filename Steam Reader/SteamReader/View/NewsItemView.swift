//
//  NewsItemView.swift
//  SteamReader
//
//  Created by Kyle Roberts on 4/29/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import UIKit

class NewsItemView: UIView, UIWebViewDelegate {
    @IBOutlet var view: UIView!
    @IBOutlet weak var webView: UIWebView!
    
    var newsItem: NewsItem! {
        didSet {
            if newsItem.contents != nil {
                let html = "<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"news.css\"></head>" + "<body>\(newsItem.contents!)</body></html>"
                webView.loadHTMLString(html, baseURL: NSBundle.mainBundle().bundleURL)
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
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // TODO: Handle news navigation (back button)
        return navigationType == .Other
    }

}
