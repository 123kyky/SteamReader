//
//  SearchViewController.swift
//  Steam Reader
//
//  Created by Kyle Roberts on 4/26/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import UIKit

class FeaturedViewController: UIViewController, AppsTableViewDelegate, SearchViewDelegate {
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var appsTableView: AppsTableView!
    @IBOutlet weak var searchViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
        appsTableView.delegate = self
        searchView.delegate = self
        
        refreshButton.layer.cornerRadius = 15
        refreshButton.alpha = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FeaturedViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FeaturedViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FeaturedViewController.featuredAppsUpdated(_:)), name:DataManager.FeaturedAppsUpdatedNotificationName, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func featuredAppsUpdated(notification: NSNotification) {
        UIView.animateWithDuration(0.3) { 
            self.refreshButton.alpha = 0.75
        }
    }
    
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        reloadData()
        
        UIView.animateWithDuration(0.3) {
            self.refreshButton.alpha = 0
        }
    }
    
    func reloadData() {
        let special = Section(title: "Specials", apps: CoreDataInterface.singleton.featuredGamesForKey("special"))
        let newReleases = Section(title: "New Releases", apps: CoreDataInterface.singleton.featuredGamesForKey("newRelease"))
        let topSellers = Section(title: "Top Sellers", apps: CoreDataInterface.singleton.featuredGamesForKey("topSeller"))
        let comingSoon = Section(title: "Coming Soon", apps: CoreDataInterface.singleton.featuredGamesForKey("comingSoon"))
        appsTableView.sections = [special, newReleases, topSellers, comingSoon]
        appsTableView.searchContents = CoreDataInterface.singleton.allApps()
        
        for section in appsTableView.sections {
            for app in section.apps {
                print(app.name, app.type)
            }
        }
        
        NetworkManager.singleton.fetchDetailsForApps(special.apps + newReleases.apps + topSellers.apps + comingSoon.apps)
    }

    // MARK: - AppsTableView & SearchView Delegate
    
    let AppTableSegueIdentifier = "ShowAppTable"
    func appsTableAppSelected(appsTable: AppsTableView, app: App) {
        performSegueWithIdentifier(AppTableSegueIdentifier, sender: app)
    }
    
    func searchViewExpanded(searchView: SearchView) {
        
    }
    
    func searchViewCollapsed(searchView: SearchView) {
        appsTableView.filtering = false
    }
    
    func searchViewTextUpdated(searchView: SearchView, searchText: String) {
        appsTableView.filtering = searchText != ""
        appsTableView.filter(searchText)
    }
    
    func searchViewSearched(searchView: SearchView, searchText: String) {
        appsTableView.filtering = searchText != ""
        appsTableView.filter(searchText)
    }
    
    // MARK: - Layouts
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == AppTableSegueIdentifier {
            if let destinationViewController = segue.destinationViewController as? AppViewController {
                destinationViewController.app = sender as! App
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let keyboardFrame: CGRect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        self.searchViewBottomConstraint.constant = keyboardFrame.size.height
        UIView.animateWithDuration(notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.searchViewBottomConstraint.constant = 0
        UIView.animateWithDuration(notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        self.view.endEditing(true)
    }
    
}
