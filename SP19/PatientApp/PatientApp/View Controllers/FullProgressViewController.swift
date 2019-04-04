//
//  FullProgressViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/12/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class FullProgressViewController: UIViewController, ViewConstraintProtocol {
    
    internal func setupViews() {
        
    }
    
    internal func setupConstraints() {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func returnButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toProgressVC", sender: sender)
    }

}
