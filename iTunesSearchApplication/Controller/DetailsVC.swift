//
//  DetailsVC.swift
//  iTunesSearchApplication
//
//  Created by Nicholas Repaci on 8/28/21.
//

import UIKit

class DetailsVC: UIViewController {
  
  @IBOutlet weak var appDetailLabel: UILabel!
  @IBOutlet weak var appImage: UIImageView!
  @IBOutlet weak var appNameLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  let customCell = CustomTableCell()
  
  var collectionViewData: [[String]] = [[String]].init()
  var detailLabel: String?
  var appIcon: UIImage?
  var appName: String?
  var averageRating: Double?
  var testString: String?
  var fileSize: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    appImage.layer.cornerRadius = 25
    appDetailLabel.text = detailLabel
    appImage.image = appIcon
    appNameLabel.text = appName
    
    collectionView.dataSource = self
    collectionView.delegate = self
    
    registerNib()
  }
  // MARK: - Navigation
  
  //  func appendDataToCollectionArray() {
  //    collectionViewData.append("\(averageRating)" ?? "error appending")
  //    collectionView.reloadData()
  //  }
  
  func registerNib() {
    let nib = UINib(nibName: CollectionViewCell.nibName, bundle: nil)
    collectionView?.register(nib, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
    if let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
      flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
    }
  }
}

extension DetailsVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionViewData.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionViewCell {
      //gets data from index 0 & 1 for each indexpath.row
      //0 is manually entered field name, 1 is data from api
      let name = collectionViewData[indexPath.row][0]
      let detail = collectionViewData[indexPath.row][1]
      cell.configureCell(name: name, detail: detail)
      return cell
    }
    return UICollectionViewCell()
  }
}

extension DetailsVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    guard let cell: CollectionViewCell = Bundle.main.loadNibNamed(CollectionViewCell.nibName, owner: self, options: nil)?.first as? CollectionViewCell else {
           return CGSize.zero
    }
    cell.configureCell(name: collectionViewData[indexPath.row][0], detail: collectionViewData[indexPath.row][1])
    cell.setNeedsLayout()
    cell.layoutIfNeeded()
    let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    return CGSize(width: size.width, height: 30)
  }
}
