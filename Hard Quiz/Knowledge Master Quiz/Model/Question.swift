//
//  Question.swift
//  Knowledge Master Quiz
//
//  Created by Nitish Mishra on 5/20/19.
//  Copyright © 2019 Nitish Mishra. All rights reserved.
//

import Foundation
  
struct Question : Codable {
  
  let category : String?
  let correctAnswer : String?
  let difficulty : String?
  let incorrectAnswers : [String]?
  let question : String?
  let type : String?
  
  enum CodingKeys: String, CodingKey {
    case category = "category"
    case correctAnswer = "correct_answer"
    case difficulty = "difficulty"
    case incorrectAnswers = "incorrect_answers"
    case question = "question"
    case type = "type"
  }
  
}
