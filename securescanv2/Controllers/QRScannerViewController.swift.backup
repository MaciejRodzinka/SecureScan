import UIKit
import AVFoundation

class QRScannerViewController: UIViewController {
    
    // UI Components
    private let scannerView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView()
    private let instructionsLabel = UILabel()
    
    // Services
    private let qrScannerService = QRScannerService.shared
    private let urlScannerService = URLScannerService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkCameraPermission()
        
        // Navigate back with a swipe gesture
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        // Add a sophisticated pulsing animation to create a "scanning" effect
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 1.5
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.05
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.infinity
        scannerView.layer.add(pulseAnimation, forKey: "pulse")
        
        // Add scanner line animation
        let scanLine = UIView(frame: CGRect(x: 0, y: scannerView.bounds.minY, 
                                          width: scannerView.bounds.width, height: 2))
        scanLine.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.8, alpha: 0.8)
        scanLine.layer.shadowColor = UIColor.cyan.cgColor
        scanLine.layer.shadowOffset = CGSize(width: 0, height: 0)
        scanLine.layer.shadowOpacity = 1.0
        scanLine.layer.shadowRadius = 5.0
        view.addSubview(scanLine)
        
        // Setup vertical scanning animation
        UIView.animate(withDuration: 2.0, delay: 0.3, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
            scanLine.frame = CGRect(x: 0, y: self.scannerView.bounds.maxY - 2, 
                                   width: self.scannerView.bounds.width, height: 2)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Start with scanView at 90% size and fade in
        scannerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        scannerView.alpha = 0.7
        
        // Animate to full size with spring effect
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.7, 
                       initialSpringVelocity: 0.5, options: [], animations: {
            self.scannerView.transform = .identity
            self.scannerView.alpha = 1.0
        })
        
        qrScannerService.setupScanner(in: scannerView) { [weak self] result in
            self?.handleScanResult(result)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        qrScannerService.stopScanning()
    }
    
    // Process the scanned QR code result
    private func handleScanResult(_ result: String?) {
        guard let result = result else { return }
        
        // Stop the scanner to prevent multiple detections
        qrScannerService.stopScanning()
        
        // Add haptic feedback when QR code is detected
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
        
        // Flash animation to indicate successful scan
        let flashView = UIView(frame: view.bounds)
        flashView.backgroundColor = UIColor.white
        flashView.alpha = 0
        view.addSubview(flashView)
        
        // Quick flash effect
        UIView.animate(withDuration: 0.2, animations: {
            flashView.alpha = 0.8
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                flashView.alpha = 0
            }) { _ in
                flashView.removeFromSuperview()
                
                // Process QR code content using the correct method - oznaczamy źródło jako QR code
                self.urlScannerService.scanURL(result, sourceType: .qrCode) { [weak self] scanResult in
                    guard let self = self else { return }
                    
                    // Create result view controller
                    let resultVC = ScanResultViewController(scanResult: scanResult)
                    
                    // Navigate to result screen on the main thread
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(resultVC, animated: true)
                    }
                }
            }
        }
    }
    
    private func setupUI() {
        // Create a dynamic animated gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 1.0).cgColor,
            UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Add subtle animation to the gradient
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = [
            UIColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 1.0).cgColor,
            UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0).cgColor
        ]
        animation.toValue = [
            UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0).cgColor,
            UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0).cgColor
        ]
        animation.duration = 3.0
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        gradientLayer.add(animation, forKey: "gradientColorChange")
        
        title = "SecureScan"
        
        // Create a glowing title label
        let titleContainer = UIView()
        view.addSubview(titleContainer)
        titleContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let titleBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        titleBackgroundView.layer.cornerRadius = 20
        titleBackgroundView.layer.masksToBounds = true
        titleContainer.addSubview(titleBackgroundView)
        titleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        // Title label with glowing effect
        titleLabel.text = "Zeskanuj kod QR"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        
        // Add shadow for glowing effect
        titleLabel.layer.shadowColor = UIColor.cyan.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        titleLabel.layer.shadowOpacity = 0.8
        titleLabel.layer.shadowRadius = 10.0
        
        // Subtle pulse animation for the title
        let titlePulse = CABasicAnimation(keyPath: "shadowOpacity")
        titlePulse.duration = 2.0
        titlePulse.fromValue = 0.8
        titlePulse.toValue = 0.2
        titlePulse.autoreverses = true
        titlePulse.repeatCount = Float.infinity
        titleLabel.layer.add(titlePulse, forKey: "titlePulse")
        
        descriptionLabel.text = "Skieruj kamerę na kod QR"
        descriptionLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        titleContainer.addSubview(descriptionLabel)
        
        // Scanner view (camera feed) with rounded corners and glossy effect
        scannerView.backgroundColor = .black
        scannerView.layer.cornerRadius = 20
        scannerView.clipsToBounds = true
        
        // Add glossy overlay
        let glossyOverlay = UIView()
        glossyOverlay.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        glossyOverlay.layer.cornerRadius = 20
        
        // Add scanner container with depth effect
        let scannerContainer = UIView()
        scannerContainer.backgroundColor = .clear
        scannerContainer.layer.cornerRadius = 20
        scannerContainer.layer.shadowColor = UIColor(red: 0, green: 0.8, blue: 1, alpha: 0.8).cgColor
        scannerContainer.layer.shadowOffset = CGSize(width: 0, height: 0)
        scannerContainer.layer.shadowOpacity = 0.8
        scannerContainer.layer.shadowRadius = 10
        view.addSubview(scannerContainer)
        
        scannerContainer.addSubview(scannerView)
        scannerView.addSubview(glossyOverlay)
        
        // Fancy Activity Indicator
        let containerView = UIView()
        containerView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        containerView.layer.cornerRadius = 10
        view.addSubview(containerView)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = UIColor(red: 0, green: 0.8, blue: 1, alpha: 1.0)
        containerView.addSubview(activityIndicator)
        
        // Instructions with fancy styling
        let instructionsContainer = UIView()
        instructionsContainer.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        instructionsContainer.layer.cornerRadius = 15
        view.addSubview(instructionsContainer)
        
        let instructionsTitle = UILabel()
        instructionsTitle.text = "WSKAZÓWKI BEZPIECZEŃSTWA"
        instructionsTitle.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        instructionsTitle.textColor = UIColor(red: 0, green: 0.8, blue: 1, alpha: 1.0)
        instructionsTitle.textAlignment = .center
        instructionsContainer.addSubview(instructionsTitle)
        
        instructionsLabel.text = "• Nie skanuj niezaufanych kodów QR\n• Zawsze sprawdź, dokąd prowadzi kod\n• QR kody mogą prowadzić do złośliwych stron"
        instructionsLabel.font = UIFont.systemFont(ofSize: 14)
        instructionsLabel.textColor = .white
        instructionsLabel.textAlignment = .left
        instructionsLabel.numberOfLines = 0
        instructionsContainer.addSubview(instructionsLabel)
        
        // Apply constraints
        scannerContainer.translatesAutoresizingMaskIntoConstraints = false
        scannerView.translatesAutoresizingMaskIntoConstraints = false
        glossyOverlay.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        instructionsContainer.translatesAutoresizingMaskIntoConstraints = false
        instructionsTitle.translatesAutoresizingMaskIntoConstraints = false
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title container
            titleContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            scannerView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            scannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            scannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            scannerView.heightAnchor.constraint(equalTo: scannerView.widthAnchor), // Make it square
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: scannerView.bottomAnchor, constant: 24),
            
            instructionsLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 24),
            instructionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            instructionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            instructionsLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // Permission already granted
            setupQRScanner()
        case .notDetermined:
            // Request permission
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async {
                        self?.setupQRScanner()
                    }
                } else {
                    self?.showCameraPermissionDeniedAlert()
                }
            }
        case .denied, .restricted:
            // Permission denied
            showCameraPermissionDeniedAlert()
        @unknown default:
            break
        }
    }
    
    private func setupQRScanner() {
        qrScannerService.setupScanner(in: scannerView) { [weak self] scannedValue in
            guard let self = self, let value = scannedValue else { return }
            
            DispatchQueue.main.async {
                self.handleScannedQRCode(value)
            }
        }
        
        // Start scanning
        qrScannerService.startScanning()
    }
    
    private func handleScannedQRCode(_ value: String) {
        // Check if QR code contains a URL
        if let url = URL(string: value), url.scheme != nil, url.host != nil {
            // It's a URL, scan it
            activityIndicator.startAnimating()
            
            urlScannerService.scanURL(value) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    
                    // Add to scan history
                    self.urlScannerService.addToHistory(result)
                    
                    // Show results
                    let resultVC = ScanResultViewController(scanResult: result)
                    self.navigationController?.pushViewController(resultVC, animated: true)
                }
            }
        } else {
            // It's not a URL - just show the content
            let alert = UIAlertController(
                title: "Znaleziono treść w kodzie QR",
                message: "Zawartość kodu QR:\n\(value)",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                // Resume scanning after viewing
                self?.qrScannerService.startScanning()
            })
            present(alert, animated: true)
        }
    }
    
    private func showCameraPermissionDeniedAlert() {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(
                title: "Brak dostępu do kamery",
                message: "SmartGuardian potrzebuje dostępu do kamery, aby skanować kody QR. Możesz zmienić to w Ustawieniach.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Przejdź do Ustawień", style: .default) { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            })
            
            alert.addAction(UIAlertAction(title: "Anuluj", style: .cancel))
            
            self?.present(alert, animated: true)
        }
    }
}
