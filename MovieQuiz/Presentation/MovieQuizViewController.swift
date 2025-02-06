import UIKit
final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    //MARK: - IBOutlets
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    private var presenter: MovieQuizPresenter!

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        imageView.layer.cornerRadius = 20
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        super.viewDidLoad()
        print(Bundle.main.bundlePath)
        
        presenter = MovieQuizPresenter(viewController: self)n
    }
    
    //MARK: - IBActions
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
    }
    
    //MARK: - PrivateFunctionsD
    
    func startActivityIndicator() {
        activityIndicator.startAnimating()
   
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        yesButton.isEnabled = true
        noButton.isEnabled = true
        imageView.layer.borderColor = nil
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultMessage()
        
        let model = AlertModel(title: result.title, message: message, buttonText: result.buttonText) { [weak self] in
            guard let self = self else { return }
            
            self.presenter.restartGame()
            
        }
        AlertPresenter.showAlert(on: self, with: model)
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
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8D
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
}


      
       
            
            
            
