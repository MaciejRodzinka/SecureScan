import UIKit

class SMSAnalyzerViewController: UIViewController {
    
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let senderTextField = UITextField()
    private let contentTextView = UITextView()
    private let analyzeButton = UIButton()
    private let activityIndicator = UIActivityIndicatorView()
    private let historyTableView = UITableView()
    private let segmentedControl = UISegmentedControl()
    
    
    private let smsAnalyzerService = SMSAnalyzerService.shared
    private let urlScannerService = URLScannerService.shared
    
    
    private var messageHistory: [SMSMessage] = []
    private var showingInputForm = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadHistory()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Analiza SMS"
        
        
        segmentedControl.insertSegment(withTitle: "Analiza", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Historia", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        view.addSubview(segmentedControl)
        
        
        titleLabel.text = "Analiza wiadomości SMS"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        
        
        descriptionLabel.text = "Wprowadź treść SMS, aby sprawdzić, czy nie jest to próba oszustwa"
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)
        
        
        senderTextField.placeholder = "Numer nadawcy lub nazwa"
        senderTextField.borderStyle = .roundedRect
        senderTextField.returnKeyType = .next
        view.addSubview(senderTextField)
        
        
        contentTextView.font = UIFont.systemFont(ofSize: 16)
        contentTextView.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        contentTextView.layer.borderWidth = 0.5
        contentTextView.layer.borderColor = UIColor.systemGray4.cgColor
        contentTextView.layer.cornerRadius = 8
        contentTextView.returnKeyType = .done
        view.addSubview(contentTextView)
        
        
        analyzeButton.setTitle("Analizuj wiadomość", for: .normal)
        analyzeButton.backgroundColor = .systemBlue
        analyzeButton.layer.cornerRadius = 12
        analyzeButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        analyzeButton.addTarget(self, action: #selector(analyzeButtonTapped), for: .touchUpInside)
        view.addSubview(analyzeButton)
        
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        view.addSubview(activityIndicator)
        
        
        historyTableView.register(SMSHistoryCell.self, forCellReuseIdentifier: "SMSHistoryCell")
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.rowHeight = UITableView.automaticDimension
        historyTableView.estimatedRowHeight = 120
        historyTableView.separatorStyle = .singleLine
        historyTableView.tableFooterView = UIView()
        historyTableView.isHidden = true
        view.addSubview(historyTableView)
        
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }
    
    private func setupConstraints() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        senderTextField.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        analyzeButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        historyTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            
            titleLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            
            senderTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            senderTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            senderTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            senderTextField.heightAnchor.constraint(equalToConstant: 50),
            
            
            contentTextView.topAnchor.constraint(equalTo: senderTextField.bottomAnchor, constant: 16),
            contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            contentTextView.heightAnchor.constraint(equalToConstant: 150),
            
            
            analyzeButton.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 24),
            analyzeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            analyzeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            analyzeButton.heightAnchor.constraint(equalToConstant: 50),
            
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            
            historyTableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            historyTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func loadHistory() {
        messageHistory = smsAnalyzerService.getMessageHistory()
        historyTableView.reloadData()
    }
    
    @objc private func segmentChanged() {
        showingInputForm = segmentedControl.selectedSegmentIndex == 0
        
        
        titleLabel.isHidden = !showingInputForm
        descriptionLabel.isHidden = !showingInputForm
        senderTextField.isHidden = !showingInputForm
        contentTextView.isHidden = !showingInputForm
        analyzeButton.isHidden = !showingInputForm
        historyTableView.isHidden = showingInputForm
        
        
        if !showingInputForm {
            loadHistory()
        }
    }
    
    @objc private func analyzeButtonTapped() {
        guard let sender = senderTextField.text, !sender.isEmpty else {
            showAlert(title: "Błąd", message: "Wprowadź numer lub nazwę nadawcy")
            return
        }
        
        guard let content = contentTextView.text, !content.isEmpty else {
            showAlert(title: "Błąd", message: "Wprowadź treść wiadomości")
            return
        }
        
        activityIndicator.startAnimating()
        analyzeButton.isEnabled = false
        
        
        let result = smsAnalyzerService.analyzeSMS(sender: sender, content: content)
        
        
        smsAnalyzerService.addToHistory(result)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self = self else { return }
            
            self.activityIndicator.stopAnimating()
            self.analyzeButton.isEnabled = true
            
            
            let resultVC = SMSResultViewController(smsMessage: result)
            self.navigationController?.pushViewController(resultVC, animated: true)
            
            
            self.senderTextField.text = ""
            self.contentTextView.text = ""
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension SMSAnalyzerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messageHistory.isEmpty {
            return 1
        }
        return messageHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SMSHistoryCell", for: indexPath) as! SMSHistoryCell
        
        if messageHistory.isEmpty {
            cell.configure(withEmptyState: true)
            return cell
        }
        
        let message = messageHistory[indexPath.row]
        cell.configure(with: message)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if messageHistory.isEmpty {
            return
        }
        
        let message = messageHistory[indexPath.row]
        let resultVC = SMSResultViewController(smsMessage: message)
        navigationController?.pushViewController(resultVC, animated: true)
    }
}

