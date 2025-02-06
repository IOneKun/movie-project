//
//  MovieQuizViewControllerProtocol .swift
//  MovieQuiz
//
//  Created by Ivan Kuninets on 2/5/25.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showNetworkError(message: String)
    func startActivityIndicator()
    func stopActivityIndicator()
    
}
