import UIKit

class LinkScannerViewController: UIViewController {
    
    // UI Components
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let urlTextField = UITextField()
    private let scanButton = UIButton()
    private let activityIndicator = UIActivityIndicatorView()
    private let instructionsLabel = UILabel()
    private let examplePhishingView = UIView()
    
    // Scanner Service
    private let scannerService = URLScannerService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Skanowanie Linku"
        
        // Title
        titleLabel.text = "Sprawdź bezpieczeństwo linku"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        
        // Description
        descriptionLabel.text = "Wklej adres URL, aby sprawdzić, czy jest to próba phishingu lub złośliwa strona"
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)
        
        // URL TextField
        urlTextField.placeholder = "https://example.com"
        urlTextField.borderStyle = .roundedRect
        urlTextField.returnKeyType = .go
        urlTextField.autocapitalizationType = .none
        urlTextField.autocorrectionType = .no
        urlTextField.clearButtonMode = .whileEditing
        urlTextField.delegate = self
        view.addSubview(urlTextField)
        
        // Scan Button
        scanButton.setTitle("Skanuj Link", for: .normal)
        scanButton.backgroundColor = .systemBlue
        scanButton.layer.cornerRadius = 12
        scanButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
        view.addSubview(scanButton)
        
        // Activity Indicator
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        view.addSubview(activityIndicator)
        
        // Instructions
        instructionsLabel.text = "Pamiętaj:\n• Sprawdź, czy adres URL zawiera \"https\"\n• Zwróć uwagę na literówki w adresach znanych stron\n• Nie klikaj w linki od nieznanych nadawców"
        instructionsLabel.font = UIFont.systemFont(ofSize: 14)
        instructionsLabel.textColor = .secondaryLabel
        instructionsLabel.numberOfLines = 0
        view.addSubview(instructionsLabel)
        
        // Example phishing view
        setupExampleView()
    }
    
    private func setupExampleView() {
        examplePhishingView.backgroundColor = .systemBackground
        examplePhishingView.layer.cornerRadius = 12
        examplePhishingView.layer.borderWidth = 1
        examplePhishingView.layer.borderColor = UIColor.systemGray5.cgColor
        view.addSubview(examplePhishingView)
        
        let headerLabel = UILabel()
        headerLabel.text = "Przykład phishingu:"
        headerLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        headerLabel.textAlignment = .left
        examplePhishingView.addSubview(headerLabel)
        
        let exampleLabel = UILabel()
        exampleLabel.text = "facebook-login.secure-verify.com\nvs\nfacebook.com"
        exampleLabel.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        exampleLabel.numberOfLines = 0
        examplePhishingView.addSubview(exampleLabel)
        
        let warningIcon = UIImageView()
        warningIcon.image = UIImage(systemName: "exclamationmark.triangle.fill")
        warningIcon.tintColor = .systemYellow
        warningIcon.contentMode = .scaleAspectFit
        examplePhishingView.addSubview(warningIcon)
        
        // Layout
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        exampleLabel.translatesAutoresizingMaskIntoConstraints = false
        warningIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: examplePhishingView.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: examplePhishingView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: warningIcon.leadingAnchor, constant: -8),
            
            warningIcon.topAnchor.constraint(equalTo: examplePhishingView.topAnchor, constant: 16),
            warningIcon.trailingAnchor.constraint(equalTo: examplePhishingView.trailingAnchor, constant: -16),
            warningIcon.widthAnchor.constraint(equalToConstant: 24),
            warningIcon.heightAnchor.constraint(equalToConstant: 24),
            
            exampleLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            exampleLabel.leadingAnchor.constraint(equalTo: examplePhishingView.leadingAnchor, constant: 16),
            exampleLabel.trailingAnchor.constraint(equalTo: examplePhishingView.trailingAnchor, constant: -16),
            exampleLabel.bottomAnchor.constraint(equalTo: examplePhishingView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        urlTextField.translatesAutoresizingMaskIntoConstraints = false
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        examplePhishingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            urlTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            urlTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            urlTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            urlTextField.heightAnchor.constraint(equalToConstant: 50),
            
            scanButton.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: 24),
            scanButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            scanButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            scanButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: scanButton.bottomAnchor, constant: 20),
            
            instructionsLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 30),
            instructionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            instructionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            examplePhishingView.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 30),
            examplePhishingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            examplePhishingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    @objc private func scanButtonTapped() {
        guard let url = urlTextField.text, !url.isEmpty else {
            showAlert(title: "Błąd", message: "Wprowadź adres URL do przeskanowania")
            return
        }
        
        startScanning()
        
        scannerService.scanURL(url) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.stopScanning()
                
                // Add to scan history
                self.scannerService.addToHistory(result)
                
                // Navigate to results
                let resultVC = ScanResultViewController(scanResult: result)
                self.navigationController?.pushViewController(resultVC, animated: true)
            }
        }
    }
    
    private func startScanning() {
        activityIndicator.startAnimating()
        scanButton.isEnabled = false
        urlTextField.isEnabled = false
    }
    
    private func stopScanning() {
        activityIndicator.stopAnimating()
        scanButton.isEnabled = true
        urlTextField.isEnabled = true
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension LinkScannerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == urlTextField {
            scanButtonTapped()
        }
        return true
    }
}
