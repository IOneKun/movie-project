//
//  QuestionFactory .swift
//  MovieQuiz
//
//  Created by Ivan Kuninets on 1/4/25.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    
    
    private let moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    private var movies: [MostPopularMovie] = []
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
            /* private let questions: [QuizQuestion] = [
             QuizQuestion(image: "The Godfather",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true),
             QuizQuestion(image: "The Dark Knight",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true),
             QuizQuestion(image: "Kill Bill",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true),
             QuizQuestion(image: "The Avengers",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true),
             QuizQuestion(image: "Deadpool",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true),
             QuizQuestion(image: "The Green Knight",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true),
             QuizQuestion(image: "Old",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: false),
             QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: false),
             QuizQuestion(image: "Tesla",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: false),
             QuizQuestion(image: "Vivarium",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: false)
             ]
             
             
             func setup(delegate: QuestionFactoryDelegate) {
             self.delegate = delegate
             }
             func requestNextQuestion() {
             guard let index = (0..<movies.count).randomElement() else {
             delegate?.didReceiveNextQuestion(question: nil)
             return
             }
             let question = movies[safe: index]
             delegate?.didReceiveNextQuestion(question: question)
             }
             */
        }
    }
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.imageURL)
                
                if imageData.isEmpty {
                    DispatchQueue.main.async { [weak self] in
                        self?.delegate?.didFailToLoadImage(for: movie)
                    }
                    return
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didFailToLoadImage(for: movie)
                    print("Failed to load image")
                }
                return
            }
            
            let operators = ["больше", "меньше"]
            let randomOperator = operators.randomElement() ?? ">"
            let randomRating = Float.random(in: 7.9...9.3)
            var correctAnswer = false
            let rating = Float(movie.rating) ?? 0
            
            switch randomOperator {
            case "больше":
                correctAnswer = rating > randomRating
            case "меньше":
                correctAnswer = rating < randomRating
            default:
                break
            }
            
            let text = "Рейтинг этого фильма \(randomOperator) чем \(String(format: "%.1f", randomRating))?"
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                assert(Thread.isMainThread, "UI not on main Thread!")
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}

