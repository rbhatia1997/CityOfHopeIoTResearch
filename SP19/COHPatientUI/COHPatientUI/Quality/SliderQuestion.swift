//
//  SliderQuestion.swift
//  COHPatientUI
//
//  Created by Darien Joso on 3/4/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class SliderQuestion: UIView {
    
    let yesButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let noButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    func createSliderQuestion(questionString: String, slider: Bool) {
        let question = UILabel()
        question.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        question.font = UIFont(name: "MontserratAlternates-Regular", size: 16)
        question.textColor = .gray
        question.text = questionString
        question.numberOfLines = 0
        question.sizeToFit()
        self.addSubview(question)
        
        if slider {
            let intensity = UILabel()
            intensity.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            intensity.font = UIFont(name: "Montserrat-Regular", size: 14)
            intensity.textColor = .gray
            intensity.text = "Intensity:"
            intensity.sizeToFit()
            intensity.center.x = 50
            intensity.center.y = 60
            self.addSubview(intensity)
            
            drawSlider(centerX: self.center.x, centerY: 100)
            
            let label1 = UILabel()
            label1.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            label1.font = UIFont(name: "Montserrat-Regular", size: 14)
            label1.textColor = .gray
            label1.text = "1"
            label1.sizeToFit()
            label1.center.x = self.center.x - 125
            label1.center.y = 130
            self.addSubview(label1)
            
            let label5 = UILabel()
            label5.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            label5.font = UIFont(name: "Montserrat-Regular", size: 14)
            label5.textColor = .gray
            label5.text = "5"
            label5.sizeToFit()
            label5.center.x = self.frame.width/2
            label5.center.y = 130
            self.addSubview(label5)
            
            let label10 = UILabel()
            label10.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            label10.font = UIFont(name: "Montserrat-Regular", size: 14)
            label10.textColor = .gray
            label10.text = "10"
            label10.sizeToFit()
            label10.center.x = self.frame.width/2 + 125
            label10.center.y = 130
            self.addSubview(label10)
        }
//        createOutline()
    }

    func drawSlider(centerX: CGFloat, centerY: CGFloat) {

        let slider = UISlider()
        slider.frame = CGRect(x: 0, y: 0, width: 250, height: 35)
        slider.center.x = centerX
        slider.center.y = centerY
        
        slider.minimumTrackTintColor = hsbShadeTint(color: UIColor(named: "purple")!, sat: 0.3)
        slider.maximumTrackTintColor = nil
        slider.thumbTintColor = nil
        
        slider.maximumValue = 10
        slider.minimumValue = 0
        slider.setValue(5, animated: false)
        
        slider.addTarget(self, action: #selector(printSliderValue), for: .valueChanged)
        
        self.addSubview(slider)
    }
    
    @objc func printSliderValue(_ sender: UISlider) {
        let sliderValue: Float = Float(sender.value.rounded(.up))
        sender.setValue(sliderValue, animated: false)
    }
    
    func createOutline() {
        let screen = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let screenPath = UIBezierPath(roundedRect: screen, cornerRadius: 10)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = screenPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 1.0
        self.layer.addSublayer(shapeLayer)
    }
    
    func customYNButtonPair(color: UIColor) {
        
        yesButton.setTitle("Yes", for: .normal)
        yesButton.setTitleColor(.gray, for: .normal)
        yesButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14.0)
        yesButton.sizeToFit()
        yesButton.titleLabel?.textAlignment = .center
        yesButton.center.x = self.frame.width - 70
        yesButton.center.y = 14
        
        noButton.setTitle("No", for: .normal)
        noButton.setTitleColor(.gray, for: .normal)
        noButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14.0)
        noButton.sizeToFit()
        noButton.titleLabel?.textAlignment = .center
        noButton.center.x = self.frame.width - 20
        noButton.center.y = 14
        
        self.addSubview(yesButton)
        self.addSubview(noButton)
        
        let yscreen = CGRect(x: yesButton.center.x - 20, y: yesButton.center.y - 12.5, width: 40, height: 25)
        let yscreenPath = UIBezierPath.init(roundedRect: yscreen, cornerRadius: 5)
        let yshapeLayer = CAShapeLayer()
        yshapeLayer.path = yscreenPath.cgPath
        yshapeLayer.fillColor = UIColor.clear.cgColor
        yshapeLayer.strokeColor = UIColor.gray.cgColor
        yshapeLayer.lineWidth = 1.0
        self.layer.addSublayer(yshapeLayer)
        
        let nscreen = CGRect(x: noButton.center.x - 20, y: noButton.center.y - 12.5, width: 40, height: 25)
        let nscreenPath = UIBezierPath.init(roundedRect: nscreen, cornerRadius: 5)
        let nshapeLayer = CAShapeLayer()
        nshapeLayer.path = nscreenPath.cgPath
        nshapeLayer.fillColor = UIColor.clear.cgColor
        nshapeLayer.strokeColor = UIColor.gray.cgColor
        nshapeLayer.lineWidth = 1.0
        self.layer.addSublayer(nshapeLayer)
    }
    
    func wipe() {
        let screen = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let screenPath = UIBezierPath(rect: screen)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = screenPath.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1.0
        self.layer.addSublayer(shapeLayer)
    }
}
