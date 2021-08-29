//
//  AppDetailsVC.swift
//  iTunesSearchApplication
//
//  Created by Nicholas Repaci on 8/28/21.
//

import UIKit

class AppDetailsVC: UIViewController {
  
  @IBOutlet weak var appNameLabel: UILabel!
  @IBOutlet weak var appIcon: UIImageView!
  @IBOutlet weak var hStack: UIStackView!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  var url = URL(string: "")
  var appImage: UIImage?
  var appName: String?
  var imageURL: String?
  var appDescription: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    appNameLabel.text = appName
    url = URL(string: imageURL ?? "")
    loadImage()
    appIcon.layer.cornerRadius = 25
    descriptionLabel.text = appDescription
    self.navigationController?.isNavigationBarHidden = false
  }
  // MARK: - Navigation
  
  func loadImage() {
    DispatchQueue.global().async {
      let data = try? Data(contentsOf: self.url!)
      DispatchQueue.main.async {
        self.appIcon.image = UIImage(data: data!)
      }
    }
  }
}

