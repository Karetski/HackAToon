//
//  ResultSearchController.swift
//  HackAToon
//
//  Created by Andrei Rybak on 3/17/18.
//  Copyright © 2018 Karetski. All rights reserved.
//

import UIKit
import MapKit

protocol SearchResultDelegate: class {
    func scrollTo(coordinate: CLLocationCoordinate2D)
}

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
    weak var delegate: SearchResultDelegate?
    private var matchingItems: [MKMapItem] = []

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        matchingItems.removeAll()
    }
}

extension ResultSearchController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}

extension ResultSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItemCoordiinate = matchingItems[indexPath.row].placemark.coordinate
        dismiss(animated: true) { [weak self] in
            self?.delegate?.scrollTo(coordinate: selectedItemCoordiinate)
        }
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
