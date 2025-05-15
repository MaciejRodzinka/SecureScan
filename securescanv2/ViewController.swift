//
//  ViewController.swift
//  securescanv2
//
//  Created by Michał Szczygieł on 15/05/2025.
//

import UIKit

class ViewController: UIViewController {
    
    // Main dashboard UI elements
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let menuBackgroundView = UIView()
    private let scanLinkButton = UIButton(type: .system)
    private let scanQRButton = UIButton(type: .system)
    private let smsAnalyzerButton = UIButton(type: .system)
    private let educationButton = UIButton(type: .system)
    private let securityStatusView = UIView()
    private let securityStatusLabel = UILabel()
    
    // Recent scan results table
    private let recentScansTableView = UITableView()
    private var recentScans: [ScanResult] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        
        // Add animated particles for WOW effect
        addParticleEffect()
    }
    
    // Create floating particles in the background
    private func addParticleEffect() {
        let particleEmitter = CAEmitterLayer()
        particleEmitter.emitterPosition = CGPoint(x: view.bounds.width / 2.0, y: -50)
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize = CGSize(width: view.bounds.width, height: 1)
        
        // Create particles
        let cell = CAEmitterCell()
        cell.scale = 0.05
        cell.scaleRange = 0.02
        cell.emissionRange = .pi * 2.0
        cell.lifetime = 20.0
        cell.birthRate = 2
        cell.velocity = 30
        cell.velocityRange = 20
        cell.yAcceleration = 10
        cell.spin = 0.5
        cell.spinRange = 1.0
        cell.color = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 0.3).cgColor
        
        // Create a shield image for particles
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.setFill()
        UIBezierPath(ovalIn: CGRect(origin: .zero, size: size)).fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        cell.contents = image?.cgImage
        
        particleEmitter.emitterCells = [cell]
        view.layer.insertSublayer(particleEmitter, at: 1)
    }
    
    // Button tap animation
    private func animateButtonTap(_ button: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                button.transform = CGAffineTransform.identity
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateRecentScans()
    }
    
    private func setupUI() {
        // Apply an elegant gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 1.0).cgColor,
            UIColor(red: 0.1, green: 0.1, blue: 0.25, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Navigation bar with blur effect
        title = "SecureScan"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 0.0, green: 0.47, blue: 0.8, alpha: 1.0)
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.tintColor = .white
        } else {
            navigationController?.navigationBar.barTintColor = UIColor(red: 0.0, green: 0.47, blue: 0.8, alpha: 1.0)
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        }
        
        // Logo
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(systemName: "shield.checkerboard")
        logoImageView.tintColor = UIColor(red: 0.0, green: 0.47, blue: 0.8, alpha: 1.0)
        view.addSubview(logoImageView)
        
        // Menu background
        menuBackgroundView.backgroundColor = .white
        menuBackgroundView.layer.cornerRadius = 20
        menuBackgroundView.layer.shadowColor = UIColor.black.cgColor
        menuBackgroundView.layer.shadowOpacity = 0.1
        menuBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 5)
        menuBackgroundView.layer.shadowRadius = 10
        view.addSubview(menuBackgroundView)
        
        // Title and subtitle
        titleLabel.text = "SecureScan"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.0, green: 0.47, blue: 0.8, alpha: 1.0)
        view.addSubview(titleLabel)
        
        subtitleLabel.text = "Twoja ochrona przed oszustwami online"
        subtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        subtitleLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.45, alpha: 1.0)
        view.addSubview(subtitleLabel)
        
        // Security status view
        securityStatusView.backgroundColor = UIColor(red: 0.0, green: 0.75, blue: 0.34, alpha: 1.0)
        securityStatusView.layer.cornerRadius = 15
        securityStatusView.layer.shadowColor = UIColor.black.cgColor
        securityStatusView.layer.shadowOpacity = 0.2
        securityStatusView.layer.shadowOffset = CGSize(width: 0, height: 3)
        securityStatusView.layer.shadowRadius = 5
        view.addSubview(securityStatusView)
        
        securityStatusLabel.text = "Twoje urządzenie jest chronione"
        securityStatusLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        securityStatusLabel.textColor = .white
        securityStatusLabel.textAlignment = .center
        securityStatusView.addSubview(securityStatusLabel)
        
        // Main action buttons
        setupMenuButton(scanLinkButton, title: "Skanuj Link", icon: "link.circle.fill", color: UIColor(red: 0.0, green: 0.47, blue: 0.8, alpha: 1.0))
        menuBackgroundView.addSubview(scanLinkButton)
        
        setupMenuButton(scanQRButton, title: "Skanuj Kod QR", icon: "qrcode.viewfinder", color: UIColor(red: 0.4, green: 0.2, blue: 0.6, alpha: 1.0))
        menuBackgroundView.addSubview(scanQRButton)
        
        setupMenuButton(smsAnalyzerButton, title: "Analizator SMS", icon: "message.fill", color: UIColor(red: 0.85, green: 0.35, blue: 0.0, alpha: 1.0))
        menuBackgroundView.addSubview(smsAnalyzerButton)
        
        setupMenuButton(educationButton, title: "Edukacja", icon: "book.fill", color: UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1.0))
        menuBackgroundView.addSubview(educationButton)
        
        // Recent scans table
        recentScansTableView.register(UITableViewCell.self, forCellReuseIdentifier: "scanCell")
        recentScansTableView.delegate = self
        recentScansTableView.dataSource = self
        recentScansTableView.layer.cornerRadius = 15
        recentScansTableView.layer.masksToBounds = true
        recentScansTableView.tableFooterView = UIView()
        recentScansTableView.backgroundColor = .white
        recentScansTableView.separatorStyle = .none
        view.addSubview(recentScansTableView)
    }
    
    private func setupMenuButton(_ button: UIButton, title: String, icon: String, color: UIColor) {
        // Create a container view for the button content
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(containerView)
        
        // Setup the icon
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: icon)
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white
        iconView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconView)
        
        // Setup the title label
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        // Layout for container view
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            
            iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        // Button styling
        button.backgroundColor = color
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        
        // Add shadow effect (outside clipsToBounds)
        let shadowView = UIView(frame: .zero)
        shadowView.backgroundColor = .clear
        shadowView.layer.shadowColor = color.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowRadius = 6
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        
        button.superview?.insertSubview(shadowView, belowSubview: button)
        
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: button.bounds, cornerRadius: 12).cgPath
        
        button.addTarget(self, action: #selector(menuButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        menuBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        securityStatusView.translatesAutoresizingMaskIntoConstraints = false
        securityStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        scanLinkButton.translatesAutoresizingMaskIntoConstraints = false
        scanQRButton.translatesAutoresizingMaskIntoConstraints = false
        smsAnalyzerButton.translatesAutoresizingMaskIntoConstraints = false
        educationButton.translatesAutoresizingMaskIntoConstraints = false
        recentScansTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Logo
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 60),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Menu background
            menuBackgroundView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            menuBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            menuBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            menuBackgroundView.heightAnchor.constraint(equalToConstant: 320),
            
            // Security status view
            securityStatusView.topAnchor.constraint(equalTo: menuBackgroundView.bottomAnchor, constant: 20),
            securityStatusView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            securityStatusView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            securityStatusView.heightAnchor.constraint(equalToConstant: 50),
            
            // Security status label
            securityStatusLabel.centerXAnchor.constraint(equalTo: securityStatusView.centerXAnchor),
            securityStatusLabel.centerYAnchor.constraint(equalTo: securityStatusView.centerYAnchor),
            securityStatusLabel.leadingAnchor.constraint(equalTo: securityStatusView.leadingAnchor, constant: 10),
            securityStatusLabel.trailingAnchor.constraint(equalTo: securityStatusView.trailingAnchor, constant: -10),
            
            // Scan Link Button
            scanLinkButton.topAnchor.constraint(equalTo: menuBackgroundView.topAnchor, constant: 20),
            scanLinkButton.leadingAnchor.constraint(equalTo: menuBackgroundView.leadingAnchor, constant: 20),
            scanLinkButton.trailingAnchor.constraint(equalTo: menuBackgroundView.trailingAnchor, constant: -20),
            scanLinkButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Scan QR Button
            scanQRButton.topAnchor.constraint(equalTo: scanLinkButton.bottomAnchor, constant: 15),
            scanQRButton.leadingAnchor.constraint(equalTo: menuBackgroundView.leadingAnchor, constant: 20),
            scanQRButton.trailingAnchor.constraint(equalTo: menuBackgroundView.trailingAnchor, constant: -20),
            scanQRButton.heightAnchor.constraint(equalToConstant: 60),
            
            // SMS Analyzer Button
            smsAnalyzerButton.topAnchor.constraint(equalTo: scanQRButton.bottomAnchor, constant: 15),
            smsAnalyzerButton.leadingAnchor.constraint(equalTo: menuBackgroundView.leadingAnchor, constant: 20),
            smsAnalyzerButton.trailingAnchor.constraint(equalTo: menuBackgroundView.trailingAnchor, constant: -20),
            smsAnalyzerButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Education Button
            educationButton.topAnchor.constraint(equalTo: smsAnalyzerButton.bottomAnchor, constant: 15),
            educationButton.leadingAnchor.constraint(equalTo: menuBackgroundView.leadingAnchor, constant: 20),
            educationButton.trailingAnchor.constraint(equalTo: menuBackgroundView.trailingAnchor, constant: -20),
            educationButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Recent scans table
            recentScansTableView.topAnchor.constraint(equalTo: securityStatusView.bottomAnchor, constant: 20),
            recentScansTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recentScansTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            recentScansTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        // Actions now handled via menuButtonTapped(_:)
    }
    
    private func updateRecentScans() {
        // Get recent scans with a smooth animation
        recentScans = URLScannerService.shared.getScanHistory().prefix(5).map { $0 }
        
        UIView.transition(with: recentScansTableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: {
            self.recentScansTableView.reloadData()
        })
    }
    
    // MARK: - Actions
    
    // Add a custom animation when button is tapped
    @objc private func menuButtonTapped(_ sender: UIButton) {
        animateButtonTap(sender)
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        if sender == scanLinkButton {
            let linkScannerVC = LinkScannerViewController()
            navigationController?.pushViewController(linkScannerVC, animated: true)
        } else if sender == scanQRButton {
            let qrScannerVC = QRScannerViewController()
            navigationController?.pushViewController(qrScannerVC, animated: true)
        } else if sender == smsAnalyzerButton {
            let smsAnalyzerVC = SMSAnalyzerViewController()
            navigationController?.pushViewController(smsAnalyzerVC, animated: true)
        } else if sender == educationButton {
            let educationVC = EducationViewController()
            navigationController?.pushViewController(educationVC, animated: true)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recentScans.isEmpty {
            return 1 // Show a "No scans yet" cell
        }
        return recentScans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scanCell", for: indexPath)
        
        if recentScans.isEmpty {
            cell.textLabel?.text = "Brak ostatnich skanowań"
            cell.detailTextLabel?.text = nil
            cell.imageView?.image = nil
            return cell
        }
        
        let scan = recentScans[indexPath.row]
        cell.textLabel?.text = scan.url
        
        // Format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        cell.detailTextLabel?.text = dateFormatter.string(from: scan.scanDate)
        
        // Set appropriate icon based on result type
        switch scan.resultType {
        case .safe:
            cell.imageView?.image = UIImage(systemName: "checkmark.shield.fill")
            cell.imageView?.tintColor = .systemGreen
        case .suspicious:
            cell.imageView?.image = UIImage(systemName: "exclamationmark.triangle.fill")
            cell.imageView?.tintColor = .systemYellow
        case .dangerous:
            cell.imageView?.image = UIImage(systemName: "xmark.shield.fill")
            cell.imageView?.tintColor = .systemRed
        case .unknown:
            cell.imageView?.image = UIImage(systemName: "questionmark.circle.fill")
            cell.imageView?.tintColor = .systemGray
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ostatnie skanowania"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Don't do anything if there are no scans
        if recentScans.isEmpty {
            return
        }
        
        // Stare obiekty ScanResult z historii mogą nie mieć pola sourceType, więc tworzymy nowy obiekt
        // z wszystkimi wymaganymi polami
        let oldScan = recentScans[indexPath.row]
        
        // Tworzymy nowy obiekt ScanResult z dodanym polem sourceType (zakładamy .manual jako domyślne)
        let updatedScan = ScanResult(
            url: oldScan.url,
            resultType: oldScan.resultType,
            scanDate: oldScan.scanDate,
            details: oldScan.details,
            isPhishing: oldScan.isPhishing,
            contentCategory: oldScan.contentCategory,
            sourceType: .manual, // Zakładamy, że stare skany były wprowadzane ręcznie
            educationalTip: oldScan.educationalTip
        )
        
        let scanResultVC = ScanResultViewController(scanResult: updatedScan)
        navigationController?.pushViewController(scanResultVC, animated: true)
    }
}

