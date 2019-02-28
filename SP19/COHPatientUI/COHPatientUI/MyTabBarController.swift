//
//  MyTabBarController.swift
//  COHPatientUI
//
//  Created by Darien Joso on 2/26/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if viewController is HomeScreenViewController {
            print("Home")
        } else if viewController is ExerciseViewController {
            print("Exercise")
        } else if viewController is GoalsViewController {
            print("Goals")
        } else if viewController is ProgressViewController {
            print("Progress")
        } else if viewController is QualityViewController {
            print("Quality")
        }
    }
    
}
