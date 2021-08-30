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
  var primaryGenreName, artistName, trackContentRating, trackName, releaseDate, sellerName, currentVersionReleaseDate, releaseNotes, version: String
  var primaryGenreId: Int
  var currency, description: String
  var price: Double
  var averageUserRating: Double
}

class API {
  var storedData = Response(resultCount: Int.init(), results: [])
  func loadData(search: String, completionHandler: @escaping (Response) -> Void) {
    guard let url = URL(string:"https://itunes.apple.com/search?term=\(search)&entity=software&limit=14") else {
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
            completionHandler(self.storedData)
          }
          return
        }
      }
      print("failed \(error?.localizedDescription ?? "unknown error")")
    }
    .resume()
  }
  func reloadTableData() {
    DataManager.shared.viewController.tableView.reloadData()
  }
}
