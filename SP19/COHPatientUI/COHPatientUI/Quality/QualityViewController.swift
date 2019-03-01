//
//  QualityViewController.swift
//  COHPatientUI
//
//  Created by Darien Joso on 2/26/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class QualityViewController: UIViewController {

    @IBOutlet weak var headerView: Header!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        headerView.setHeader(text: "Check myself", color: UIColor(named: "purple") ?? .clear)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
