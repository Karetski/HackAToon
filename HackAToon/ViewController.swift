//
//  ViewController.swift
//  HackAToon
//
//  Created by Alexey Karetski on 3/17/18.
//  Copyright © 2018 Karetski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getStartedButton.layer.cornerRadius = 8.0
    }
    
    @IBAction func getStartedButtonTouchUpInside(_ sender: UIButton) {
        let mapController = MapViewController()
        let navigationController = UINavigationController(rootViewController: mapController)
        navigationController.modalTransitionStyle = .flipHorizontal
        present(navigationController, animated: true, completion: nil)
    }
}

