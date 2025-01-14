//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Ivan Kuninets on 1/9/25.
//

import Foundation
import UIKit

class AlertPresenter {
    static func showAlert(on viewController: UIViewController, with model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.massage,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
}
