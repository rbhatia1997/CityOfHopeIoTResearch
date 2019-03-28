//
//  PresetData.swift
//  PatientApp
//
//  Created by Darien Joso on 3/26/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

// Exercise
let presetExerciseList = ["Front Arm Raise",
                          "Side Arm Raise",
                          "Medicine Ball Overhead Circles",
                          "Arnold Shoulder Press",
                          "Dumbell Shoulder Press"]

// Exercise Session Statistics
struct ExerciseStatsStruct {
    var rangeOfMotion: Float
    var repetitions: Int16
    var exercise: Exercise
}

let presetExerciseStats = [ExerciseStatsStruct(rangeOfMotion: 15.5, repetitions: 2, exercise: Exercise(context: context))]

// Goals
let presetGoalList = ["Cook for my kids",
                      "Put on makeup by myself",
                      "Tie up my hair",
                      "Shower by myself",
                      "Drive myself to work"]

// Wellness Question
struct WellnessQuestionStruct {
    let question: String
    let isSlider: Bool
}

let presetWellnessQuestionList =
    [WellnessQuestionStruct(question: "Do you have pain?"                                       , isSlider: true),
     WellnessQuestionStruct(question: "Do you have tightness?"                                  , isSlider: true),
     WellnessQuestionStruct(question: "Do you have anxiety pain?"                               , isSlider: true),
     WellnessQuestionStruct(question: "Can you put on your shirt without assistance?"           , isSlider: false),
     WellnessQuestionStruct(question: "Can you put on your pants without assistance?"           , isSlider: false),
     WellnessQuestionStruct(question: "Can you comb your hair without assistance?"              , isSlider: false),
     WellnessQuestionStruct(question: "Can you shower without assistance?"                      , isSlider: false),
     WellnessQuestionStruct(question: "Can you use the toilet without assistance?"              , isSlider: false),
     WellnessQuestionStruct(question: "Can you perform light cooking without assistance?"       , isSlider: false),
     WellnessQuestionStruct(question: "Can you perform light house cleaning without assistance?", isSlider: false)]

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

// Wellness Response
