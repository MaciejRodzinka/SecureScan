import UIKit
import MessageUI

class SMSResultViewController: UIViewController {
    
    // UI Components
    private let resultIconView = UIImageView()
    private let resultTitleLabel = UILabel()
    private let senderLabel = UILabel()
    private let contentTextView = UITextView()
    private let analysisResultView = UIView()
    private let analysisLabel = UILabel()
    private let warningView = UIView()
    private let warningLabel = UILabel()
    private let reportButton = UIButton()
    private let moreInfoButton = UIButton()
    private let scanLinksButton = UIButton()
    private let actionsStackView = UIStackView()
    
    // Data
    private let smsMessage: SMSMessage
    private var detectedLinks: [String] = []
    
    // Services
    private let smsAnalyzerService = SMSAnalyzerService.shared
    private let urlScannerService = URLScannerService.shared
    
    init(smsMessage: SMSMessage) {
        self.smsMessage = smsMessage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        configureForResult()
        extractLinks()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Wynik Analizy SMS"
        
        // Result icon
        resultIconView.contentMode = .scaleAspectFit
        view.addSubview(resultIconView)
        
        // Result title
        resultTitleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        resultTitleLabel.textAlignment = .center
        resultTitleLabel.numberOfLines = 0
        view.addSubview(resultTitleLabel)
        
        // Sender
        senderLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        senderLabel.textAlignment = .left
        senderLabel.numberOfLines = 1
        view.addSubview(senderLabel)
        
        // Content text view
        contentTextView.font = UIFont.systemFont(ofSize: 16)
        contentTextView.textColor = .label
        contentTextView.backgroundColor = .systemGray6
        contentTextView.layer.cornerRadius = 8
        contentTextView.isEditable = false
        contentTextView.isSelectable = true
        contentTextView.isScrollEnabled = true
        contentTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        contentTextView.layer.borderColor = UIColor.systemGray5.cgColor
        contentTextView.layer.borderWidth = 1
        view.addSubview(contentTextView)
        
        // Analysis result view
        analysisResultView.layer.cornerRadius = 12
        analysisResultView.layer.borderWidth = 1
        view.addSubview(analysisResultView)
        
        // Analysis label
        analysisLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        analysisLabel.textAlignment = .left
        analysisLabel.numberOfLines = 0
        analysisResultView.addSubview(analysisLabel)
        
        // Warning view (visible only for suspicious/dangerous messages)
        warningView.backgroundColor = .systemYellow.withAlphaComponent(0.2)
        warningView.layer.cornerRadius = 12
        warningView.layer.borderWidth = 1
        warningView.layer.borderColor = UIColor.systemYellow.cgColor
        warningView.isHidden = true
        view.addSubview(warningView)
        
        // Warning label
        warningLabel.font = UIFont.systemFont(ofSize: 14)
        warningLabel.textAlignment = .left
        warningLabel.numberOfLines = 0
        warningView.addSubview(warningLabel)
        
        // Actions stack view
        actionsStackView.axis = .vertical
        actionsStackView.spacing = 12
        actionsStackView.distribution = .fillEqually
        view.addSubview(actionsStackView)
        
        // Report button
        reportButton.setTitle("Zgłoś na 8080", for: .normal)
        reportButton.backgroundColor = .systemBlue
        reportButton.layer.cornerRadius = 12
        reportButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        reportButton.addTarget(self, action: #selector(reportButtonTapped), for: .touchUpInside)
        actionsStackView.addArrangedSubview(reportButton)
        
        // Scan links button (visible only if links detected)
        scanLinksButton.setTitle("Skanuj wykryte linki", for: .normal)
        scanLinksButton.backgroundColor = .systemIndigo
        scanLinksButton.layer.cornerRadius = 12
        scanLinksButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        scanLinksButton.addTarget(self, action: #selector(scanLinksButtonTapped), for: .touchUpInside)
        actionsStackView.addArrangedSubview(scanLinksButton)
        
        // More info button
        moreInfoButton.setTitle("Więcej informacji", for: .normal)
        moreInfoButton.backgroundColor = .systemGray5
        moreInfoButton.setTitleColor(.systemBlue, for: .normal)
        moreInfoButton.layer.cornerRadius = 12
        moreInfoButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        moreInfoButton.addTarget(self, action: #selector(moreInfoButtonTapped), for: .touchUpInside)
        actionsStackView.addArrangedSubview(moreInfoButton)
    }
    
    private func setupConstraints() {
        resultIconView.translatesAutoresizingMaskIntoConstraints = false
        resultTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        senderLabel.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        analysisResultView.translatesAutoresizingMaskIntoConstraints = false
        analysisLabel.translatesAutoresizingMaskIntoConstraints = false
        warningView.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        actionsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Result icon
            resultIconView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            resultIconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultIconView.widthAnchor.constraint(equalToConstant: 60),
            resultIconView.heightAnchor.constraint(equalToConstant: 60),
            
            // Result title
            resultTitleLabel.topAnchor.constraint(equalTo: resultIconView.bottomAnchor, constant: 12),
            resultTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            resultTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // Sender
            senderLabel.topAnchor.constraint(equalTo: resultTitleLabel.bottomAnchor, constant: 24),
            senderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            senderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // Content text view
            contentTextView.topAnchor.constraint(equalTo: senderLabel.bottomAnchor, constant: 12),
            contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            contentTextView.heightAnchor.constraint(equalToConstant: 120),
            
            // Analysis result view
            analysisResultView.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 16),
            analysisResultView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            analysisResultView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // Analysis label
            analysisLabel.topAnchor.constraint(equalTo: analysisResultView.topAnchor, constant: 12),
            analysisLabel.leadingAnchor.constraint(equalTo: analysisResultView.leadingAnchor, constant: 12),
            analysisLabel.trailingAnchor.constraint(equalTo: analysisResultView.trailingAnchor, constant: -12),
            analysisLabel.bottomAnchor.constraint(equalTo: analysisResultView.bottomAnchor, constant: -12),
            
            // Warning view
            warningView.topAnchor.constraint(equalTo: analysisResultView.bottomAnchor, constant: 16),
            warningView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            warningView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // Warning label
            warningLabel.topAnchor.constraint(equalTo: warningView.topAnchor, constant: 12),
            warningLabel.leadingAnchor.constraint(equalTo: warningView.leadingAnchor, constant: 12),
            warningLabel.trailingAnchor.constraint(equalTo: warningView.trailingAnchor, constant: -12),
            warningLabel.bottomAnchor.constraint(equalTo: warningView.bottomAnchor, constant: -12),
            
            // Actions stack view
            actionsStackView.topAnchor.constraint(equalTo: warningView.bottomAnchor, constant: 24),
            actionsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            actionsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            actionsStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            
            // Button heights
            reportButton.heightAnchor.constraint(equalToConstant: 50),
            scanLinksButton.heightAnchor.constraint(equalToConstant: 50),
            moreInfoButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureForResult() {
        // Set message details
        senderLabel.text = "Nadawca: \(smsMessage.sender)"
        contentTextView.text = smsMessage.content
        
        // Configure result status based on risk level
        switch smsMessage.riskLevel {
        case .safe:
            resultIconView.image = UIImage(systemName: "checkmark.shield.fill")
            resultIconView.tintColor = .systemGreen
            resultTitleLabel.text = "Bezpieczna wiadomość"
            
            analysisResultView.backgroundColor = .systemGreen.withAlphaComponent(0.1)
            analysisResultView.layer.borderColor = UIColor.systemGreen.cgColor
            analysisLabel.text = "Analiza nie wykryła podejrzanych elementów w tej wiadomości. Wydaje się być bezpieczna."
            
            warningView.isHidden = true
            
        case .suspicious:
            resultIconView.image = UIImage(systemName: "exclamationmark.triangle.fill")
            resultIconView.tintColor = .systemYellow
            resultTitleLabel.text = "Podejrzana wiadomość"
            
            analysisResultView.backgroundColor = .systemYellow.withAlphaComponent(0.1)
            analysisResultView.layer.borderColor = UIColor.systemYellow.cgColor
            analysisLabel.text = "Ta wiadomość zawiera elementy, które mogą wskazywać na próbę oszustwa (smishing)."
            
            warningView.isHidden = false
            warningLabel.text = "⚠️ Zachowaj ostrożność. Ta wiadomość może być próbą wyłudzenia danych. Nie klikaj w zawarte w niej linki i nie podawaj swoich danych osobowych."
            
        case .dangerous:
            resultIconView.image = UIImage(systemName: "xmark.shield.fill")
            resultIconView.tintColor = .systemRed
            resultTitleLabel.text = "Niebezpieczna wiadomość!"
            
            analysisResultView.backgroundColor = .systemRed.withAlphaComponent(0.1)
            analysisResultView.layer.borderColor = UIColor.systemRed.cgColor
            analysisLabel.text = "Ta wiadomość została zidentyfikowana jako niebezpieczna próba oszustwa (smishing)."
            
            warningView.isHidden = false
            warningLabel.text = "⚠️ UWAGA! Ta wiadomość jest prawdopodobnie oszustwem. Nie klikaj w żadne linki, nie oddzwaniaj na podany numer i nie podawaj żadnych danych osobowych. Zalecamy zgłoszenie jej na numer 8080."
        }
        
        // Disable or enable scan links button based on whether links were detected
        scanLinksButton.isHidden = true  // Initially hidden, will be shown if links are found in extractLinks()
    }
    
    private func extractLinks() {
        // Use NSDataDetector to find URLs in the message
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: smsMessage.content, options: [], range: NSRange(location: 0, length: smsMessage.content.utf16.count))
        
        for match in matches {
            if let range = Range(match.range, in: smsMessage.content) {
                let url = String(smsMessage.content[range])
                detectedLinks.append(url)
            }
        }
        
        // Update scan links button visibility
        scanLinksButton.isHidden = detectedLinks.isEmpty
    }
    
    // MARK: - Actions
    
    @objc private func reportButtonTapped() {
        if !MFMessageComposeViewController.canSendText() {
            showAlert(title: "Błąd", message: "Nie można wysłać wiadomości SMS z tego urządzenia.")
            return
        }
        
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Prepare message for 8080
        composeVC.recipients = ["8080"]
        composeVC.body = smsAnalyzerService.prepareReport(for: smsMessage)
        
        present(composeVC, animated: true)
    }
    
    @objc private func scanLinksButtonTapped() {
        guard !detectedLinks.isEmpty else {
            showAlert(title: "Brak linków", message: "Nie wykryto żadnych linków w tej wiadomości.")
            return
        }
        
        if detectedLinks.count == 1 {
            // One link - scan directly
            scanLink(detectedLinks[0])
        } else {
            // Multiple links - show selection dialog
            let alert = UIAlertController(title: "Wybierz link do skanowania", message: nil, preferredStyle: .actionSheet)
            
            for link in detectedLinks {
                alert.addAction(UIAlertAction(title: link, style: .default) { [weak self] _ in
                    self?.scanLink(link)
                })
            }
            
            alert.addAction(UIAlertAction(title: "Anuluj", style: .cancel))
            present(alert, animated: true)
        }
    }
    
    private func scanLink(_ link: String) {
        // Jawnie ustawiamy sourceType jako .manual, bo link pochodzi z wiadomości SMS
        urlScannerService.scanURL(link, sourceType: .manual) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                // Add to scan history
                self.urlScannerService.addToHistory(result)
                
                // Show results
                let resultVC = ScanResultViewController(scanResult: result)
                self.navigationController?.pushViewController(resultVC, animated: true)
            }
        }
    }
    
    @objc private func moreInfoButtonTapped() {
        // Navigate to educational content about SMS scams
        let educationVC = EducationViewController()
        navigationController?.pushViewController(educationVC, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - MFMessageComposeViewControllerDelegate
extension SMSResultViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true) {
            switch result {
            case .sent:
                var updatedMessage = self.smsMessage
                self.smsAnalyzerService.reportMessage(&updatedMessage)
                self.showAlert(title: "Zgłoszono", message: "Dziękujemy za zgłoszenie podejrzanej wiadomości SMS. Pomaga to chronić innych użytkowników.")
            case .cancelled:
                break
            case .failed:
                self.showAlert(title: "Błąd", message: "Nie udało się wysłać zgłoszenia. Spróbuj ponownie później.")
            @unknown default:
                break
            }
        }
    }
}
