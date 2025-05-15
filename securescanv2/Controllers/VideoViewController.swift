import UIKit
import AVKit
import WebKit

class VideoViewController: UIViewController {
    
    // UI Components
    private let videoContainerView = UIView()
    private var playerViewController: AVPlayerViewController?
    private var webView: WKWebView?
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView()
    
    // Data
    private let content: EducationalContent
    
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
        loadVideo()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Wideo"
        
        // Video container
        videoContainerView.backgroundColor = .black
        videoContainerView.layer.cornerRadius = 12
        videoContainerView.clipsToBounds = true
        view.addSubview(videoContainerView)
        
        // Title
        titleLabel.text = content.title
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        
        // Description
        descriptionLabel.text = content.description
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)
        
        // Activity Indicator
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .white
        videoContainerView.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        videoContainerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Video container
            videoContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            videoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            videoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            videoContainerView.heightAnchor.constraint(equalTo: videoContainerView.widthAnchor, multiplier: 9.0/16.0), // 16:9 aspect ratio
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: videoContainerView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            // Activity indicator
            activityIndicator.centerXAnchor.constraint(equalTo: videoContainerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: videoContainerView.centerYAnchor)
        ])
    }
    
    private func loadVideo() {
        activityIndicator.startAnimating()
        
        let videoURLString = content.content
        
        // Check if it's a YouTube URL
        if videoURLString.contains("youtube.com") || videoURLString.contains("youtu.be") {
            setupYouTubeWebView(videoURLString)
        } else if let url = URL(string: videoURLString) {
            // Regular video URL
            setupAVPlayer(url)
        } else {
            showError("Nie można załadować wideo: Nieprawidłowy URL")
        }
    }
    
    private func setupAVPlayer(_ url: URL) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        // Add as child view controller
        addChild(playerViewController)
        playerViewController.view.frame = videoContainerView.bounds
        videoContainerView.addSubview(playerViewController.view)
        playerViewController.didMove(toParent: self)
        
        // Store reference
        self.playerViewController = playerViewController
        
        // Setup player
        playerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerViewController.view.topAnchor.constraint(equalTo: videoContainerView.topAnchor),
            playerViewController.view.leadingAnchor.constraint(equalTo: videoContainerView.leadingAnchor),
            playerViewController.view.trailingAnchor.constraint(equalTo: videoContainerView.trailingAnchor),
            playerViewController.view.bottomAnchor.constraint(equalTo: videoContainerView.bottomAnchor)
        ])
        
        // Start playback
        player.play()
        activityIndicator.stopAnimating()
    }
    
    private func setupYouTubeWebView(_ urlString: String) {
        // Extract YouTube video ID
        var videoID = ""
        
        if let youtubeURL = URL(string: urlString) {
            if urlString.contains("youtube.com") {
                if let queryItems = URLComponents(url: youtubeURL, resolvingAgainstBaseURL: false)?.queryItems {
                    for item in queryItems where item.name == "v" {
                        videoID = item.value ?? ""
                        break
                    }
                }
            } else if urlString.contains("youtu.be") {
                videoID = youtubeURL.lastPathComponent
            }
        }
        
        if videoID.isEmpty {
            showError("Nie można załadować wideo: Nieprawidłowy URL YouTube")
            return
        }
        
        // Create embedded YouTube HTML
        let embedHTML = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
            <style>
                body { margin: 0; background-color: #000; }
                .container { position: relative; width: 100%; padding-top: 56.25%; }
                iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
            </style>
        </head>
        <body>
            <div class="container">
                <iframe src="https://www.youtube.com/embed/\(videoID)?playsinline=1&autoplay=1" frameborder="0" allowfullscreen></iframe>
            </div>
        </body>
        </html>
        """
        
        // Setup webview
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.frame = videoContainerView.bounds
        webView.backgroundColor = .black
        videoContainerView.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: videoContainerView.topAnchor),
            webView.leadingAnchor.constraint(equalTo: videoContainerView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: videoContainerView.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: videoContainerView.bottomAnchor)
        ])
        
        self.webView = webView
        webView.loadHTMLString(embedHTML, baseURL: nil)
    }
    
    private func showError(_ message: String) {
        activityIndicator.stopAnimating()
        
        let alert = UIAlertController(title: "Błąd", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // Mark as completed when viewed
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        EducationService.shared.markAsCompleted(contentId: content.id)
    }
}

// MARK: - WKNavigationDelegate
extension VideoViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showError("Nie można załadować wideo: \(error.localizedDescription)")
    }
}
