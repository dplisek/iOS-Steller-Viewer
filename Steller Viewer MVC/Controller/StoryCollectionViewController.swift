//
//  ViewController.swift
//  Steller Viewer MVC
//
//  Created by plech on 02/11/2020.
//

import UIKit

class StoryCollectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private static let columnCount = 2
    private static let cellAspectRatio = 1.87
    
    private var stories = [Story]()
    private var imageCache = [URL: UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "storyCollection.title".localized
        fetchStories()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        imageCache.removeAll()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

// MARK: - UICollectionViewDataSource
extension StoryCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let story = stories[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryCollectionViewCell", for: indexPath) as? StoryCollectionViewCell,
              let storyId = story.id else {
            return UICollectionViewCell()
        }
        cell.storyId = storyId
        cell.nameLabel.text = story.user?.display_name
        cell.likesLabel.text = story.likes?.count.map { "❤️ \($0)" }
        cell.imageView.isHidden = true
        if let url = story.cover_src.flatMap({ URL(string: $0) }) {
            cell.activityIndicator.startAnimating()
            cacheImage(for: url) { image in
                guard cell.storyId == storyId else { return }
                cell.imageView.image = image
                cell.imageView.isHidden = false
                cell.activityIndicator.stopAnimating()
            }
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension StoryCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        let horizontalSpaces = CGFloat(StoryCollectionViewController.columnCount + 1) * layout.minimumInteritemSpacing
        let availableWidth = collectionView.frame.width - horizontalSpaces
        let cellWidth = availableWidth / CGFloat(StoryCollectionViewController.columnCount)
        let cellHeight = cellWidth * CGFloat(StoryCollectionViewController.cellAspectRatio)
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - Private functions
private extension StoryCollectionViewController {
    func fetchStories() {
        collectionView.isHidden = true
        activityIndicator.startAnimating()
        URLSession.shared.get(StoriesResponse.self, url: URLSession.Endpoints.stories) { [weak self] (response, error) in
            self?.collectionView.isHidden = false
            self?.activityIndicator.stopAnimating()
            guard let response = response else {
                UIAlertController.presentSimpleAlert(on: self, title: "general.error".localized, message: error?.localizedDescription ?? "storyCollection.error".localized)
                return
            }
            self?.stories = response.data ?? []
            self?.collectionView.reloadData()
        }
    }
    
    func cacheImage(for url: URL, completion: @escaping (UIImage?) -> Void) {
        if let image = imageCache[url] {
            completion(image)
            return
        }
        URLSession.shared.getAsData(url: url) { [weak self] (data, error) in
            guard let data = data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            self?.imageCache[url] = image
            completion(image)
        }
    }
}
