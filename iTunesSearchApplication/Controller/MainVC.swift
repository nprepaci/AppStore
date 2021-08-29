//
//  ViewController.swift
//  iTunesSearchApplication
//
//  Created by Nicholas Repaci on 8/28/21.
//

import UIKit
import Foundation

//protocol PassDataToFilterScreenDelegate {
//  func passDataToFilterScreen(category: String, didFilterData: Bool, rowPreviouslySelected: Int)
//}

class ViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchButton: UIBarButtonItem!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var filterButton: UIBarButtonItem!
  //var passDataToFilterScreenDelegate: PassDataToFilterScreenDelegate?
  var api = API()
  var localApiData: [Response] = []
  var indexOfCurrentRow = 0
  var imageDataArray = [Data]()
  let searchController = UISearchController(searchResultsController: nil)
  var filteredResults: [Result] = []
  var filteredIndex: Int = 0
  var selectedCategory: String = ""
  var didFilterResults: Bool = false
  var selectedRowForFilterPopup: Int = 0
  var returnCount: Int = Int()
  var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print(selectedRowForFilterPopup)
    activityIndicator.hidesWhenStopped = true
    //Prevents search bar from displaying as the incorrect color
    self.extendedLayoutIncludesOpaqueBars = true
    //self.navigationController?.isNavigationBarHidden = true
    self.navigationController?.isNavigationBarHidden = false
    tableView.dataSource = self
    tableView.delegate = self
    DataManager.shared.viewController = self
    api.loadData(search: "") { Results in
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
  
  override func viewDidAppear(_ animated: Bool) {
    print(selectedRowForFilterPopup, "selectedfilterrow")
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let appDetailsVC = segue.destination as! DetailsVC
    //Determines whether user added a filter to the search results and passes the data from the appropriate array
    if didFilterResults == false {
      appDetailsVC.detailLabel = api.storedData.results[indexOfCurrentRow].description
      appDetailsVC.appIcon = UIImage(data: try! Data(contentsOf: URL(string: api.storedData.results[indexOfCurrentRow].artworkUrl512) ?? URL.init(fileURLWithPath: "")))
      //appDetailsVC.appIcon = UIImage(data: api.imageArrayOfData[indexOfCurrentRow])
      appDetailsVC.appName = api.storedData.results[indexOfCurrentRow].trackName
    } else {
      appDetailsVC.detailLabel = filteredResults[indexOfCurrentRow].description
      appDetailsVC.appIcon = UIImage(data: try! Data(contentsOf: URL(string: filteredResults[indexOfCurrentRow].artworkUrl512) ?? URL.init(fileURLWithPath: "")))
      //appDetailsVC.appIcon = UIImage(data: api.imageArrayOfData[indexOfCurrentRow])
      appDetailsVC.appName = filteredResults[indexOfCurrentRow].trackName
    }
    
  }
  
  @IBAction func searchButtonClicked(_ sender: Any) {
    self.searchController.isActive = true
  }
  
  @IBAction func filterButtonClicked(_ sender: Any) {
    let filteredDataVC = storyboard?.instantiateViewController(identifier: "FilterData") as! FilterPopupVC
    filteredDataVC.passDataToMainViewDelegate = self
    filteredDataVC.selectedRow = selectedRowForFilterPopup
    //passDataToFilterScreenDelegate?.passDataToFilterScreen(category: selectedCategory, didFilterData: didFilterResults, rowPreviouslySelected: selectedRowForFilterPopup)
    //DataManager.shared.filterViewController.genreTableView.reloadData()
    present(filteredDataVC, animated: true, completion: nil)
    //navigationController?.pushViewController(filteredDataVC, animated: true)
  }
  
  func performFilterOfResults(searchCriteria: String) {
    filteredResults = api.storedData.results.filter { $0.primaryGenreName.contains(searchCriteria) }
  }
}

extension ViewController: PassDataToMainViewDelegate {
  func passDataToMainView(category: String, filterDataYN: Bool, selectedRow: Int) {
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
      returnCount = api.storedData.resultCount
      //returnCount = api.imageArrayOfData.count
    } else {
      returnCount = filteredResults.count
    }
    return returnCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableCell
    cell.cellImage.layer.cornerRadius = 25
    
    if didFilterResults == false {
      //cell.cellImage.image = UIImage(data: api.imageArrayOfData[indexPath.row])
      cell.cellImage.image = UIImage(data: try! Data(contentsOf: URL(string: api.storedData.results[indexPath.row].artworkUrl512) ?? URL.init(fileURLWithPath: "")))
      cell.label.text = api.storedData.results[indexPath.row].trackName
    } else {
      cell.cellImage.image = UIImage(data: try! Data(contentsOf: URL(string: filteredResults[indexPath.row].artworkUrl512) ?? URL.init(fileURLWithPath: "")))
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
    //self.api.imageArrayOfData.removeAll()
    //change filter to false to no longer use filtered results when performing a new search
    didFilterResults = false
    //resets filter choice to 0 -- this changes the checked item on the filter popup to "All"
    selectedRowForFilterPopup = 0
    
    self.api.loadData(search: searchBar.text!) { Response in
      //dismisses search bar after search is clicked
      
      self.tableView.reloadData()
      self.searchController.isActive = false
      // self.activityIndicator.stopAnimating()
    }
  }
}

