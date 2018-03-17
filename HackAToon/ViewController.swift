//
//  ViewController.swift
//  HackAToon
//
//  Created by Alexey Karetski on 3/17/18.
//  Copyright © 2018 Karetski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getStartedButtonTouchUpInside(_ sender: UIButton) {
        let mapController = MapViewController()
        let navigationController = UINavigationController(rootViewController: mapController)
        navigationController.modalTransitionStyle = .flipHorizontal
        present(navigationController, animated: true, completion: nil)
    }
}

