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
  @IBOutlet weak var imageCollectionView: UICollectionView!
  let customCell = CustomTableCell()
  var cgSizeToReturn = CGSize.init()
  
  
  var collectionViewData: [[String]] = [[String]].init()
//  var imageCollectionViewData: [[Data]] = [[try! Data(contentsOf: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Purple113/v4/a8/a4/ba/a8a4baa0-9dd5-7fd6-1f77-5601340873f9/source/512x512bb.jpg") ?? URL.init(fileURLWithPath: "https://images.unsplash.com/photo-1617854818583-09e7f077a156?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80"))]]//[Data].init()
  var imageCollectionViewData: [[Data]] = [[Data]]()
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
    imageCollectionView.delegate = self
    imageCollectionView.dataSource = self
    
    registerNib()
    registerImageNib()
    
    collectionView.layer.borderWidth = 0.5
    collectionView.layer.borderColor = UIColor.gray.cgColor
  }
  // MARK: - Navigation
  
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

extension DetailsVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    var valueToReturn = 0
    
    if (collectionView == self.collectionView) {
      valueToReturn = collectionViewData.count
    } else if (collectionView == self.imageCollectionView) {
      valueToReturn = imageCollectionViewData.count
    }
    return valueToReturn
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
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
        //gets data from index 0 & 1 for each indexpath.row
        //0 is manually entered field name, 1 is data from api
        let image = imageCollectionViewData[indexPath.row][0]
        cell.configureCell(image: (UIImage(data: image)!))
        return cell
      }
    }
    return UICollectionViewCell()
  }
}

extension DetailsVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
      cell.configureCell(image: UIImage(data: imageCollectionViewData[indexPath.row][0])!)
      cell.setNeedsLayout()
      cell.layoutIfNeeded()
      let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
      
      cgSizeToReturn = CGSize(width: 100, height: 150)
      print("PUT THOE LOTIOTION IIN THE BASKET************************************************************************************")
      print(imageCollectionViewData[0])
      //return CGSize(width: size.width, height: 30)
    }
    return cgSizeToReturn
  }
}








///COLLECTION TEST WITH SINGLE IMAGE WORKING VERSION