class SMSHistoryCell: UITableViewCell {
    private let containerView = UIView()
    private let senderLabel = UILabel()
    private let contentPreviewLabel = UILabel()
    private let dateLabel = UILabel()
    private let riskBadge = UIView()
    private let riskLabel = UILabel()
    private let emptyLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        
        containerView.backgroundColor = .systemGray6
        containerView.layer.cornerRadius = 12
        contentView.addSubview(containerView)
        
        
        senderLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        senderLabel.numberOfLines = 1
        containerView.addSubview(senderLabel)
        
        
        contentPreviewLabel.font = UIFont.systemFont(ofSize: 14)
        contentPreviewLabel.textColor = .secondaryLabel
        contentPreviewLabel.numberOfLines = 2
        containerView.addSubview(contentPreviewLabel)
        
        
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .tertiaryLabel
        dateLabel.textAlignment = .right
        containerView.addSubview(dateLabel)
        
        
        riskBadge.layer.cornerRadius = 10
        containerView.addSubview(riskBadge)
        
        
        riskLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        riskLabel.textColor = .white
        riskLabel.textAlignment = .center
        riskBadge.addSubview(riskLabel)
        
        
        emptyLabel.font = UIFont.systemFont(ofSize: 16)
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.text = "Historia jest pusta"
        emptyLabel.textAlignment = .center
        emptyLabel.isHidden = true
        contentView.addSubview(emptyLabel)
        
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        senderLabel.translatesAutoresizingMaskIntoConstraints = false
        contentPreviewLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        riskBadge.translatesAutoresizingMaskIntoConstraints = false
        riskLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            
            senderLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            senderLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            senderLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -8),
            
            
            dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            dateLabel.widthAnchor.constraint(equalToConstant: 80),
            
            
            contentPreviewLabel.topAnchor.constraint(equalTo: senderLabel.bottomAnchor, constant: 4),
            contentPreviewLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            contentPreviewLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            
            riskBadge.topAnchor.constraint(equalTo: contentPreviewLabel.bottomAnchor, constant: 8),
            riskBadge.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            riskBadge.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            riskBadge.heightAnchor.constraint(equalToConstant: 24),
            riskBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            
            riskLabel.topAnchor.constraint(equalTo: riskBadge.topAnchor),
            riskLabel.leadingAnchor.constraint(equalTo: riskBadge.leadingAnchor, constant: 8),
            riskLabel.trailingAnchor.constraint(equalTo: riskBadge.trailingAnchor, constant: -8),
            riskLabel.bottomAnchor.constraint(equalTo: riskBadge.bottomAnchor),
            
            
            emptyLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with message: SMSMessage) {
        senderLabel.text = message.sender
        contentPreviewLabel.text = message.content
        
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        dateLabel.text = formatter.string(from: message.receivedDate)
        
        
        switch message.riskLevel {
        case .safe:
            riskBadge.backgroundColor = .systemGreen
            riskLabel.text = "Bezpieczny"
        case .suspicious:
            riskBadge.backgroundColor = .systemYellow
            riskLabel.text = "Podejrzany"
        case .dangerous:
            riskBadge.backgroundColor = .systemRed
            riskLabel.text = "Niebezpieczny"
        }
        
        
        containerView.isHidden = false
        emptyLabel.isHidden = true
    }
    
    func configure(withEmptyState isEmpty: Bool) {
        containerView.isHidden = isEmpty
        emptyLabel.isHidden = !isEmpty
    }
}
