//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Ivan Kuninets on 1/12/25.
//

import Foundation

final class StatisticService {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case correctAnswers
        case gamesCount
        case bestGame
        case bestGameTotal
        case bestGameDate
    }
}
extension StatisticService: StatisticServiceProtocol {
    
    private var correctAnswers: Int {
        get {
            return storage.integer(forKey: Keys.correctAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correctAnswers.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGame.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            if let savedDate = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date {
                return GameResult(correct: correct, total: total, date: savedDate)
            } else {
                return GameResult(correct: correct, total: total, date: Date())
            }
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGame.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            guard gamesCount > 0 else {
                return 0.0
            }
            return (Double(correctAnswers) / (Double(gamesCount) * 10)) * 100
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        correctAnswers += count
        
        let currentGameResult = GameResult(correct: count, total: amount, date: Date())
        if currentGameResult.isBetterGameResult(bestGame) {
            bestGame = currentGameResult
        }
    }
}
