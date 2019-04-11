//
//  PresetData.swift
//  PatientApp
//
//  Created by Darien Joso on 3/26/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

// Exercise
struct ExerciseStruct {
    var name: String
    var icon: String
    var image: String
    var use: Bool
    var detection: String
}

let presetExerciseList =
    [ExerciseStruct(name: "Front Arm Raise", icon: "frontArmRaise", image: "frontArmRaise-img", use: true, detection: "pitch"),
     ExerciseStruct(name: "Side Arm Raise", icon: "sideArmRaise", image: "sideArmRaise-img", use: true, detection: "roll"),
     ExerciseStruct(name: "Medicine Ball Overhead Circles", icon: "medicineBallOverheadCircles", image: "medicineBallOverheadCircles-img", use: false, detection: "none"),
     ExerciseStruct(name: "Arnold Shoulder Press", icon: "arnoldShoulderPress", image: "arnoldShoulderPress-img", use: false, detection: "none"),
     ExerciseStruct(name: "Dumbell Shoulder Press", icon: "dumbellShoulderPress", image: "dumbellShoulderPress-img", use: false, detection: "none")]

// Goals
let presetGoalList = ["Cook for my kids",
                      "Put on makeup by myself",
                      "Tie up my hair",
                      "Shower by myself",
                      "Drive myself to work"]

// Wellness Question
struct QuestionStruct {
    let text: String
    let bool: Bool
}

let presetQuestionList =
    [QuestionStruct(text: "Do you have pain?", bool: true),
     QuestionStruct(text: "Do you have tightness?", bool: true),
     QuestionStruct(text: "Do you have anxiety pain?", bool: true),
     QuestionStruct(text: "Can you put on your shirt without assistance?", bool: false),
     QuestionStruct(text: "Can you put on your pants without assistance?", bool: false),
     QuestionStruct(text: "Can you comb your hair without assistance?", bool: false),
     QuestionStruct(text: "Can you shower without assistance?", bool: false),
     QuestionStruct(text: "Can you use the toilet without assistance?", bool: false),
     QuestionStruct(text: "Can you perform light cooking without assistance?", bool: false),
     QuestionStruct(text: "Can you perform light house cleaning without assistance?", bool: false)]

//let presetQuestionStringList = ["Do you have pain?",
//                                "Do you have tightness?",
//                                "Do you have anxiety pain?",
//                                "Can you put on your shirt without assistance?",
//                                "Can you put on your pants without assistance?",
//                                "Can you comb your hair without assistance?",
//                                "Can you shower without assistance?",
//                                "Can you use the toilet without assistance?",
//                                "Can you perform light cooking without assistance?",
//                                "Can you perform light house cleaning without assistance?"]
//
//let presetQuestionSliderList = [true, true, true, false, false, false, false, false, false, false]
//
//let presetExerciseIconStringList = ["frontArmRaise", "sideArmRaise", "medicineBallOverheadCircles", "arnoldShoulderPress", "dumbellShoulderPress"]
//let presetExerciseImageStringList = ["frontArmRaise-img", "sideArmRaise-img", "medicineBallOverheadCircles-img", "arnoldShoulderPress-img", "dumbellShoulderPress-img"]
