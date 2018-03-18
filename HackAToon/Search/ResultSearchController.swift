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

struct SearchedItem {
    var name: String
    var id: String
}

class ResultSearchController: UIViewController {

    private struct Constants {
        static let identifer = "cell"
        static let googleApiKey = "AIzaSyCaabI3hM-sVFeRkLSHYgHu192T4Ix_w_M"
    }

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.identifer)
        }
    }
    weak var delegate: SearchResultDelegate?
    fileprivate var matchingItems: [SearchedItem] = []

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        matchingItems.removeAll()
    }
}

extension ResultSearchController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }


        guard let url = URL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=" + searchBarText + "&types=geocode&language=en&key=AIzaSyAtfg67quLwumlmpsENnm6rAzkODQywwvg") else {
            return
        }

        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            guard let data = data, error == nil else { return }

            var responseDict: [String: Any] = [:]
            do {
                responseDict = (try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])!
            } catch {
                print(error.localizedDescription)
            }

            guard let predictions = responseDict["predictions"] as? [[String: Any]] else {
                return
            }

            let items = predictions.map({ (prediction) -> SearchedItem in
                return SearchedItem(name: prediction["description"] as! String, id: prediction["place_id"] as! String)
            })

            guard items.count > 0 else {
                return
            }

            strongSelf.matchingItems = items
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }.resume()
    }
}

extension ResultSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let placeId = self.matchingItems[indexPath.row].id

        guard let url = URL(string: "https://maps.googleapis.com/maps/api/geocode/json?place_id=" + placeId + "&key=" + Constants.googleApiKey) else {
            return
        }
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            guard let data = data, error == nil else { return }

            var responseDict: [String: Any] = [:]
            do {
                responseDict = (try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])!
            } catch {
                print(error.localizedDescription)
            }
            guard let results = responseDict["results"] as? [[String: Any]] else {
                return
            }

            guard let geometry = results.first!["geometry"] as? [String: Any] else {
                return
            }

            guard let location = geometry["location"] as? [String: Any] else {
                return
            }

            guard let lat = location["lat"] as? Double, let lng = location["lng"] as? Double else {
                return
            }

            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)

            DispatchQueue.main.async {
                strongSelf.dismiss(animated: true) { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.delegate?.scrollTo(coordinate: coordinate)
                }
            }
        }.resume()
    }
}

extension ResultSearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifer) else {
            return UITableViewCell()
        }

        cell.textLabel?.text = matchingItems[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
}
