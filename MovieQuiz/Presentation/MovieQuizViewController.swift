import UIKit
final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
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
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount = 10
    private var questionFactory: QuestionFactory = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        super.viewDidLoad()
        
        if let firstQuestion = questionFactory.requestNextQuestion() {
            currentQuestion = firstQuestion
            let viewModel = convert(model: firstQuestion)
            show(quiz: viewModel)
        }
    }
 
    private struct ViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named:model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        // метод красит рамку
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            // код, который мы хотим вызвать через 1 секунду
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
        
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        
        
        if currentQuestionIndex == questionsAmount - 1 {
            // идём в состояние "Результат квиза"
            let text = "Ваш результат: \(correctAnswers)/10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть еще раз")
            show(quiz: viewModel)
        } else {
            
            currentQuestionIndex += 1
            
            // идём в состояние "Вопрос показан"
            if let firstQuestion = questionFactory.requestNextQuestion() {
                currentQuestion = firstQuestion
                let viewModel = convert(model: firstQuestion)
                show(quiz: viewModel)
            }
        }
    }
        private func show(quiz result:QuizResultsViewModel) {
            let alert = UIAlertController(
                title: result.title,
                message: result.text,
                preferredStyle: .alert)
            
            let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                
                if let firstQuestion = self.questionFactory.requestNextQuestion() {
                    self.currentQuestion = firstQuestion
                    let viewModel = self.convert(model: firstQuestion)
                    
                    self.show(quiz: viewModel)
                }
            }
                alert.addAction(action)

                self.present(alert, animated: true, completion: nil)
            }
            
            
            /*
             Mock-данные
             
             
             Картинка: The Godfather
             Настоящий рейтинг: 9,2
             Вопрос: Рейтинг этого фильма больше чем 6?
             Ответ: ДА
             
             
             Картинка: The Dark Knight
             Настоящий рейтинг: 9
             Вопрос: Рейтинг этого фильма больше чем 6?
             Ответ: ДА
             
             
             Картинка: Kill Bill
             Настоящий рейтинг: 8,1
             Вопрос: Рейтинг этого фильма больше чем 6?
             Ответ: ДА
             
             
             Картинка: The Avengers
             Настоящий рейтинг: 8
             Вопрос: Рейтинг этого фильма больше чем 6?
             Ответ: ДА
             
             
             Картинка: Deadpool
             Настоящий рейтинг: 8
             Вопрос: Рейтинг этого фильма больше чем 6?
             Ответ: ДА
             
             
             Картинка: The Green Knight
             Настоящий рейтинг: 6,6
             Вопрос: Рейтинг этого фильма больше чем 6?
             Ответ: ДА
             
             
             Картинка: Old
             Настоящий рейтинг: 5,8
             Вопрос: Рейтинг этого фильма больше чем 6?
             Ответ: НЕТ
             
             
             Картинка: The Ice Age Adventures of Buck Wild
             Настоящий рейтинг: 4,3
             Вопрос: Рейтинг этого фильма больше чем 6?
             Ответ: НЕТ
             
             
             Картинка: Tesla
             Настоящий рейтинг: 5,1
             Вопрос: Рейтинг этого фильма больше чем 6?
             Ответ: НЕТ
             
             
             Картинка: Vivarium
             Настоящий рейтинг: 5,8
             Вопрос: Рейтинг этого фильма больше чем 6?
             Ответ: НЕТ
             */
        }
