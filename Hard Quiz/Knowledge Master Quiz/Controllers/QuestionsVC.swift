//
//  QuestionsVC.swift
//  Knowledge Master Quiz
//
//  Created by Nitish Mishra on 5/20/19.
//  Copyright © 2019 Nitish Mishra. All rights reserved.
//

import UIKit

class QuestionsVC: CustomTransitionViewController {
  
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet var answerButtons: [UIButton]!
  
  lazy var slideInTransitioningDelegate = SlideInPresentationManager()
  
  let questionBank = QuestionBank()
  var questions = [Question]()
  var currentQuestionIndex = 0
  var score = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .always
    questions = questionBank.questions.shuffled()
    questions = Array(questions[0..<20])
    setupButtons()
    displayQuestion()
  }
  
  private func setupButtons() {
    answerButtons.forEach { (btn) in
      btn.layer.borderWidth = 2
      btn.layer.borderColor = #colorLiteral(red: 0.6241140366, green: 0.7450509667, blue: 0.7880838513, alpha: 1)
      btn.layer.cornerRadius = 8
    }
  }
  
  @IBAction func answerPressed(_ sender: UIButton) {
    if let answer = sender.titleLabel?.text {
      checkAnswer(answer: answer)
    }
  }

  private func displayQuestion(index: Int = 0) {
    updateTitle(currentQuestion: index + 1)
    let question = questions[index]
    let questionBody = question.question?.htmlDecoded()
    questionLabel.text = questionBody
    if let answersCount = question.incorrectAnswers?.count, let wrongAnswers = question.incorrectAnswers, let correct = question.correctAnswer {
      var answers = wrongAnswers
      answers.append(correct)
      answers = answers.shuffled()
      for i in 0...answersCount {
        let answer = answers[i].htmlDecoded()
        answerButtons[i].setTitle("  \(answer)", for: .normal)
      }
    }
  }
  
  private func checkAnswer(answer: String) {
    let question = questions[currentQuestionIndex]
    if let correct = question.correctAnswer?.htmlDecoded() {
      if "  \(correct)" == answer {
        score += 1
      }
      highlightCorrectAnswer(answer: answer, correct: "  \(correct)")
    }
  }
  
  private func highlightCorrectAnswer(answer: String, correct: String) {
    if answer == correct {
      let button = getButtonFromAnswer(answer: correct)
      highlightButton(button: button, correct: true)
    } else {
      let correctButton = getButtonFromAnswer(answer: correct)
      let wrongButton = getButtonFromAnswer(answer: answer)
      highlightButton(button: correctButton, correct: true)
      highlightButton(button: wrongButton, correct: false)
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
      self?.nextQuestion()
    }
  }
  
  private func getButtonFromAnswer(answer: String) -> UIButton? {
    for btn in answerButtons {
      if btn.titleLabel?.text == answer {
        return btn
      }
    }
    return nil
  }
  
  private func highlightButton(button: UIButton?, correct: Bool) {
    button?.layer.borderColor = correct ? #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) : #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
  }
  
  private func returnButtonsToNormal() {
    answerButtons.forEach { (btn) in
      btn.layer.borderColor = #colorLiteral(red: 0.6241140366, green: 0.7450509667, blue: 0.7880838513, alpha: 1)
    }
  }
  
  private func nextQuestion() {
    returnButtonsToNormal()
    guard currentQuestionIndex + 1 < questions.count else {
      performSegue(withIdentifier: "showScore", sender: nil)
      return
    }
    currentQuestionIndex += 1
    displayQuestion(index: currentQuestionIndex)
  }
  
  private func startOver() {
    currentQuestionIndex = 0
    score = 0
    questions = questionBank.questions.shuffled()
    questions = Array(questions[0..<20])
    displayQuestion()
  }
  
  private func updateTitle(currentQuestion: Int) {
    navigationItem.title = "\(currentQuestion) of \(questions.count)"
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let dest = segue.destination as? ScoreVC {
      slideInTransitioningDelegate.direction = .bottom
      slideInTransitioningDelegate.height = view.frame.height * 0.7
      dest.transitioningDelegate = slideInTransitioningDelegate
      dest.modalPresentationStyle = .custom
      dest.score = score
      dest.delegate = self
    }
  }
}



extension QuestionsVC: ScoreVCDelegate {
  
  func didPressHome() {
    navigationController?.popViewController(animated: false)
  }
  
  func didPressAgain() {
    startOver()
  }
  
}
