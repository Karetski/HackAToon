//
//  PlaceDetailsViewController.swift
//  HackAToon
//
//  Created by Alexey Karetski on 3/17/18.
//  Copyright © 2018 Karetski. All rights reserved.
//

import UIKit
import Kingfisher
import Cosmos

struct PlaceDetails {
    let imageLink: String
    let title: String
    let subtitle: String
    let rating: Float
}

class PlaceDetailsViewController: UIViewController {

    var placeIdentifier: String = "788029" // Default is Eiffel Tower, Paris

    @IBOutlet private weak var previewImage: UIImageView!

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var ratingView: CosmosView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        let placeDetails = PlaceDetails(
            imageLink: "https://raw.githubusercontent.com/evgenyneu/Cosmos/master/graphics/Screenshots/cosmos_ios_view_control_attributes_inspector.png",
            title: "Sacramento Zoo",
            subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            rating: 2.5
        )

        update(with: placeDetails)
    }

    // MARK: - Setup

    func setupNavigationBar() {
        let goToInstagramIcon = #imageLiteral(resourceName: "GoToInstagram").withRenderingMode(.alwaysTemplate)
        let goToInstagramButton = UIBarButtonItem(
            image: goToInstagramIcon,
            style: .plain,
            target: self,
            action: #selector(goToInstagramAction(_:))
        )
        navigationItem.rightBarButtonItem = goToInstagramButton
    }

    // MARK: - Update

    func update(with placeDetails: PlaceDetails) {
        if let url = URL(string: placeDetails.imageLink) {
            previewImage.kf.setImage(with: url)
        }

        titleLabel.text = placeDetails.title
        subtitleLabel.text = placeDetails.subtitle
        ratingLabel.text = String(placeDetails.rating)
        ratingView.rating = Double(placeDetails.rating)
    }

    // MARK: - Button actions

    @objc func goToInstagramAction(_ sender: UIBarButtonItem) {
        guard let url = URL(string: "instagram://location?id=" + placeIdentifier),
            UIApplication.shared.canOpenURL(url) else {
                let alertController = UIAlertController(
                    title: "Failed",
                    message: "Instagram is not installed on your device!",
                    preferredStyle: .alert
                )
                alertController.addAction(
                    UIAlertAction(title: "OK", style: .cancel)
                )
                navigationController?.present(
                    alertController,
                    animated: true
                )
                return
        }
        UIApplication.shared.open(url)
    }
}
