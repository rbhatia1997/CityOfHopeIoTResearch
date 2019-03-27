//
//  FullProgressViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/12/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class ProgressCompViewController: UIViewController, ViewConstraintProtocol {
    
    internal func setupViews() {
        
    }
    
    internal func setupConstraints() {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc func returnButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toProgressVC", sender: sender)
    }

}
