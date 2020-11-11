//
//  ViewController.swift
//  Steller Viewer MVC
//
//  Created by plech on 02/11/2020.
//

import UIKit

class StoryCollectionViewController: UICollectionViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private static let columnCount = 2
    private static let cellAspectRatio = 1.87
    
    var storyPresenter: StoryPresenter!
    
    private var imageCache = [Int: UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "storyCollection.title".localized
        activityIndicator.startAnimating()
        storyPresenter.fetchStories() { [weak self] success, error in
            self?.activityIndicator.stopAnimating()
            guard success else {
                UIAlertController.presentSimpleAlert(on: self, title: "general.error".localized, message: error?.localizedDescription ?? "storyCollection.error".localized)
                return
            }
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension StoryCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        storyPresenter.storyCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let story = storyPresenter.story(at: indexPath.row)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryCollectionViewCell", for: indexPath) as? StoryCollectionViewCell else {
            assertionFailure("Missing cell definition.")
            return UICollectionViewCell()
        }
        cell.index = indexPath.row
        cell.nameLabel.text = story.username
        cell.likesLabel.text = story.likes.map { "❤️ \($0)" }
        cell.imageView.isHidden = true
        cell.activityIndicator.startAnimating()
        cacheImage(for: indexPath.row) { image in
            guard cell.index == indexPath.row else { return }
            cell.imageView.image = image
            cell.imageView.isHidden = false
            cell.activityIndicator.stopAnimating()
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension StoryCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            assertionFailure("Bad layout definition.")
            return CGSize.zero
        }
        let horizontalSpaces = CGFloat(StoryCollectionViewController.columnCount + 1) * layout.minimumInteritemSpacing
        let availableWidth = collectionView.frame.width - horizontalSpaces
        let cellWidth = availableWidth / CGFloat(StoryCollectionViewController.columnCount)
        let cellHeight = cellWidth * CGFloat(StoryCollectionViewController.cellAspectRatio)
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - Navigation
extension StoryCollectionViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "StoryDetail",
              let pageVC = segue.destination as? StoryPageViewController,
              let cell = sender as? StoryCollectionViewCell,
              let position = cell.index else {
            return
        }
        pageVC.position = position
    }
}

// MARK: - Private functions
private extension StoryCollectionViewController {
    func cacheImage(for index: Int, completion: @escaping (UIImage?) -> Void) {
        if let image = imageCache[index] {
            completion(image)
            return
        }
        storyPresenter.image(for: index, landscape: false) { [weak self] (data) in
            guard let data = data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            self?.imageCache[index] = image
            completion(image)
        }
    }
}
