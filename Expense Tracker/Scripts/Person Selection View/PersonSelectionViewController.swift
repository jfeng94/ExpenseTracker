//
//  PersonSelectionViewController.swift
//  Expense Tracker
//
//  Created by Jerry Feng on 9/23/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import UIKit

class PersonSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    @IBOutlet var tableView: UITableView!
    
//    var detailViewController: DetailViewController? = nil
    var excludedPeople = [String]()
    
    var people = [String]()
    var filteredPeople = [String]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.sizeToFit()
        
//        searchController.delegate = self;
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search People"
        searchController.searchBar.scopeButtonTitles = [];
        
        tableView.delegate = self
        tableView.dataSource = self
        definesPresentationContext = true

        
        
        tableView.setContentOffset(CGPoint.init(x: 0, y: searchController.searchBar.frame.size.height), animated: false)
    
        people = PersonManager.instance.GetPeople(excluding: excludedPeople)

//        if let splitViewController = splitViewController {
//            let controllers = splitViewController.viewControllers
//            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredPeople = people.filter({( person : String) -> Bool in
            return PersonManager.instance.GetName(ID: person).lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredPeople.count
        }
        
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as? PersonTableViewCell {
            let person: String
            if isFiltering() {
                person = filteredPeople[indexPath.row]
            } else {
                person = people[indexPath.row]
            }
            
            cell.setPerson(ID: person)
            return cell
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person: String
        if (isFiltering()) {
            person = filteredPeople[indexPath.row]
        }
        else {
            person = people[indexPath.row]
        }
        
        let numControllers = navigationController?.viewControllers.count
        let controller = navigationController?.viewControllers[numControllers! - 2]
        if let c = controller as? ItemTableViewController {
            print("adding sharer " + PersonManager.instance.GetName(ID: person))
            c.addSharer(ID: person)
        }
        
        navigationController?.popViewController(animated: true)
        
        //...
    }
    
    // MARK: - Segues
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetail" {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let person = candies[indexPath.row]
//                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.detailCandy = candy
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
//        }
//    }
}

extension PersonSelectionViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
