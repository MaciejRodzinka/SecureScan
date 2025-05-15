import UIKit
import SafariServices

// Niestandardowa podklasa UILabel z paddingiem
class PaddingLabel: UILabel {
    var padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
}

class ScanResultViewController: UIViewController {
    
    // UI Components
    private let resultIconView = UIImageView()
    private let resultTitleLabel = UILabel()
    private let urlLabel = UILabel()
    private let detailsLabel = UILabel()
    private let sourceLabel = PaddingLabel()
    private let educationalTipView = UIView()
    private let educationalTipLabel = UILabel()
    private let actionsStackView = UIStackView()
    private let visitButton = UIButton()
    private let reportButton = UIButton()
    private let backToScanButton = UIButton()
    
    // Data
    private let scanResult: ScanResult
    
    init(scanResult: ScanResult) {
        self.scanResult = scanResult
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
        // Add a delay for dramatic effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.configureForResult()
            self?.animateResultAppearance()
        }
    }
    
    private func animateResultAppearance() {
        // Start with hidden elements
        let elements = [resultIconView, resultTitleLabel, urlLabel, detailsLabel, 
                       educationalTipView, actionsStackView]
        
        elements.forEach { $0.alpha = 0 }
        resultIconView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        // Animate icon with bounce effect
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, 
                       initialSpringVelocity: 0.5, options: [], animations: {
            self.resultIconView.alpha = 1
            self.resultIconView.transform = .identity
        })
        
        // Animate title with delay
        UIView.animate(withDuration: 0.4, delay: 0.3, options: [], animations: {
            self.resultTitleLabel.alpha = 1
        })
        
        // Animate URL with delay
        UIView.animate(withDuration: 0.4, delay: 0.5, options: [], animations: {
            self.urlLabel.alpha = 1
        })
        
        // Animate details with delay
        UIView.animate(withDuration: 0.4, delay: 0.7, options: [], animations: {
            self.detailsLabel.alpha = 1
        })
        
        // Animate tip with delay
        UIView.animate(withDuration: 0.4, delay: 0.9, options: [], animations: {
            self.educationalTipView.alpha = 1
        })
        
        // Animate buttons with delay
        UIView.animate(withDuration: 0.4, delay: 1.1, options: [], animations: {
            self.actionsStackView.alpha = 1
        })
        
        // Add particle effects based on result
        addParticleEffect()
    }
    
    private func addParticleEffect() {
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: view.bounds.width / 2, y: resultIconView.center.y)
        emitter.emitterSize = CGSize(width: 100, height: 100)
        emitter.emitterShape = .circle
        emitter.renderMode = .additive
        
        let cell = CAEmitterCell()
        cell.scale = 0.1
        cell.scaleRange = 0.05
        cell.emissionRange = .pi * 2.0
        cell.lifetime = 1.5
        cell.birthRate = 10
        cell.velocity = 50
        cell.velocityRange = 20
        cell.alphaSpeed = -0.5
        cell.spin = 1.0
        cell.spinRange = 2.0
        
        // Set particle color based on result
        switch scanResult.resultType {
        case .safe:
            cell.color = UIColor.systemGreen.cgColor
        case .suspicious:
            cell.color = UIColor.systemYellow.cgColor
        case .dangerous:
            cell.color = UIColor.systemRed.cgColor
        case .unknown:
            cell.color = UIColor.systemGray.cgColor
        }
        
        // Create content for particle
        let size = CGSize(width: 20, height: 20)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.setFill()
        UIBezierPath(ovalIn: CGRect(origin: .zero, size: size)).fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        cell.contents = image?.cgImage
        
        emitter.emitterCells = [cell]
        view.layer.insertSublayer(emitter, at: 10)
        
        // Only emit for 1.5 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            emitter.birthRate = 0
        }
    }
    
    private func setupUI() {
        // Create an animated gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        // First set base gradient colors based on result type
        var gradientStartColor: UIColor
        var gradientEndColor: UIColor
        
        // Base colors by result type
        switch scanResult.resultType {
        case .safe:
            gradientStartColor = UIColor(red: 0.0, green: 0.5, blue: 0.3, alpha: 1.0)
            gradientEndColor = UIColor(red: 0.2, green: 0.7, blue: 0.5, alpha: 1.0)
        case .suspicious:
            gradientStartColor = UIColor(red: 0.7, green: 0.5, blue: 0.0, alpha: 1.0)
            gradientEndColor = UIColor(red: 0.9, green: 0.7, blue: 0.1, alpha: 1.0)
        case .dangerous:
            gradientStartColor = UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 1.0)
            gradientEndColor = UIColor(red: 0.7, green: 0.1, blue: 0.1, alpha: 1.0)
        case .unknown:
            gradientStartColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
            gradientEndColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        }
        
        // Now override colors based on content category if applicable
        switch scanResult.contentCategory {
        case .adult: // Różowe tło dla treści dla dorosłych
            gradientStartColor = UIColor(red: 0.6, green: 0.1, blue: 0.4, alpha: 1.0)
            gradientEndColor = UIColor(red: 0.85, green: 0.4, blue: 0.6, alpha: 1.0)
            
        case .gambling: // Fioletowe tło dla hazardu
            gradientStartColor = UIColor(red: 0.4, green: 0.2, blue: 0.6, alpha: 1.0)
            gradientEndColor = UIColor(red: 0.6, green: 0.4, blue: 0.8, alpha: 1.0)
            
        case .gore: // Ciemne czerwone tło dla treści drastycznych
            gradientStartColor = UIColor(red: 0.4, green: 0.0, blue: 0.0, alpha: 1.0)
            gradientEndColor = UIColor(red: 0.6, green: 0.1, blue: 0.1, alpha: 1.0)
            
        case .malware: // Szaro-czerwone tło dla złośliwego oprogramowania
            gradientStartColor = UIColor(red: 0.4, green: 0.0, blue: 0.0, alpha: 1.0)
            gradientEndColor = UIColor(red: 0.6, green: 0.2, blue: 0.2, alpha: 1.0)
            
        case .phishing: // Czerwono-pomarańczowe tło dla phishingu
            gradientStartColor = UIColor(red: 0.5, green: 0.1, blue: 0.0, alpha: 1.0)
            gradientEndColor = UIColor(red: 0.8, green: 0.3, blue: 0.1, alpha: 1.0)
            
        case .scam: // Żółto-pomarańczowe tło dla oszustw
            gradientStartColor = UIColor(red: 0.6, green: 0.3, blue: 0.0, alpha: 1.0)
            gradientEndColor = UIColor(red: 0.9, green: 0.5, blue: 0.1, alpha: 1.0)
            
        case .drugs: // Zielone tło dla narkotyków
            gradientStartColor = UIColor(red: 0.1, green: 0.3, blue: 0.1, alpha: 1.0)
            gradientEndColor = UIColor(red: 0.3, green: 0.5, blue: 0.2, alpha: 1.0)
            
        case .weapons: // Ciemne szare tło dla broni
            gradientStartColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
            gradientEndColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
            
        case .extremism: // Bardzo ciemne czerwone tło dla ekstremizmu
            gradientStartColor = UIColor(red: 0.3, green: 0.0, blue: 0.0, alpha: 1.0)
            gradientEndColor = UIColor(red: 0.5, green: 0.1, blue: 0.1, alpha: 1.0)
            
        case .none: // W przypadku .none używamy domyślnych kolorów dla danego resultType (już ustawione wyżej)
            break
        }
        
        gradientLayer.colors = [
            gradientStartColor.cgColor,
            gradientEndColor.cgColor
        ]
        
        gradientLayer.locations = [0.0, 1.0]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Add a blur overlay for better contrast with text
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        blurView.frame = view.bounds
        blurView.alpha = 0.5
        view.addSubview(blurView)
        
        title = "Wynik Skanowania"
        
        // Result icon
        resultIconView.contentMode = .scaleAspectFit
        view.addSubview(resultIconView)
        
        // Result title
        resultTitleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        resultTitleLabel.textAlignment = .center
        resultTitleLabel.numberOfLines = 0
        view.addSubview(resultTitleLabel)
        
        // URL
        urlLabel.font = UIFont.monospacedSystemFont(ofSize: 16, weight: .regular)
        urlLabel.textAlignment = .center
        urlLabel.numberOfLines = 0
        urlLabel.lineBreakMode = .byTruncatingMiddle
        view.addSubview(urlLabel)
        
        // Source label (showing if URL was manually entered or scanned from QR)
        sourceLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        sourceLabel.textAlignment = .center
        sourceLabel.numberOfLines = 1
        sourceLabel.backgroundColor = UIColor.systemGray6
        sourceLabel.layer.cornerRadius = 10
        sourceLabel.layer.masksToBounds = true
        sourceLabel.padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        view.addSubview(sourceLabel)
        
        // Details
        detailsLabel.font = UIFont.systemFont(ofSize: 16)
        detailsLabel.textColor = .secondaryLabel
        detailsLabel.textAlignment = .left
        detailsLabel.numberOfLines = 0
        view.addSubview(detailsLabel)
        
        // Educational tip view
        educationalTipView.backgroundColor = .systemGray6
        educationalTipView.layer.cornerRadius = 12
        view.addSubview(educationalTipView)
        
        // Educational tip label
        educationalTipLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        educationalTipLabel.textColor = .label
        educationalTipLabel.textAlignment = .left
        educationalTipLabel.numberOfLines = 0
        educationalTipView.addSubview(educationalTipLabel)
        
        // Actions stack view
        actionsStackView.axis = .vertical
        actionsStackView.spacing = 16
        actionsStackView.distribution = .fillEqually
        view.addSubview(actionsStackView)
        
        // Visit button
        visitButton.backgroundColor = .systemBlue
        visitButton.layer.cornerRadius = 12
        visitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        visitButton.addTarget(self, action: #selector(visitButtonTapped), for: .touchUpInside)
        actionsStackView.addArrangedSubview(visitButton)
        
        // Report button
        reportButton.backgroundColor = .systemRed
        reportButton.layer.cornerRadius = 12
        reportButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        reportButton.addTarget(self, action: #selector(reportButtonTapped), for: .touchUpInside)
        actionsStackView.addArrangedSubview(reportButton)
        
        // Back to scan button
        backToScanButton.backgroundColor = .systemGray5
        backToScanButton.setTitle("Nowe skanowanie", for: .normal)
        backToScanButton.setTitleColor(.systemBlue, for: .normal)
        backToScanButton.layer.cornerRadius = 12
        backToScanButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        backToScanButton.addTarget(self, action: #selector(backToScanButtonTapped), for: .touchUpInside)
        actionsStackView.addArrangedSubview(backToScanButton)
    }
    
    private func setupConstraints() {
        resultIconView.translatesAutoresizingMaskIntoConstraints = false
        resultTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        urlLabel.translatesAutoresizingMaskIntoConstraints = false
        sourceLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        educationalTipView.translatesAutoresizingMaskIntoConstraints = false
        educationalTipLabel.translatesAutoresizingMaskIntoConstraints = false
        actionsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Result icon
            resultIconView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            resultIconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultIconView.widthAnchor.constraint(equalToConstant: 80),
            resultIconView.heightAnchor.constraint(equalToConstant: 80),
            
            // Result title
            resultTitleLabel.topAnchor.constraint(equalTo: resultIconView.bottomAnchor, constant: 16),
            resultTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            resultTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // URL
            urlLabel.topAnchor.constraint(equalTo: resultTitleLabel.bottomAnchor, constant: 16),
            urlLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            urlLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Source label
            sourceLabel.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 8),
            sourceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Details
            detailsLabel.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 16),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Educational tip view
            educationalTipView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 24),
            educationalTipView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            educationalTipView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // Educational tip label
            educationalTipLabel.topAnchor.constraint(equalTo: educationalTipView.topAnchor, constant: 16),
            educationalTipLabel.leadingAnchor.constraint(equalTo: educationalTipView.leadingAnchor, constant: 16),
            educationalTipLabel.trailingAnchor.constraint(equalTo: educationalTipView.trailingAnchor, constant: -16),
            educationalTipLabel.bottomAnchor.constraint(equalTo: educationalTipView.bottomAnchor, constant: -16),
            
            // Actions stack view
            actionsStackView.topAnchor.constraint(equalTo: educationalTipView.bottomAnchor, constant: 32),
            actionsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            actionsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            actionsStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            
            // Button heights
            visitButton.heightAnchor.constraint(equalToConstant: 50),
            reportButton.heightAnchor.constraint(equalToConstant: 50),
            backToScanButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureForResult() {
        // Configure UI based on scan result
        urlLabel.text = scanResult.url
        detailsLabel.text = scanResult.details
        educationalTipLabel.text = "💡 Wskazówka: " + (scanResult.educationalTip ?? "Zawsze sprawdzaj, czy adres URL wygląda poprawnie")
        
        // Configure basic result status first
        switch scanResult.resultType {
        case .safe:
            resultIconView.tintColor = .systemGreen
            visitButton.setTitle("Otwórz stronę", for: .normal)
            visitButton.backgroundColor = .systemGreen
            
        case .suspicious:
            resultIconView.tintColor = .systemYellow
            visitButton.setTitle("Otwórz stronę (Ostrożnie!)", for: .normal)
            visitButton.backgroundColor = .systemYellow
            
        case .dangerous:
            resultIconView.tintColor = .systemRed
            visitButton.setTitle("Otwórz stronę (Niezalecane!)", for: .normal)
            visitButton.backgroundColor = .systemRed
            
        case .unknown:
            resultIconView.tintColor = .systemGray
            visitButton.setTitle("Otwórz stronę (Zachowaj ostrożność)", for: .normal)
            visitButton.backgroundColor = .systemGray
        }
        
        // Dodaj informację o źródle skanu (ręczny czy kod QR)
        switch scanResult.sourceType {
        case .manual:
            sourceLabel.text = "Ręcznie wprowadzony URL"
            sourceLabel.textColor = .systemBlue
        case .qrCode:
            sourceLabel.text = "URL z kodu QR"
            sourceLabel.textColor = .systemIndigo
        }
        
        // Configure based on content category
        switch scanResult.contentCategory {
        case .none:
            if scanResult.resultType == .safe {
                resultIconView.image = UIImage(systemName: "checkmark.shield.fill")
                resultTitleLabel.text = "Bezpieczny URL"
            } else if scanResult.resultType == .suspicious {
                resultIconView.image = UIImage(systemName: "exclamationmark.triangle.fill")
                resultTitleLabel.text = "Podejrzany URL" 
            } else if scanResult.resultType == .dangerous {
                resultIconView.image = UIImage(systemName: "xmark.shield.fill")
                resultTitleLabel.text = "Niebezpieczny URL"
            } else {
                resultIconView.image = UIImage(systemName: "questionmark.circle.fill")
                resultTitleLabel.text = "Nieznany URL"
            }
            
        case .adult:
            resultIconView.image = UIImage(systemName: "eye.slash.fill")
            resultTitleLabel.text = "Treści dla dorosłych"
            resultIconView.tintColor = UIColor(red: 0.85, green: 0.4, blue: 0.6, alpha: 1.0) // Różowy
            
        case .gambling:
            resultIconView.image = UIImage(systemName: "dice.fill")
            resultTitleLabel.text = "Hazard"
            resultIconView.tintColor = UIColor(red: 0.6, green: 0.4, blue: 0.8, alpha: 1.0) // Fioletowy
            
        case .gore:
            resultIconView.image = UIImage(systemName: "drop.fill")
            resultTitleLabel.text = "Drastyczne treści"
            resultIconView.tintColor = UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1.0) // Ciemny czerwony
            
        case .malware:
            resultIconView.image = UIImage(systemName: "ladybug.fill")
            resultTitleLabel.text = "Złośliwe oprogramowanie"
            
        case .phishing:
            resultIconView.image = UIImage(systemName: "fishing.pole.and.hook.line")
            resultTitleLabel.text = "Phishing"
            
        case .scam:
            resultIconView.image = UIImage(systemName: "dollarsign.circle.fill")
            resultTitleLabel.text = "Oszustwo"
            
        case .drugs:
            resultIconView.image = UIImage(systemName: "pills.fill")
            resultTitleLabel.text = "Substancje nielegalne"
            resultIconView.tintColor = UIColor(red: 0.3, green: 0.5, blue: 0.2, alpha: 1.0) // Ciemny zielony
            
        case .weapons:
            resultIconView.image = UIImage(systemName: "bolt.fill")
            resultTitleLabel.text = "Broń"
            resultIconView.tintColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0) // Ciemny szary
            
        case .extremism:
            resultIconView.image = UIImage(systemName: "flame.fill")
            resultTitleLabel.text = "Ekstremizm"
            resultIconView.tintColor = UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 1.0) // Bardzo ciemny czerwony
        }
        
        reportButton.setTitle(scanResult.isPhishing ? "Zgłoś phishing" : "Zgłoś jako podejrzane", for: .normal)
    }
    
    // MARK: - Actions
    
    @objc private func visitButtonTapped() {
        // Add button animation
        UIView.animate(withDuration: 0.1, animations: {
            self.visitButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.visitButton.transform = CGAffineTransform.identity
            }
        }
        
        // Add haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        // Show warning for suspicious or dangerous URLs
        if scanResult.resultType == .suspicious || scanResult.resultType == .dangerous {
            let alert = UIAlertController(
                title: "Czy na pewno chcesz otworzyć tę stronę?",
                message: "Ta strona może być niebezpieczna. Kontynuowanie może narazić Twoje urządzenie lub dane osobowe na ryzyko.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Anuluj", style: .cancel))
            alert.addAction(UIAlertAction(title: "Kontynuuj", style: .destructive) { [weak self] _ in
                self?.openURL()
            })
            
            present(alert, animated: true)
        } else {
            openURL()
        }
    }
    
    private func openURL() {
        guard let url = URL(string: scanResult.url) else { return }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    @objc private func reportButtonTapped() {
        // Add button animation
        UIView.animate(withDuration: 0.1, animations: {
            self.reportButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.reportButton.transform = CGAffineTransform.identity
            }
        }
        
        // Add haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        let alert = UIAlertController(
            title: "Zgłoś URL",
            message: "Czy chcesz zgłosić ten URL jako potencjalnie niebezpieczny?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Anuluj", style: .cancel))
        alert.addAction(UIAlertAction(title: "Zgłoś", style: .default) { [weak self] _ in
            self?.reportURL()
        })
        
        present(alert, animated: true)
    }
    
    private func reportURL() {
        // In a real app, this would send the report to a backend service
        
        let successAlert = UIAlertController(
            title: "Dziękujemy",
            message: "URL został zgłoszony do analizy. Dziękujemy za pomoc w walce z phishingiem!",
            preferredStyle: .alert
        )
        
        successAlert.addAction(UIAlertAction(title: "OK", style: .default))
        present(successAlert, animated: true)
    }
    
    @objc private func backToScanButtonTapped() {
        // Add button animation
        UIView.animate(withDuration: 0.1, animations: {
            self.backToScanButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.backToScanButton.transform = CGAffineTransform.identity
            }
        }
        
        // Add haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        navigationController?.popViewController(animated: true)
    }
}
