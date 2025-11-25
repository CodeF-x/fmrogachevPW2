import UIKit

final class WishEventCell: UICollectionViewCell {
    static let reuseIdentifier = "WishEventCell"
    
    private let wrapView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let startDateLabel: UILabel = UILabel()
    private let endDateLabel: UILabel = UILabel()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureWrap()
        configureTitleLabel()
        configureDescriptionLabel()
        configureStartDateLabel()
        configureEndDateLabel()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell Configuration
    func configure(with event: WishEventModel) {
        titleLabel.text = event.title
        descriptionLabel.text = event.description
        startDateLabel.text = "Start Date: \(event.startDate)"
        endDateLabel.text = "End Date: \(event.endDate)"
    }
    
    // MARK: - UI Configuration
    private func configureWrap() {
        addSubview(wrapView)
        wrapView.translatesAutoresizingMaskIntoConstraints = false
        wrapView.layer.cornerRadius = 8
        wrapView.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            wrapView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            wrapView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            wrapView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            wrapView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
    }
    
    private func configureTitleLabel() {
        wrapView.addSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: wrapView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: wrapView.leadingAnchor, constant: 8)
        ])
    }
    
    private func configureDescriptionLabel() {
        wrapView.addSubview(descriptionLabel)
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: wrapView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: wrapView.trailingAnchor, constant: -8)
        ])
    }
    
    private func configureStartDateLabel() {
        wrapView.addSubview(startDateLabel)
        startDateLabel.font = .systemFont(ofSize: 12)
        startDateLabel.textColor = .gray
        startDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startDateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            startDateLabel.leadingAnchor.constraint(equalTo: wrapView.leadingAnchor, constant: 8)
        ])
    }
    
    private func configureEndDateLabel() {
        wrapView.addSubview(endDateLabel)
        endDateLabel.font = .systemFont(ofSize: 12)
        endDateLabel.textColor = .gray
        endDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            endDateLabel.topAnchor.constraint(equalTo: startDateLabel.bottomAnchor, constant: 2),
            endDateLabel.leadingAnchor.constraint(equalTo: wrapView.leadingAnchor, constant: 8),
            endDateLabel.bottomAnchor.constraint(lessThanOrEqualTo: wrapView.bottomAnchor, constant: -8)
        ])
    }
}
