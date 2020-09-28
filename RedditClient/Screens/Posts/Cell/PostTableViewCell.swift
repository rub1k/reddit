//
//  PostTableViewCell.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 27.09.2020.
//

import UIKit

protocol PostTableViewCellDelegate: class {
    func imageDidPress(at cell: UITableViewCell)
}

class PostTableViewCell: UITableViewCell {
    private struct Constants {
        static let imageViewCornerRadius: CGFloat = 4
        static let containerViewCornerRadius: CGFloat = 10
    }

    // MARK: Public

    weak var delegate: PostTableViewCellDelegate?

    // MARK: Outlets

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var createdLabel: UILabel!
    @IBOutlet private weak var commentsLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var articleLabel: UILabel!

    // MARK: Private

    private let tapSelector: Selector = #selector(imageTapped(tapGestureRecognizer:))

    // MARK: Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        thumbnailImageView.layer.cornerRadius = Constants.imageViewCornerRadius
        containerView.layer.cornerRadius = Constants.containerViewCornerRadius

        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: tapSelector)
//        tapGestureRecognizer.isEnabled = false
        thumbnailImageView.isUserInteractionEnabled = false
        thumbnailImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
    }
}

// MARK: - ConfigurableView

extension PostTableViewCell: ConfigurableView {
    func configure(with model: Blogpost) {
        articleLabel.text = model.articleText
        articleLabel.isHidden = model.articleText.isEmpty
        authorLabel.text = "Posted by \(model.author)"
        titleLabel.text = model.title
        createdLabel.text = model.formattedCreatedDate()
        commentsLabel.text = "\(model.commentsCount) Comments"
        thumbnailImageView.isHidden = !model.isThumbnailPresent

        if model.isThumbnailPresent, let url = model.thumbnailURL {
            loadImage(with: url)
        }
    }
}

// MARK: - Private

private extension PostTableViewCell {
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.imageDidPress(at: self)
    }

    func loadImage(with url: URL) {
        thumbnailImageView.setImageWith(url: url) { [weak self] image, _ in
            guard let self = self else { return }
            self.thumbnailImageView.isUserInteractionEnabled = image != nil
            self.thumbnailImageView.image = image
        }
    }
}