//import UIKit
//
//class DetailsVC: UIViewController {
//
//  @IBOutlet weak var appDetailLabel: UILabel!
//  @IBOutlet weak var appImage: UIImageView!
//  @IBOutlet weak var appNameLabel: UILabel!
//  @IBOutlet weak var collectionView: UICollectionView!
//  @IBOutlet weak var imageCollectionView: UICollectionView!
//  let customCell = CustomTableCell()
//  var cgSizeToReturn = CGSize.init()
//
//
//  var collectionViewData: [[String]] = [[String]].init()
//  var imageCollectionViewData: [String] = ["114"]
//
//  var detailLabel: String?
//  var appIcon: UIImage?
//  var appName: String?
//  var averageRating: Double?
//  var testString: String?
//  var fileSize: String?
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    appImage.layer.cornerRadius = 25
//    appDetailLabel.text = detailLabel
//    appImage.image = appIcon
//    appNameLabel.text = appName
//
//    collectionView.dataSource = self
//    collectionView.delegate = self
//    imageCollectionView.delegate = self
//    imageCollectionView.dataSource = self
//
//    registerNib()
//    registerImageNib()
//
//    collectionView.layer.borderWidth = 0.5
//    collectionView.layer.borderColor = UIColor.gray.cgColor
//  }
//  // MARK: - Navigation
//
//  func registerNib() {
//    let nib = UINib(nibName: CollectionViewCell.nibName, bundle: nil)
//    collectionView?.register(nib, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
//    if let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//      flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
//    }
//  }
//
//  func registerImageNib() {
//    let nib = UINib(nibName: ImagesCollectionViewCell.nibName, bundle: nil)
//    imageCollectionView?.register(nib, forCellWithReuseIdentifier: ImagesCollectionViewCell.reuseIdentifier)
//    if let flowLayout = self.imageCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//      flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
//    }
//  }
//}
//
//extension DetailsVC: UICollectionViewDataSource {
//  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//    var valueToReturn = 0
//
//    if (collectionView == self.collectionView) {
//      valueToReturn = collectionViewData.count
//    } else if (collectionView == self.imageCollectionView) {
//      valueToReturn = imageCollectionViewData.count
//    }
//    return valueToReturn
//  }
//
//  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//    if (collectionView == self.collectionView) {
//      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionViewCell {
//        //gets data from index 0 & 1 for each indexpath.row
//        //0 is manually entered field name, 1 is data from api
//        let name = collectionViewData[indexPath.row][0]
//        let detail = collectionViewData[indexPath.row][1]
//        cell.configureCell(name: name, detail: detail)
//        return cell
//      }
//    } else if (collectionView == self.imageCollectionView) {
//      if let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: ImagesCollectionViewCell.reuseIdentifier, for: indexPath) as? ImagesCollectionViewCell {
//        //gets data from index 0 & 1 for each indexpath.row
//        //0 is manually entered field name, 1 is data from api
//        let image = imageCollectionViewData[indexPath.row]
//        cell.configureCell(image: UIImage(named: image)!)
//        return cell
//      }
//    }
//    return UICollectionViewCell()
//  }
//}
//
//extension DetailsVC: UICollectionViewDelegateFlowLayout {
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    if (collectionView == self.collectionView) {
//      guard let cell: CollectionViewCell = Bundle.main.loadNibNamed(CollectionViewCell.nibName, owner: self, options: nil)?.first as? CollectionViewCell else {
//        return CGSize.zero
//      }
//      cell.configureCell(name: collectionViewData[indexPath.row][0], detail: collectionViewData[indexPath.row][1])
//      cell.setNeedsLayout()
//      cell.layoutIfNeeded()
//      let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//
//      cgSizeToReturn = CGSize(width: size.width, height: 30)
//      //return CGSize(width: size.width, height: 30)
//
//    } else if (collectionView == self.imageCollectionView) {
//      guard let cell: ImagesCollectionViewCell = Bundle.main.loadNibNamed(ImagesCollectionViewCell.nibName, owner: self, options: nil)?.first as? ImagesCollectionViewCell else {
//        print("size failed")
//        return CGSize.zero
//
//      }
//      cell.configureCell(image: UIImage(named: imageCollectionViewData[indexPath.row])!)
//      cell.setNeedsLayout()
//      cell.layoutIfNeeded()
//      let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//
//      cgSizeToReturn = CGSize(width: size.width, height: 128)
//      print("PUT THOE LOTIOTION IIN THE BASKET************************************************************************************")
//      //return CGSize(width: size.width, height: 30)
//    }
//    return cgSizeToReturn
//  }
//}
//




///PRE CHANGES TO ADD SECOND COLELCTION

//
//  DetailsVC.swift
//  iTunesSearchApplication
//
//  Created by Nicholas Repaci on 8/28/21.
//

//import UIKit
//
//class DetailsVC: UIViewController {
//
//  @IBOutlet weak var appDetailLabel: UILabel!
//  @IBOutlet weak var appImage: UIImageView!
//  @IBOutlet weak var appNameLabel: UILabel!
//  @IBOutlet weak var collectionView: UICollectionView!
//  @IBOutlet weak var imageCollectionView: UICollectionView!
//  let customCell = CustomTableCell()
//
//
//
//  var collectionViewData: [[String]] = [[String]].init()
//  var detailLabel: String?
//  var appIcon: UIImage?
//  var appName: String?
//  var averageRating: Double?
//  var testString: String?
//  var fileSize: String?
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    appImage.layer.cornerRadius = 25
//    appDetailLabel.text = detailLabel
//    appImage.image = appIcon
//    appNameLabel.text = appName
//
//    collectionView.dataSource = self
//    collectionView.delegate = self
//    imageCollectionView.delegate = self
//    imageCollectionView.dataSource = self
//
//    registerNib()
//
//    collectionView.layer.borderWidth = 0.5
//    collectionView.layer.borderColor = UIColor.gray.cgColor
//  }
//  // MARK: - Navigation
//
//  func registerNib() {
//    let nib = UINib(nibName: CollectionViewCell.nibName, bundle: nil)
//    collectionView?.register(nib, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
//    if let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//      flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
//    }
//  }
//}
//
//extension DetailsVC: UICollectionViewDataSource {
//  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//    var valueToReturn = 0
//
//    if (collectionView == self.collectionView) {
//      valueToReturn = collectionViewData.count
//    } else if (collectionView == self.imageCollectionView) {
//      valueToReturn = collectionViewData.count
//    }
//
//    return valueToReturn
//  }
//
//  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionViewCell {
//      //gets data from index 0 & 1 for each indexpath.row
//      //0 is manually entered field name, 1 is data from api
//      let name = collectionViewData[indexPath.row][0]
//      let detail = collectionViewData[indexPath.row][1]
//      cell.configureCell(name: name, detail: detail)
//      return cell
//    }
//    return UICollectionViewCell()
//  }
//}
//
//extension DetailsVC: UICollectionViewDelegateFlowLayout {
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    guard let cell: CollectionViewCell = Bundle.main.loadNibNamed(CollectionViewCell.nibName, owner: self, options: nil)?.first as? CollectionViewCell else {
//           return CGSize.zero
//    }
//    cell.configureCell(name: collectionViewData[indexPath.row][0], detail: collectionViewData[indexPath.row][1])
//    cell.setNeedsLayout()
//    cell.layoutIfNeeded()
//    let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//    return CGSize(width: size.width, height: 30)
//  }
//}
