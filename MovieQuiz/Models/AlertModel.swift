//
//  AlertModel .swift
//  MovieQuiz
//
//  Created by Ivan Kuninets on 1/9/25.
//

import Foundation

struct AlertModel {
    let title: String
    let massage: String
    let buttonText: String
    let completion: () -> Void
}
