//
//  ViewController.swift
//  iTunesSearchApplication
//
//  Created by Nicholas Repaci on 8/28/21.
//

import UIKit
import Foundation

class ViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchButton: UIBarButtonItem!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var filterButton: UIBarButtonItem!
  var api = API()
  var localApiData: [Response] = []
  var indexOfCurrentRow = 0
  var imageDataArray = [Data]()
  let searchController = UISearchController(searchResultsController: nil)
  var filteredResults: [Result] = []
  var filteredIndex: Int = 0
  var selectedCategory: String = ""
  var didFilterResults: Bool = false
  var selectedRowForFilterPopup: Int = Int()
  var returnCount: Int = Int()
  var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    activityIndicator.hidesWhenStopped = true
    //Prevents search bar from displaying as the incorrect color
    self.extendedLayoutIncludesOpaqueBars = true
    //self.navigationController?.isNavigationBarHidden = true
    self.navigationController?.isNavigationBarHidden = false
    tableView.dataSource = self
    tableView.delegate = self
    DataManager.shared.viewController = self
    api.loadData(search: "", genre: "") { Results in
      self.tableView.reloadData()
    }
    self.title = "Apps"
    searchController.searchBar.delegate = self
    //dims background when search icon is tapped
    searchController.obscuresBackgroundDuringPresentation = true
    //adds placeholder to search field
    searchController.searchBar.placeholder = "Search Apps"
    //adds search bar to UI
    navigationItem.searchController = searchController
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let appDetailsVC = segue.destination as! DetailsVC
//    appDetailsVC.appName = api.storedData.results[indexOfCurrentRow].trackName
//    appDetailsVC.imageURL = api.storedData.results[indexOfCurrentRow].artworkUrl512
    appDetailsVC.detailLabel = api.storedData.results[indexOfCurrentRow].description
    appDetailsVC.appIcon = UIImage(data: api.imageArrayOfData[indexOfCurrentRow])
    appDetailsVC.appName = api.storedData.results[indexOfCurrentRow].trackName
  }
  
  @IBAction func searchButtonClicked(_ sender: Any) {
    self.searchController.isActive = true
  }
  
  @IBAction func filterButtonClicked(_ sender: Any) {
    let filteredDataVC = self.storyboard?.instantiateViewController(identifier: "FilterData") as! FilterPopupVC
    filteredDataVC.delegate = self
    self.present(filteredDataVC, animated: true, completion: nil)
  }
  
  func performFilterOfResults(searchCriteria: String) {
    filteredResults = api.storedData.results.filter { $0.primaryGenreName.contains(searchCriteria) }
    //no longer need this as this is being set by the delegate
    //didFilterResults = true
   // print(filteredResults)
  }
}

extension ViewController: PassDataDelegate {
  func passData(category: String, filterDataYN: Bool, selectedRow: Int) {
    selectedCategory = category
    didFilterResults = filterDataYN
    selectedRowForFilterPopup = selectedRow
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    indexOfCurrentRow = indexPath.row
    performSegue(withIdentifier: "ShowAppDetails", sender: self)
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //var count: Int = Int()
    //return api.storedData.resultCount
    if didFilterResults == false {
      returnCount = api.imageArrayOfData.count
    } else {
      returnCount = filteredResults.count
    }
    return returnCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableCell
    cell.cellImage.layer.cornerRadius = 25
    
    if didFilterResults == false {
      cell.cellImage.image = UIImage(data: api.imageArrayOfData[indexPath.row])
      cell.label.text = api.storedData.results[indexPath.row].trackName
    } else {
      cell.label.text = filteredResults[indexPath.row].trackName
    }
    return cell
  }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      let searchBar = searchController.searchBar
      activityIndicator.startAnimating()
      //Clearing array before api call to prevent index out of range
      self.api.imageArrayOfData.removeAll()
      didFilterResults = false
      self.api.loadData(search: searchBar.text!, genre: "") { Response in
            //dismisses search bar after search is clicked
            self.searchController.isActive = false
           // self.activityIndicator.stopAnimating()
          }
    }
}

