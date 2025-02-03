import UIKit
final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    //MARK: - IBOutlets
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Variables
    
    private var correctAnswers = 0
    private var questionFactory: QuestionFactoryProtocol!
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticServiceProtocol!
    private let presenter = MovieQuizPresenter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        super.viewDidLoad()
        print(Bundle.main.bundlePath)
        
        activityIndicator.hidesWhenStopped = true
        
        statisticService = StatisticService()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        
        activityIndicator.startAnimating()
        questionFactory.loadData()
    }
    
    //MARK: -QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.stopAnimating()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func didFailToLoadImage(for movie: MostPopularMovie) {
        showNetworkError(message: "Не удалось загрузить изображение для фильма \(movie.title). Пожалуйста, попробуйте еще раз")
    }
    
    //MARK: - IBActions
    @IBAction private func yesButtonClicked(_ sender: Any) {
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    //MARK: - PrivateFunctions
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        activityIndicator.stopAnimating()
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        resetBorder()
        yesButton.isEnabled = true
        noButton.isEnabled = true
        
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        
        if presenter.isLastQuestion() {
            
            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
            
            let message = """
            Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))
            Луший результат: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) \(statisticService.bestGame.date.dateTimeString)
            """
            
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: message,
                buttonText: "Сыграть еще раз",
                completion: { [weak self] in
                    self?.restartQuiz()
                }
            )
            AlertPresenter.showAlert(on: self, with: alertModel)
        } else {
            activityIndicator.startAnimating()
            presenter.switchToNextQuestion()
            questionFactory.requestNextQuestion()
        }
    }
    private func restartQuiz() {
        presenter.resetQuestionIndex()
        correctAnswers = 0
        questionFactory.requestNextQuestion()
    }
    
    private func resetBorder() {
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
    }
    
    private func showNetworkError(message: String) {
        activityIndicator.stopAnimating()
        
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз") { [weak self] in
                guard let self = self else { return }
                
                self.presenter.resetQuestionIndex()
                self.correctAnswers = 0
                
                questionFactory.loadData()
            }
        AlertPresenter.showAlert(on: self, with: alertModel)
    }
}
