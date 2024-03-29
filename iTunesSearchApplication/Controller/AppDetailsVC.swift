//
//  DetailsVC.swift
//  iTunesSearchApplication
//
//  Created by Nicholas Repaci on 8/28/21.
//

import UIKit
import Foundation

class DetailsVC: UIViewController {
  
  @IBOutlet weak var appDetailLabel: UILabel!
  @IBOutlet weak var appImage: UIImageView!
  @IBOutlet weak var appNameLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var imageCollectionView: UICollectionView!
  @IBOutlet weak var appPriceLabel: UILabel!
  let customCell = CustomTableCell()
  var cgSizeToReturn = CGSize.init()
  
  var collectionViewData: [[String]] = [[String]]()
  var imageCollectionViewData: [Data] = [Data]()
  var detailLabel: String?
  var appIcon: UIImage?
  var appName: String?
  var averageRating: Double?
  var testString: String?
  var fileSize: String?
  var appPrice: String?
  var appCategory: String?
  var version: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    appImage.layer.cornerRadius = 25
    appDetailLabel.text = detailLabel
    appImage.image = appIcon
    appNameLabel.text = appName
    appPriceLabel.text = appPrice
    
    collectionView.dataSource = self
    collectionView.delegate = self
    imageCollectionView.delegate = self
    imageCollectionView.dataSource = self
    
    registerNib()
    registerImageNib()
    
//  collectionView.layer.borderWidth = 0.5
//  collectionView.layer.borderColor = UIColor.gray.cgColor
    
    appNameLabel.adjustsFontSizeToFitWidth = true
    appPriceLabel.clipsToBounds = true
    appPriceLabel.backgroundColor = UIColor.init(red: 175/255, green: 185/255, blue: 186/255, alpha: 1)
    appPriceLabel.layer.cornerRadius = 15
    
//    if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//          //flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//      imageCollectionView.autoresizingMask = .flexibleHeight
//        }
//    if let flowLayout = imageCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//          flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
       // }
  }
  
  // MARK: - FUNCTIONS
  func registerNib() {
    let nib = UINib(nibName: CollectionViewCell.nibName, bundle: nil)
    collectionView?.register(nib, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
    if let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
      flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
    }
  }
  
  func registerImageNib() {
    let nib = UINib(nibName: ImagesCollectionViewCell.nibName, bundle: nil)
    imageCollectionView?.register(nib, forCellWithReuseIdentifier: ImagesCollectionViewCell.reuseIdentifier)
    if let flowLayout = self.imageCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
      flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
    }
  }
}

// MARK: - EXTENSIONS

extension DetailsVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    var valueToReturn = 0
    
    //Distinguishes between the two collection views and returns data to appropriate collection view
    if (collectionView == self.collectionView) {
      valueToReturn = collectionViewData.count
    } else if (collectionView == self.imageCollectionView) {
      valueToReturn = imageCollectionViewData.count
    }
    return valueToReturn
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    //Distinguishes between the two collection views and returns data to appropriate collection view
    if (collectionView == self.collectionView) {
      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionViewCell {
        //gets data from index 0 & 1 for each indexpath.row
        //0 is manually entered field name, 1 is data from api
        let name = collectionViewData[indexPath.row][0]
        let detail = collectionViewData[indexPath.row][1]
        cell.configureCell(name: name, detail: detail)
        return cell
      }
    } else if (collectionView == self.imageCollectionView) {
      if let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: ImagesCollectionViewCell.reuseIdentifier, for: indexPath) as? ImagesCollectionViewCell {
        let image = imageCollectionViewData[indexPath.row]
        cell.configureCell(image: (UIImage(data: image)!))
        cell.layer.cornerRadius = 10
        return cell
      }
    }
    return UICollectionViewCell()
  }
}

extension DetailsVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    //Distinguishes between the two collection views and returns data to appropriate collection view
    if (collectionView == self.collectionView) {
      guard let cell: CollectionViewCell = Bundle.main.loadNibNamed(CollectionViewCell.nibName, owner: self, options: nil)?.first as? CollectionViewCell else {
        return CGSize.zero
      }
      cell.configureCell(name: collectionViewData[indexPath.row][0], detail: collectionViewData[indexPath.row][1])
      cell.setNeedsLayout()
      cell.layoutIfNeeded()
      let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
      
      cgSizeToReturn = CGSize(width: size.width, height: 30)
      //return CGSize(width: size.width, height: 30)
      
    } else if (collectionView == self.imageCollectionView) {
      guard let cell: ImagesCollectionViewCell = Bundle.main.loadNibNamed(ImagesCollectionViewCell.nibName, owner: self, options: nil)?.first as? ImagesCollectionViewCell else {
        print("size failed")
        return CGSize.zero
      }
      
      cell.configureCell(image: UIImage(data: imageCollectionViewData[indexPath.row])!)
      cell.setNeedsLayout()
      cell.layoutIfNeeded()
      let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
      collectionView.autoresizingMask = .flexibleHeight
      cgSizeToReturn = CGSize(width: size.width, height: size.height)
    }
    return cgSizeToReturn
  }
}
