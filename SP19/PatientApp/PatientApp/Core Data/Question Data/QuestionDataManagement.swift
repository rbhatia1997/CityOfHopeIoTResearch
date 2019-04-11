//
//  QuestionDataManagement.swift
//  PatientApp
//
//  Created by Darien Joso on 4/4/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit
import CoreData

// MARK: Question Data Management
var questions = [Question]()

func getQuestionData(_ sort: [NSSortDescriptor]) -> [Question] {
    let fetchRequest: NSFetchRequest<Question> = Question.fetchRequest()
    fetchRequest.sortDescriptors = sort
    
    do {
        let questionArr = try context.fetch(fetchRequest)
        print("Fetched question data successfully")
        return questionArr
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    
    return []
}

func reloadQuestionData() {
    questions = getQuestionData( [NSSortDescriptor(key: #keyPath(Question.id), ascending: true)] )
}

func reloadQuestionData(_ sort: [NSSortDescriptor]) {
    questions = getQuestionData(sort)
}

func addQuestionData(id: String, text: String, bool: Bool) {
    let question = Question(context: context)
    question.id = id
    question.text = text
    question.bool = bool
    question.response = Set<Response>()
    
    do {
        try context.save()
        print("Question saved")
    } catch {
        print("Failed saving")
    }
}

func deleteQuestionData(_ index: Int) {
    let sortByID = NSSortDescriptor(key: #keyPath(Question.id), ascending: true)
    let fetchRequest: NSFetchRequest<Question> = Question.fetchRequest()
    fetchRequest.sortDescriptors = [sortByID]
    fetchRequest.includesPropertyValues = false
    
    do {
        let items = try context.fetch(fetchRequest)
        if items.count > index {
            context.delete(items[index])
        }
        try context.save()
        print("Deleted question data successfully")
    } catch {
        print("Failed saving")
    }
}

func clearQuestionData() {
    let fetchRequest: NSFetchRequest<Question> = Question.fetchRequest()
    fetchRequest.includesPropertyValues = false
    
    do {
        let items = try context.fetch(fetchRequest)
        if items.count > 0 {
            for index in 0..<items.count {
                context.delete(items[index])
            }
            try context.save()
        }
        print("Cleared question data successfully")
    } catch {
        print("Failed saving")
    }
}
