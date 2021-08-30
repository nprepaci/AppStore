//
//  ImagesCollectionViewCell.swift
//  iTunesSearchApplication
//
//  Created by Nicholas Repaci on 8/29/21.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var appImage: UIImageView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  class var reuseIdentifier: String {
      return "ImagesCollectionCellReuse"
  }
  
  class var nibName: String {
      return "ImagesCollectionViewCell"
  }
  
  func configureCell(image: UIImage) {
    self.appImage.image = image
    self.appImage.layer.cornerRadius = 15
  }
}

