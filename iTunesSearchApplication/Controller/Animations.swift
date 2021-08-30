//
//  File.swift
//  iTunesSearchApplication
//
//  Created by Nicholas Repaci on 8/30/21.
//

import Foundation
import UIKit

class Animations {
  func animateLines(view1: UIView) {
    UIView.animate(withDuration: 0.0,
                   animations: {
                    view1.transform = CGAffineTransform(scaleX: 0.0, y: 1.0)
                   // view2.transform = CGAffineTransform(scaleX: 0.0, y: 1.0)
                   },
                   completion: { _ in
                    UIView.animate(withDuration: 0.75) {
                      view1.transform = CGAffineTransform.identity
                      //view2.transform = CGAffineTransform.identity
                    }
                   })
  }
}
