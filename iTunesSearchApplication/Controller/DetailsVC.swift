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
  @IBOutlet weak var generalDetailsHStack: UIStackView!
  let customCell = CustomTableCell()
  
  
  var detailLabel: String?
  var appIcon: UIImage?
  var appName: String?
  
  override func viewDidLoad() {
        super.viewDidLoad()
    appImage.layer.cornerRadius = 25
    appDetailLabel.text = detailLabel
    appImage.image = appIcon
    appNameLabel.text = appName
    }
  
//  override func viewDidAppear(_ animated: Bool) {
//         super.viewDidAppear(animated)
//         for _ in 0...10 {
//          customCell.label.text = "yo"
//          generalDetailsHStack.addArrangedSubview(customCell)
//         }
//  }
  
  
  // MARK: - Navigation

}
