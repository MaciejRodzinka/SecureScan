import UIKit
import WebKit

class EducationViewController: UIViewController {
    
    // UI Components
    private let segmentedControl = UISegmentedControl()
    private let tableView = UITableView()
    private let emptyStateView = UIView()
    
    // Data
    private var allContent: [EducationalContent] = []
    private var filteredContent: [EducationalContent] = []
    private var contentType: ContentType = .article
    
    // Services
    private let educationService = EducationService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadContent()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Edukacja"
        
        // Segmented control for filtering content
        segmentedControl.insertSegment(withTitle: "Artykuły", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Quizy", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Wideo", at: 2, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        view.addSubview(segmentedControl)
        
        // Table view for content list
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EducationCell.self, forCellReuseIdentifier: "EducationCell")
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .singleLine
        view.addSubview(tableView)
        
        // Empty state view
        setupEmptyStateView()
    }
    
    private func setupEmptyStateView() {
        emptyStateView.isHidden = true
        view.addSubview(emptyStateView)
        
        // Empty state image
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "book.closed")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray3
        emptyStateView.addSubview(imageView)
        
        // Empty state label
        let label = UILabel()
        label.text = "Nie znaleziono treści edukacyjnych"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        emptyStateView.addSubview(label)
        
        // Layout
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor, constant: -30),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupConstraints() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Segmented control
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Table view
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Empty state view
            emptyStateView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func loadContent() {
        educationService.loadContent { [weak self] content in
            guard let self = self else { return }
            
            self.allContent = content
            self.filterContent()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.updateEmptyState()
            }
        }
    }
    
    private func filterContent() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            contentType = .article
        case 1:
            contentType = .quiz
        case 2:
            contentType = .video
        default:
            contentType = .article
        }
        
        filteredContent = allContent.filter { $0.contentType == contentType }
    }
    
    private func updateEmptyState() {
        emptyStateView.isHidden = !filteredContent.isEmpty
        tableView.isHidden = filteredContent.isEmpty
    }
    
    @objc private func segmentChanged() {
        filterContent()
        tableView.reloadData()
        updateEmptyState()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension EducationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EducationCell", for: indexPath) as! EducationCell
        
        let content = filteredContent[indexPath.row]
        cell.configure(with: content)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let content = filteredContent[indexPath.row]
        
        switch content.contentType {
        case .article:
            let articleVC = ArticleViewController(content: content)
            navigationController?.pushViewController(articleVC, animated: true)
        case .quiz:
            let quizVC = QuizViewController(content: content)
            navigationController?.pushViewController(quizVC, animated: true)
        case .video:
            let videoVC = VideoViewController(content: content)
            navigationController?.pushViewController(videoVC, animated: true)
        }
    }
}

// MARK: - Custom Cell
class EducationCell: UITableViewCell {
    private let containerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let completedBadge = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        // Container view
        containerView.backgroundColor = .systemGray6
        containerView.layer.cornerRadius = 12
        contentView.addSubview(containerView)
        
        // Icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .systemBlue
        containerView.addSubview(iconImageView)
        
        // Title
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.numberOfLines = 2
        containerView.addSubview(titleLabel)
        
        // Description
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2
        containerView.addSubview(descriptionLabel)
        
        // Completed badge
        completedBadge.backgroundColor = .systemGreen
        completedBadge.layer.cornerRadius = 8
        completedBadge.isHidden = true
        
        let checkmarkImage = UIImageView(image: UIImage(systemName: "checkmark"))
        checkmarkImage.tintColor = .white
        checkmarkImage.contentMode = .scaleAspectFit
        completedBadge.addSubview(checkmarkImage)
        
        containerView.addSubview(completedBadge)
        
        // Layout
        containerView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        completedBadge.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Icon
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            // Completed badge
            completedBadge.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            completedBadge.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            completedBadge.widthAnchor.constraint(equalToConstant: 24),
            completedBadge.heightAnchor.constraint(equalToConstant: 24),
            
            // Checkmark
            checkmarkImage.centerXAnchor.constraint(equalTo: completedBadge.centerXAnchor),
            checkmarkImage.centerYAnchor.constraint(equalTo: completedBadge.centerYAnchor),
            checkmarkImage.widthAnchor.constraint(equalToConstant: 12),
            checkmarkImage.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    func configure(with content: EducationalContent) {
        titleLabel.text = content.title
        descriptionLabel.text = content.description
        completedBadge.isHidden = !content.isCompleted
        
        // Set icon based on content type
        switch content.contentType {
        case .article:
            iconImageView.image = UIImage(systemName: "doc.text.fill")
            iconImageView.tintColor = .systemBlue
        case .quiz:
            iconImageView.image = UIImage(systemName: "questionmark.circle.fill")
            iconImageView.tintColor = .systemIndigo
        case .video:
            iconImageView.image = UIImage(systemName: "play.circle.fill")
            iconImageView.tintColor = .systemRed
        }
    }
}
