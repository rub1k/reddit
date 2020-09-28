//
//  ImagePreviewViewController.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 27.09.2020.
//

import Photos
import UIKit

class ImagePreviewViewController: UIViewController, ViewModelConfigurable {
    // MARK: ViewModelConfigurable
    
    var viewModel: ImagePreviewViewModel!
    
    func configure(with viewModel: ImagePreviewViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Outlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var saveButton: UIButton! {
        didSet {
            saveButton.layer.cornerRadius = 10
            saveButton.clipsToBounds = true
        }
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.isEnabled = false
        loadImage()
    }
    
    // MARK: Actions
    
    @IBAction private func saveDidPress(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        
        let okHandler = {
            UIImageWriteToSavedPhotosAlbum(image, self,
                                           #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        present(UIAlertController.imageSaveAlert(okHandler: okHandler), animated: true)
    }
}

// MARK: - Private

private extension ImagePreviewViewController {
    func loadImage() {
        imageView.setImageWith(url: viewModel.imageURL) { [weak self] image, _ in
            guard let self = self else { return }
            self.imageView.image = image
            self.saveButton.isEnabled = true
        }
    }
    
    @objc func image(_ image: UIImage,
                     didFinishSavingWithError error: Error?,
                     contextInfo: UnsafeRawPointer)
    {
        var alert: UIAlertController!
        if let error = error {
            alert = UIAlertController.infoAlert(title: "Save error", message: error.localizedDescription)
        } else {
            alert = UIAlertController.infoAlert(title: "Saved!", message: "Image has been saved.")
        }
        present(alert, animated: true)
    }
}
