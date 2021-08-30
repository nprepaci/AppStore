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
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  
  var api = API()
  var localApiData: [Response] = []
  var indexOfCurrentRow = 0
  let searchController = UISearchController(searchResultsController: nil)
  var filteredResults: [Result] = []
  var filteredByPriceResults: [Result] = []
  var filteredIndex: Int = 0
  var selectedCategory: String = ""
  var didFilterResults: Bool = false
  var selectedRowForFilterPopup: Int = 0
  var returnCount: Int = Int()
  var fileSizeMBorGB: Double = Double()
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
    //be sure to make struing of IBM blank before publishing
    api.loadData(search: "ibm") { Results in
      self.filteredResults = self.api.storedData.results
      
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
  
  // MARK: - VIEWDIDLOAD
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let detailsVC = segue.destination as! DetailsVC
    
    //Checks price in api results and passes appropriate value to app detail view
    if (filteredResults[indexOfCurrentRow].price == 0.00) {
      detailsVC.appPrice = "Free"
    } else {
      detailsVC.appPrice = "$ \(String(filteredResults[indexOfCurrentRow].price))"
    }
    
    detailsVC.detailLabel = filteredResults[indexOfCurrentRow].description
    detailsVC.appIcon = UIImage(data: try! Data(contentsOf: URL(string: filteredResults[indexOfCurrentRow].artworkUrl512) ?? URL.init(fileURLWithPath: "")))
    detailsVC.appName = filteredResults[indexOfCurrentRow].trackName
    
    //Rounds review to number user can understand
    detailsVC.collectionViewData.append(["Rating", "\(Double(round(filteredResults[indexOfCurrentRow].averageUserRating)))"])
    detailsVC.collectionViewData.append(["Age", filteredResults[indexOfCurrentRow].trackContentRating])
    detailsVC.collectionViewData.append(["Developer", filteredResults[indexOfCurrentRow].artistName])
    detailsVC.collectionViewData.append(["Category", filteredResults[indexOfCurrentRow].primaryGenreName])
    detailsVC.collectionViewData.append(["Version", filteredResults[indexOfCurrentRow].version])
    
    //rounds bits to MB
    detailsVC.collectionViewData.append(["Size", "\(String(round(Double(filteredResults[indexOfCurrentRow].fileSizeBytes)! / Double(1000000.0)))) MB"])
    //adds each iphone screenshot to array on app detail view
    for i in 0..<filteredResults[indexOfCurrentRow].screenshotUrls.count {
      detailsVC.imageCollectionViewData.append([try! Data(contentsOf: URL(string: filteredResults[indexOfCurrentRow].screenshotUrls[i])!)])
    }
  }
  
  // MARK: - IBFUNCTIONS
  
  //what occurs when filter button is clicked
  @IBAction func searchButtonClicked(_ sender: Any) {
    self.searchController.isActive = true
  }
  
  //What occurs when filter button is clicked
  @IBAction func filterButtonClicked(_ sender: Any) {
    let filteredDataVC = storyboard?.instantiateViewController(identifier: "FilterData") as! FilterPopupVC
    filteredDataVC.passDataToMainViewDelegate = self
    filteredDataVC.selectedRow = selectedRowForFilterPopup
    filteredDataVC.filterDataYN = didFilterResults
    filteredDataVC.selectedCategory = selectedCategory
    present(filteredDataVC, animated: true, completion: nil)
    //navigationController?.pushViewController(filteredDataVC, animated: true)
  }
  
  //Actions performed when the segmented control is changed
  //Segmented control contains "All", "Free", and "Paid" options
  @IBAction func segmentedControlChanged(_ sender: Any) {
    switch segmentedControl.selectedSegmentIndex
    {
    case 0: //All
      if (didFilterResults == true) {
        //resets filtered array to filter by category
        filteredResults = api.storedData.results.filter { $0.primaryGenreName.contains(selectedCategory) }
        tableView.reloadData()
      } else if (didFilterResults == false) {
        //adds all api results back to the array, removing any filters
        filteredResults = api.storedData.results
        //filteredByPriceResults = []
        tableView.reloadData()
      }
      
    case 1: //Free
      if (didFilterResults == true) {
        //Filters array by selected category
        filteredResults = api.storedData.results.filter { $0.primaryGenreName.contains(selectedCategory) }
        //applies additional price based filter
        filteredResults = filteredResults.filter { $0.price == 0 }
        tableView.reloadData()
      } else if (didFilterResults == false) {
        //adds all api results back to the array, removing any filters
        //filteredResults = api.storedData.results
        //applies price based filter
        filteredResults = api.storedData.results.filter { $0.price == 0 }
        tableView.reloadData()
      }
      
    case 2: //Paid
      if (didFilterResults == true) {
        //Filters array by selected category
        filteredResults = api.storedData.results.filter { $0.primaryGenreName.contains(selectedCategory) }
        //Applies additional price based filter
        filteredResults = filteredResults.filter { $0.price > 0 }
        tableView.reloadData()
      } else if (didFilterResults == false) {
        filteredResults = api.storedData.results.filter { $0.price > 0 }
        self.tableView.reloadData()
      }
    default:
      break
    }
  }
  
  // MARK: - FUNCTIONS
  
  func performFilterOfResults(searchCriteria: String) {
    filteredResults = api.storedData.results.filter { $0.primaryGenreName.contains(searchCriteria) }
  }
}


// MARK: - EXTENSIONS

//delegate method for passing data to filter screen
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
    //Prevents selected row from remaining highlighted
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredResults.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableCell
    cell.cellImage.layer.cornerRadius = 25
    //clips to bounds needed in order to apply cornerRadius to price label
    cell.priceLabel.clipsToBounds = true
    cell.priceLabel.backgroundColor = UIColor.init(red: 175/255, green: 185/255, blue: 186/255, alpha: 1)
    cell.priceLabel.layer.cornerRadius = 15
    cell.cellImage.image = UIImage(data: try! Data(contentsOf: URL(string: filteredResults[indexPath.row].artworkUrl512) ?? URL.init(fileURLWithPath: "")))
    cell.label.text = filteredResults[indexPath.row].trackName
    
    //checks if app is free or not and displays the appropriate label
    if (filteredResults[indexPath.row].price == 0.00) {
      cell.priceLabel.text = "View"
    } else {
      cell.priceLabel.text = "$ \(String(filteredResults[indexPath.row].price))"
    }
    return cell
  }
}

extension ViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    let searchBar = searchController.searchBar
    activityIndicator.startAnimating()
    didFilterResults = false
    //resets filter choice to 0 -- this changes the checked item on the filter popup to "All"
    selectedRowForFilterPopup = 0
    
    self.api.loadData(search: searchBar.text!) { Response in
      //adds new search data from API to local array
      self.filteredResults = self.api.storedData.results
      self.tableView.reloadData()
      //dismisses search bar after search is clicked
      self.searchController.isActive = false
      // self.activityIndicator.stopAnimating()
    }
  }
}
