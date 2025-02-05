import UIKit
final class MovieQuizViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Variables
    private var statisticService: StatisticServiceProtocol!
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        super.viewDidLoad()
        print(Bundle.main.bundlePath)
        
        activityIndicator.hidesWhenStopped = true
        
        presenter = MovieQuizPresenter(viewController: self)
        
        statisticService = StatisticService()
        
        
        activityIndicator.startAnimating()
    }
    

    func showNextQuestionOrResults() {
        presenter.showNextQuestionOrResults()
    }
    
    //MARK: - IBActions
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
    }
    
    //MARK: - PrivateFunctions
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
        yesButton.isEnabled = true
        noButton.isEnabled = true
        activityIndicator.stopAnimating()
    }
    
    func show(quiz result: QuizResultsViewModel) {
        
        var message = result.text
        if let statisticService = statisticService {
            statisticService.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)
            
            let bestGame = statisticService.bestGame
            
            let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
            let currentGameResultLine = "Ваш результат: \(presenter.correctAnswers)\\\(presenter.questionsAmount)"
            let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
            + " (\(bestGame.date.dateTimeString))"
            let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            let resultMessage = [
                currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
            ].joined(separator: "\n")
            
            message = resultMessage
        }
        
        let model = AlertModel(title: result.title, message: message, buttonText: result.buttonText) { [weak self] in
            guard let self = self else { return }
            
            self.presenter.restartGame()
            
        }
        
        AlertPresenter.showAlert(on: self, with: model)
    }
    
    func showAnswerResult(isCorrect: Bool) {
        presenter.didAnswer(isCorrectAnswer: isCorrect)
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.showNextQuestionOrResults()
        }
    }
    
     func showNetworkError(message: String) {
        activityIndicator.stopAnimating()
        
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз") { [weak self] in
                guard let self = self else { return }
                
                self.presenter.restartGame()
                
            }
        AlertPresenter.showAlert(on: self, with: alertModel)
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
}

