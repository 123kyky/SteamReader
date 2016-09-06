//
//  FavoritesViewController.swift
//  SteamReader
//
//  Created by Kyle Roberts on 8/29/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, FavoritesTableViewDelegate {
    @IBOutlet weak var favoritesTableView: FavoritesTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
        favoritesTableView.delegate = self
    }
    
    func reloadData() {
        favoritesTableView.sections = [Section(title: "Favorites", apps: CoreDataInterface.singleton.favoriteGames())]
    }
    
    // MARK: - AppsTableView & SearchView Delegate
    
    let FavoritesTableSegueIdentifier = "ShowFaveAppTable"
    func favoritesTableAppSelected(favoritesTable: FavoritesTableView, app: App) {
        performSegueWithIdentifier(FavoritesTableSegueIdentifier, sender: app)
    }
    
    // MARK: - Layouts
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == FavoritesTableSegueIdentifier {
            if let destinationViewController = segue.destinationViewController as? AppViewController {
                destinationViewController.app = sender as! App
            }
        }
    }

}
