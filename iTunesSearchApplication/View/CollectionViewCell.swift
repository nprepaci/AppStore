//
//  CollectionViewCell.swift
//  iTunesSearchApplication
//
//  Created by Nicholas Repaci on 8/29/21.
//

import UIKit



class CollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var detailLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  class var reuseIdentifier: String {
    return "CollectionViewCellReuseIdentifier"
  }
  
  class var nibName: String {
    return "CollectionViewCell"
  }
  
  func configureCell(name: String, detail: String) {
    self.detailLabel.text = name
    self.descriptionLabel.text = detail
  }
}
