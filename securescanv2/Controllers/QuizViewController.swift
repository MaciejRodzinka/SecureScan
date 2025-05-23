import UIKit

class QuizViewController: UIViewController {
    
    
    private let questionLabel = UILabel()
    private let optionsStackView = UIStackView()
    private let progressView = UIProgressView()
    private let progressLabel = UILabel()
    private let scoreLabel = UILabel()
    
    
    private let content: EducationalContent
    private var currentQuestionIndex = 0
    private var score = 0
    private var selectedOptionButton: UIButton?
    
    
    private var currentQuestion: QuizQuestion? {
        guard let questions = content.quizQuestions,
              currentQuestionIndex < questions.count else {
            return nil
        }
        return questions[currentQuestionIndex]
    }
    
    init(content: EducationalContent) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadQuestion()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Quiz: \(content.title)"
        
        
        progressView.progressTintColor = .systemBlue
        progressView.trackTintColor = .systemGray5
        view.addSubview(progressView)
        
        
        progressLabel.font = UIFont.systemFont(ofSize: 14)
        progressLabel.textColor = .secondaryLabel
        progressLabel.textAlignment = .right
        view.addSubview(progressLabel)
        
        
        scoreLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        scoreLabel.textColor = .label
        scoreLabel.textAlignment = .left
        scoreLabel.text = "Wynik: 0"
        view.addSubview(scoreLabel)
        
        
        questionLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        questionLabel.textColor = .label
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .left
        view.addSubview(questionLabel)
        
        
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 16
        optionsStackView.distribution = .fillEqually
        view.addSubview(optionsStackView)
    }
    
    private func setupConstraints() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            
            progressLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8),
            progressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            
            scoreLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8),
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            
            questionLabel.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 24),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            
            optionsStackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 32),
            optionsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            optionsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            optionsStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
    
    private func loadQuestion() {
        guard let question = currentQuestion,
              let questions = content.quizQuestions else {
            showResults()
            return
        }
        
        
        let progress = Float(currentQuestionIndex) / Float(questions.count)
        progressView.setProgress(progress, animated: true)
        progressLabel.text = "Pytanie \(currentQuestionIndex + 1) z \(questions.count)"
        
        
        questionLabel.text = question.question
        
        
        optionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        
        for (index, option) in question.options.enumerated() {
            let optionButton = createOptionButton(text: option, index: index)
            optionsStackView.addArrangedSubview(optionButton)
        }
    }
    
    private func createOptionButton(text: String, index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        
        var config = UIButton.Configuration.filled()
        config.title = text
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 16)
            return outgoing
        }
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        config.background.backgroundColor = .systemGray6
        config.background.cornerRadius = 12
        config.titleAlignment = .center
        button.configuration = config
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        button.tag = index
        button.addTarget(self, action: #selector(optionSelected), for: .touchUpInside)
        return button
    }
    
    @objc private func optionSelected(_ sender: UIButton) {
        
        optionsStackView.arrangedSubviews.forEach { ($0 as? UIButton)?.isEnabled = false }
        
        selectedOptionButton = sender
        
        
        sender.backgroundColor = .systemBlue
        sender.setTitleColor(.white, for: .normal)
        
        
        if let question = currentQuestion, sender.tag == question.correctAnswerIndex {
            score += 1
            scoreLabel.text = "Wynik: \(score)"
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                sender.backgroundColor = .systemGreen
                self?.moveToNextQuestion()
            }
        } else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self, let question = self.currentQuestion else { return }
                
                
                sender.backgroundColor = .systemRed
                
                
                if let correctButton = self.optionsStackView.arrangedSubviews[question.correctAnswerIndex] as? UIButton {
                    correctButton.backgroundColor = .systemGreen
                    correctButton.setTitleColor(.white, for: .normal)
                }
                
                self.moveToNextQuestion()
            }
        }
    }
    
    private func moveToNextQuestion() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            self.currentQuestionIndex += 1
            
            if let questions = self.content.quizQuestions, self.currentQuestionIndex < questions.count {
                self.loadQuestion()
            } else {
                self.showResults()
            }
        }
    }
    
    private func showResults() {
        
        EducationService.shared.markAsCompleted(contentId: content.id, score: score)
        
        
        let totalQuestions = content.quizQuestions?.count ?? 0
        let percentage = totalQuestions > 0 ? (Double(score) / Double(totalQuestions)) * 100 : 0
        
        
        let alert = UIAlertController(
            title: "Koniec quizu!",
            message: "Twój wynik: \(score)/\(totalQuestions) (\(Int(percentage))%)",
            preferredStyle: .alert
        )
        
        
        if percentage >= 80 {
            alert.message! += "\n\nDoskonale! Świetnie znasz się na bezpieczeństwie online."
        } else if percentage >= 60 {
            alert.message! += "\n\nNieźle! Masz dobrą wiedzę o bezpieczeństwie online."
        } else {
            alert.message! += "\n\nWarto powtórzyć materiał o bezpieczeństwie online."
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        
        present(alert, animated: true)
    }
}
