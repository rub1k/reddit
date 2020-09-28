//
//  RecentTableViewCell.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 28.09.2020.
//

import UIKit

class RecentTableViewCell: UITableViewCell {
    // MARK: Outlet

    @IBOutlet private weak var viewedLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var createdLabel: UILabel!
    @IBOutlet private weak var commentsLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var articleLabel: UILabel!

    // MARK: Private
    let photoImage = UIImage(systemName: "photo.on.rectangle.fill")
    // MARK: Override

    override func awakeFromNib() {
        super.awakeFromNib()

        viewedLabel.layer.cornerRadius = 4.0
        viewedLabel.clipsToBounds = true
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = photoImage
    }
}

// MARK: - ConfigurableView

extension RecentTableViewCell: ConfigurableView {
    func configure(with model: Blogpost) {
        articleLabel.text = model.articleText
        articleLabel.isHidden = model.articleText.isEmpty
        authorLabel.text = "Posted by \(model.author)"
        titleLabel.text = model.title
        createdLabel.text = model.formattedCreatedDate()
        commentsLabel.text = "\(model.commentsCount) Comments"
        thumbnailImageView.isHidden = !model.isThumbnailPresent

        if let url = model.imageURL {
            loadImage(with: url)
        }
    }

    private func loadImage(with url: URL) {
        thumbnailImageView.setImageWith(url: url) { [weak self] image, _ in
            guard let self = self else { return }

            if let image = image {
                UIView.transition(with: self.thumbnailImageView,
                                  duration: 0.75,
                                  options: .transitionCrossDissolve,
                                  animations: { self.thumbnailImageView.image = image },
                                  completion: nil)
            } else {
                self.thumbnailImageView.image = self.photoImage
            }
        }
    }
}
