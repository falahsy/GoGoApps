//
//  SearchActivityVC.swift
//  cycle
//
//  Created by Azmi Muhammad on 21/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit
import MapKit

protocol SearchActivityDelegate: AnyObject {
    func dropActivity(activity: Activity)
    func cancelActivity()
}

class SearchActivityVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    weak var delegate: SearchActivityDelegate?
    var handleActivitySearchDelegate: HandleActivitySearch? = nil
    var matchingItems: [Activity] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
    }

}

extension SearchActivityVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegate?.cancelActivity()
    }
}

extension SearchActivityVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let selectedItem = matchingItems[indexPath.row]
        cell.textLabel?.text = selectedItem.activityID
        //cell.detailTextLabel?.text = ""
        cell.detailTextLabel?.text = selectedItem.activityID
        return cell
    }
}

extension SearchActivityVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        
        let kegiatan = Activity()
        
        kegiatan.searchActivity(activityID: searchBarText.uppercased()) { (activities) in
            
            self.matchingItems = activities
            print("\(activities)-\(searchBarText)")
            self.tableView.reloadData()
        }
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if !searchController.isActive {
            print("Cancelled")
        }
        
    }
}

