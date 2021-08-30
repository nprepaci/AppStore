//
//  File.swift
//  iTunesSearchApplication
//
//  Created by Nicholas Repaci on 8/30/21.
//

import Foundation
import UIKit

//Performs animation on filter screen (line grows from 0 to 1)
class Animations {
  func animateLines(view1: UIView) {
    UIView.animate(withDuration: 0.0, animations: {
                    view1.transform = CGAffineTransform(scaleX: 0.0, y: 1.0)},
                   completion: { _ in
                    UIView.animate(withDuration: 0.75) {
                      view1.transform = CGAffineTransform.identity
                    }
    })
  }
}
