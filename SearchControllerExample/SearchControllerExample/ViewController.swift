//
//  ViewController.swift
//  SearchControllerExample
//
//  Created by Matthew Tso on 7/22/16.
//  Copyright © 2016 Matthew Tso. All rights reserved.
//

import UIKit

let CellIdentifier = "Cell"

class ViewController: UITableViewController, UISearchResultsUpdating {

    let entries = [(title: "Easiest", image: "green_circle"),
                   (title: "Intermediate", image: "blue_square"),
                   (title: "Advanced", image: "black_diamond"),
                   (title: "Expert Only", image: "double_black_diamond"),
                   (title: "Variations", image: "square_diamond"),
                   (title: "Terrain Parks", image: "terrain_park")]
    var searchResults : [(title: String, image: String)] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        //searchController.hidesNavigationBarDuringPresentation = true
        //searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
//        self.navigationItem.titleView = searchController.searchBar
        
        self.tableView.tableHeaderView = searchController.searchBar
        self.tableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.height)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UISearchResultsUpdating methods
    
    func filterContent(for searchText: String) {
        searchResults = entries.filter({ (title: String, image: String) -> Bool in
            let match = title.range(of: searchText, options: .caseInsensitive)
            return match != nil
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewController methods
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? searchResults.count : entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
        let entry = searchController.isActive ? searchResults[indexPath.row] : entries[indexPath.row]
        
        cell.textLabel?.text = entry.title
        cell.imageView?.image = UIImage(named: entry.image)
        
        return cell
    }
    
}

