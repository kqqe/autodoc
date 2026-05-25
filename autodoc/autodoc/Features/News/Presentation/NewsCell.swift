//
//  NewsCell.swift
//  autodoc
//
//  Created by Anatoliy on 19.05.2026.
//

import UIKit

final class NewsCell: UICollectionViewCell {
    static let reuseIdentifier = "NewsCell"

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.numberOfLines = 3
        return label
    }()

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 8
        return view
    }()

    private var listImageHeightConstraint: NSLayoutConstraint!
    private var gridImageAspectConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.isHidden = false
        titleLabel.text = nil
        descriptionLabel.text = nil
        descriptionLabel.isHidden = false
        listImageHeightConstraint.isActive = false
        gridImageAspectConstraint.isActive = false
    }

    private func setupUI() {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 16
        container.layer.masksToBounds = true

        contentView.addSubview(container)
        container.addSubview(stackView)

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)

        listImageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 160)
        gridImageAspectConstraint = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),

            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }

    func configureList(with item: NewsItem) {
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        descriptionLabel.isHidden = false
        imageView.isHidden = item.image == nil
        imageView.image = item.image

        gridImageAspectConstraint.isActive = false
        listImageHeightConstraint.isActive = true
    }

    func configureGrid(with item: NewsItem) {
        titleLabel.text = item.title
        descriptionLabel.isHidden = true
        imageView.isHidden = item.image == nil
        imageView.image = item.image

        listImageHeightConstraint.isActive = false
        gridImageAspectConstraint.isActive = true
    }
}
