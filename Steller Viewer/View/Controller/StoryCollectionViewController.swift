//
//  StoryCollectionViewController.swift
//  Steller Viewer MVC
//
//  Created by plech on 02/11/2020.
//

import UIKit
import RxSwift

class StoryCollectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private static let columnCount = 2
    private static let cellAspectRatio = 1.87

    var storiesViewModel: StoriesViewModel!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "storyCollection.title".localized
        storiesViewModel.stories.asDriver(onErrorJustReturn: [StoryViewModel]())
            .drive(collectionView.rx.items(cellIdentifier: "StoryCollectionViewCell")) { row, model, cell in
                guard let cell = cell as? StoryCollectionViewCell else {
                    assertionFailure("Bad cell definition.")
                    return
                }
                cell.index = row
                model.username.asDriver(onErrorJustReturn: nil)
                    .drive(cell.nameLabel.rx.text)
                    .disposed(by: cell.disposeBag)
                model.likes.asDriver(onErrorJustReturn: nil)
                    .map { likes in likes.map { "❤️ \($0)" } }
                    .drive(cell.likesLabel.rx.text)
                    .disposed(by: cell.disposeBag)
                model.image.asDriver(onErrorJustReturn: nil)
                    .drive(cell.imageView.rx.image)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        storiesViewModel.refresh()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
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
