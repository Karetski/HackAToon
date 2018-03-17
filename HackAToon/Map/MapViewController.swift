//
//  MapViewController.swift
//  HackAToon
//
//  Created by Alexey Karetski on 3/17/18.
//  Copyright © 2018 Karetski. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    private var searchResultController: UISearchController?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchBar()
        title = "Popular Places"
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let placeDetailsController = PlaceDetailsViewController()
//        navigationController?.pushViewController(placeDetailsController, animated: true)
    }

    private func setupSearchBar() {
        let locationSearchTable = ResultSearchController(nibName: "ResultSearchController", bundle: nil)
        locationSearchTable.delegate = self
        searchResultController = UISearchController(searchResultsController: locationSearchTable)
        searchResultController?.searchResultsUpdater = locationSearchTable
        searchResultController?.delegate = self
        navigationItem.titleView = searchResultController?.searchBar
        searchResultController?.hidesNavigationBarDuringPresentation = false
        searchResultController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
}

extension MapViewController: SearchResultDelegate {
    func scrollTo(coordinate: CLLocationCoordinate2D) {
        //TODO: Do your logic here
    }
}

extension MapViewController: UISearchControllerDelegate {
    func willDismissSearchController(_ searchController: UISearchController) {

    }
}
