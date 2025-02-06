//
//  MovieQuizUITests2_0.swift
//  MovieQuizUITests2.0
//
//  Created by Ivan Kuninets on 2/5/25.
//

import XCTest
@testable import MovieQuiz

class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    
 
    func show(quiz step: QuizStepViewModel) {
    }
    func show(quiz result: QuizResultsViewModel) {
    }
    func highlightImageBorder(isCorrectAnswer: Bool) {
    }
    func showNetworkError(message: String) {
    }
    func startActivityIndicator() {
    }
    func stopActivityIndicator() {
    }
}

class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "QuestionText", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "QuestionText")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
        
    }
}

