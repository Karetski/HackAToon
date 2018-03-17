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

        setupNavigationBar()
        title = "Populars"
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let placeDetailsController = PlaceDetailsViewController()
//        navigationController?.pushViewController(placeDetailsController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupNavigationBar() {
        let locationSearchTable = ResultSearchController(nibName: "ResultSearchController", bundle: nil)

        searchResultController = UISearchController(searchResultsController: locationSearchTable)
        searchResultController?.searchResultsUpdater = locationSearchTable
        navigationItem.titleView = searchResultController?.searchBar
        searchResultController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
