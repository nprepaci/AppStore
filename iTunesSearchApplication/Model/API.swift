//
//  API.swift
//  iTunesSearchApplication
//
//  Created by Nicholas Repaci on 8/28/21.
//

import Foundation
import UIKit

struct Response: Codable {
  var resultCount: Int
  var results: [Result]
}

struct Result: Codable {
  var screenshotUrls, ipadScreenshotUrls, appletvScreenshotUrls: [String]
  var artworkUrl60, artworkUrl512, artworkUrl100, artistViewUrl: String
  var supportedDevices, advisories: [String]
  var isGameCenterEnabled: Bool
  var features: [String]
  var kind, minimumOsVersion, trackCensoredName, fileSizeBytes: String
  var contentAdvisoryRating: String
  var genreIds: [String]
  var primaryGenreName, trackName, releaseDate, sellerName, currentVersionReleaseDate, releaseNotes: String
  var primaryGenreId: Int
  var currency, description: String
}

class API {

  var storedData = Response(resultCount: Int.init(), results: [])
  //var imageArrayOfData = [Data]()
  func loadData(search: String, completionHandler: @escaping (Response) -> Void) {
    guard let url = URL(string: "https://itunes.apple.com/search?term=\(search)&entity=software&limit=10&primaryGenreName=medical") else {
      print("failed to fetch data")
      return
    }
    let request = URLRequest(url: url)
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let data = data {
        if let response = try? JSONDecoder().decode(Response.self, from: data) {
          DispatchQueue.main.async {
            self.storedData.resultCount = response.resultCount
            self.storedData.results = response.results
//            for i in 0..<self.storedData.resultCount {
//              self.loadImage(url: self.storedData.results[i].artworkUrl512)
//            }
            completionHandler(self.storedData)
            //print(self.imageArrayOfData)
          }
          return
        }
      }
      print("failed \(error?.localizedDescription ?? "unknown error")")
    }
    .resume()
  }
  
//  func loadImage(url: String) {
//    DispatchQueue.global().async {
//      let data = try? Data(contentsOf: URL(string: url)!)
//      DispatchQueue.main.async {
//        self.imageArrayOfData.append(data ?? Data.init())
//        self.reloadTableData()
//      }
//    }
//  }
  
  func reloadTableData() {
    DataManager.shared.viewController.tableView.reloadData()
  }
}


//
//  API.swift
//  iTunesSearchApplication
//
//  Created by Nicholas Repaci on 8/26/21.
//

//import Foundation
//import UIKit
//
//struct Response: Codable {
//  var resultCount: Int
//  var results: [Result]
//}
//
//struct Result: Codable {
//  var screenshotUrls, ipadScreenshotUrls, appletvScreenshotUrls: [String]
//  var artworkUrl60, artworkUrl512, artworkUrl100, artistViewUrl: String
//  var supportedDevices, advisories: [String]
//  var isGameCenterEnabled: Bool
//  var features: [String]
//  var kind, minimumOsVersion, trackCensoredName, fileSizeBytes: String
//  var contentAdvisoryRating: String
//  var genreIds: [String]
//  var primaryGenreName, trackName, releaseDate, sellerName, currentVersionReleaseDate, releaseNotes: String
//  var primaryGenreId: Int
//  var currency, description: String
//}
//
//class API {
//
//  var storedData = Response(resultCount: Int.init(), results: [])
//  var imageArrayOfData = [Data]()
//  func loadData(completionHandler: @escaping (Response) -> Void) {
//    guard let url = URL(string: "https://itunes.apple.com/search?term=ibm&entity=software&limit=10") else {
//      print("failed to fetch data")
//      return
//    }
//    let request = URLRequest(url: url)
//    URLSession.shared.dataTask(with: request) { data, response, error in
//      if let data = data {
//        if let response = try? JSONDecoder().decode(Response.self, from: data) {
//          DispatchQueue.main.async {
//            self.storedData.resultCount = response.resultCount
//            self.storedData.results = response.results
//            for i in 0..<self.storedData.resultCount {
//              self.loadImage(url: self.storedData.results[i].artworkUrl512)
//            }
//            completionHandler(self.storedData)
//            print(self.imageArrayOfData)
//          }
//          return
//        }
//      }
//      print("failed \(error?.localizedDescription ?? "unknown error")")
//    }
//    .resume()
//  }
//
//  func loadImage(url: String) {
//    DispatchQueue.global().async {
//      let data = try? Data(contentsOf: URL(string: url)!)
//      DispatchQueue.main.async {
//        self.imageArrayOfData.append(data ?? Data.init())
//        //print(self.imageArrayOfData)
//        //return UIImage(data: data!)
//        //DataManager.shared.viewController.tableView.reloadData()
//        self.reloadTableData()
//      }
//      //self.reloadTableData()
//    }
//    //reloadTableData()
//  }
//
//  func reloadTableData() {
//    DataManager.shared.viewController.tableView.reloadData()
//  }
//}
