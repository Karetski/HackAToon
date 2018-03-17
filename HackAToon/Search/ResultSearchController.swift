//
//  ResultSearchController.swift
//  HackAToon
//
//  Created by Andrei Rybak on 3/17/18.
//  Copyright © 2018 Karetski. All rights reserved.
//

import UIKit
import MapKit

class ResultSearchController: UIViewController {

    private struct Constants {
        static let identifer = "cell"
    }

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.identifer)
        }
    }
    var matchingItems: [MKMapItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.reloadData()
    }
}

extension ResultSearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else {
                return
        }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText

        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, _ in
            guard let response = response, let `self` = self else {
                return
            }
            self.matchingItems += response.mapItems
            self.tableView.reloadData()
        }
    }
}

extension ResultSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Notify delegate
        
    }
}

extension ResultSearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifer) else {
            return UITableViewCell()
        }
        cell.textLabel?.text = matchingItems[indexPath.row].placemark.name
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
}
