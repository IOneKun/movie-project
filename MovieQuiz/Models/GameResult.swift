//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Ivan Kuninets on 1/12/25.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterGameResult(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
