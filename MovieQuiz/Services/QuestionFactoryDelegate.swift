//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Ivan Kuninets on 1/8/25.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
