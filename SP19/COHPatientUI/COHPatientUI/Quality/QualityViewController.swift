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
    var questionList: [String] = ["Do you have pain?",
                                  "Do you have tightness?",
                                  "Do you have anxiety pain?",
                                  "Can you put on your shirt \nwithout assistance?",
                                  "Can you put on your pants \nwithout assistance?",
                                  "Can you comb your hair \nwithout assistance?",
                                  "Can you shower without \nassistance?",
                                  "Can you use the toilet \nwithout assistance?",
                                  "Can you cook without \nassistance?",
                                  "Can you clean the house \nwithout assistance?"]

    @IBOutlet weak var question0: SliderQuestion!
    @IBOutlet weak var question1: SliderQuestion!
    @IBOutlet weak var question2: SliderQuestion!
    @IBOutlet weak var question3: SliderQuestion!
    @IBOutlet weak var question4: SliderQuestion!
    @IBOutlet weak var question5: SliderQuestion!
    @IBOutlet weak var question6: SliderQuestion!
    @IBOutlet weak var question7: SliderQuestion!
    @IBOutlet weak var question8: SliderQuestion!
    @IBOutlet weak var question9: SliderQuestion!
    
    var questions = [SliderQuestion]()
    
    let colorTheme: UIColor = UIColor(named: "purple") ?? .clear
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questions.append(question0)
        questions.append(question1)
        questions.append(question2)
        questions.append(question3)
        questions.append(question4)
        questions.append(question5)
        questions.append(question6)
        questions.append(question7)
        questions.append(question8)
        questions.append(question9)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for i in 0..<questionList.count {
            questions[i].wipe()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        headerView.setHeader(text: "Check myself", color: colorTheme)
        for i in 0..<questionList.count {
            if i < 3 {
                questions[i].createSliderQuestion(questionString: "\(i+1). \(questionList[i])", slider: true)
            } else {
                questions[i].createSliderQuestion(questionString: "\(i+1). \(questionList[i])", slider: false)
            }
            questions[i].customYNButtonPair(color: hsbShadeTint(color: colorTheme, sat: 0.3))
        }
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
