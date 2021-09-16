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
  var currentAppliedPriceFilter: String = "All"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Sets up activity indicator to hide when .stop is called
    activityIndicator.hidesWhenStopped = true
    
    //Ensures navigation bar is not hidden
    self.navigationController?.isNavigationBarHidden = false
    
    //Sets tableview delegates to self
    tableView.dataSource = self
    tableView.delegate = self
    
    //Allows for refreshing of table view from another VC. Setting to self.
    DataManager.shared.viewController = self
    
    //GET request from API. Once completed, completion handler executes
    //Currently defaults to IBM on app launch
    api.loadData(search: "ibm", activityIndicator: activityIndicator) { Results in
      
      //Appends results to local array
      self.filteredResults = self.api.storedData.results
      
      //Reloads table to present data
      self.tableView.reloadData()
    }
    //Sets searchbar delegate to current VC
    searchController.searchBar.delegate = self
    
    //Prevents search bar from displaying as the incorrect color
    self.extendedLayoutIncludesOpaqueBars = true
    
    //dims background when search icon is tapped
    searchController.obscuresBackgroundDuringPresentation = true
    
    //adds placeholder to search field
    searchController.searchBar.placeholder = "Search Apps"
    
    //adds search bar to UI
    navigationItem.searchController = searchController
    
    //Adds navigation controller title
    self.title = "Apps"
  }
  
  // MARK: - PREPARE FOR SEGUE
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let detailsVC = segue.destination as! DetailsVC
    
    //Checks price in api results and passes appropriate value to app detail view
    if (filteredResults[indexOfCurrentRow].price == 0.00) {
      detailsVC.appPrice = "Free"
      
      //if not free, returns the price
    } else {
      detailsVC.appPrice = "$ \(String(filteredResults[indexOfCurrentRow].price ?? 0.00))"
    }
    
    //Passes filtered result data to details VC
    detailsVC.detailLabel = filteredResults[indexOfCurrentRow].description
    detailsVC.appIcon = UIImage(data: try! Data(contentsOf: URL(string: filteredResults[indexOfCurrentRow].artworkUrl512) ?? URL.init(fileURLWithPath: "")))
    detailsVC.appName = filteredResults[indexOfCurrentRow].trackName
    
    //Data for horizontal scrolling collection view of app details
    // This is a 2D array so we can access both a label (e.g. rating) and the actual data tied to it
    detailsVC.collectionViewData.append(["Rating", "\(Double(round(filteredResults[indexOfCurrentRow].averageUserRating)))"])
    detailsVC.collectionViewData.append(["Age", filteredResults[indexOfCurrentRow].trackContentRating])
    detailsVC.collectionViewData.append(["Developer", filteredResults[indexOfCurrentRow].artistName])
    detailsVC.collectionViewData.append(["Category", filteredResults[indexOfCurrentRow].primaryGenreName])
    detailsVC.collectionViewData.append(["Version", filteredResults[indexOfCurrentRow].version])
    detailsVC.collectionViewData.append(["Size", "\(String(round((Double(filteredResults[indexOfCurrentRow].fileSizeBytes ?? "") ?? 0.00) / Double(1000000.0)))) MB"])
    
    //Adds each iphone screenshot to array on app detail view
    for i in 0..<filteredResults[indexOfCurrentRow].screenshotUrls.count {
      detailsVC.imageCollectionViewData.append(try! Data(contentsOf: URL(string: filteredResults[indexOfCurrentRow].screenshotUrls[i])!))
    }
  }
  
  // MARK: - IBFUNCTIONS
  
  //What occurs when search icon (magnifying glass) is clicked
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
  }
  
  //Actions performed when the segmented control is changed
  //Segmented control contains "All", "Free", and "Paid" options
  @IBAction func segmentedControlChanged(_ sender: Any) {
    switch segmentedControl.selectedSegmentIndex
    {
    case 0: //Filtered by ALL
      
      //If user filtered search results
      if (didFilterResults == true) {
        
        //Resets filtered array to filter by category
        filteredResults = api.storedData.results.filter { $0.primaryGenreName.contains(selectedCategory) }
        
        //Reloads tableview
        tableView.reloadData()
        
        //If user did not filter search results
      } else if (didFilterResults == false) {
        
        //Adds all api results back to the array, removing any filters
        filteredResults = api.storedData.results
        
        //reloads table view
        tableView.reloadData()
      }
      currentAppliedPriceFilter = "All"
      
    case 1: //Free
      //If user filtered search results
      if (didFilterResults == true) {
        
        //Filters array by selected category
        filteredResults = api.storedData.results.filter { $0.primaryGenreName.contains(selectedCategory) }
        
        //Applies additional price based filter
        filteredResults = filteredResults.filter { $0.price == 0 }
        
        //Reloads tableview
        tableView.reloadData()
        
        //If user did not filter search results
      } else if (didFilterResults == false) {
        
        //applies price based filter
        filteredResults = api.storedData.results.filter { $0.price == 0 }
        
        //reloads tableview
        tableView.reloadData()
      }
      currentAppliedPriceFilter = "Free"
      
    case 2: //Paid
      
      //If user filtered search results
      if (didFilterResults == true) {
        
        //Filters array by selected category
        filteredResults = api.storedData.results.filter { $0.primaryGenreName.contains(selectedCategory) }
        
        //Applies additional price based filter
        filteredResults = filteredResults.filter { $0.price ?? 0.00 > 0 }
        
        //reloads table view
        tableView.reloadData()
        
        //If user did not filter search results
      } else if (didFilterResults == false) {
        
        //applies price based filter
        filteredResults = api.storedData.results.filter { $0.price ?? 0.00 > 0 }
        
        //Reloads tableview
        self.tableView.reloadData()
      }
      currentAppliedPriceFilter = "Paid"
      
    default:
      break
    }
  }
  
  // MARK: - FUNCTIONS
  
  //Filters resultes based on searchCriteria parameter. Called via the filterpopupVC
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

// MARK: - TABLE VIEW CODE
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
      cell.priceLabel.text = "$ \(String(filteredResults[indexPath.row].price ?? 0.00))"
    }
    return cell
  }
}

// MARK: - SEARCH BAR CODE
extension ViewController: UISearchBarDelegate {
  
  //Function that controls actions that occur once the "Search" button is clicked
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    let searchBar = searchController.searchBar
    
    //Removes spaces from search, as searching does not appear to work with spaces
    let removedSpaces = searchBar.text!.filter {!$0.isWhitespace}
    
    //Switches segmented control back to ALL apps
    segmentedControl.selectedSegmentIndex = 0
    segmentedControl.sendActions(for: UIControl.Event.valueChanged)
    
    //Clears array and reloads data. This allows for user awareness that a search is happening
    filteredResults.removeAll()
    self.tableView.reloadData()
    
    //sets did filter results to false, as searching clears the filter
    didFilterResults = false
    
    //resets filter choice to 0 -- this changes the checked item on the filter popup to "All"
    selectedRowForFilterPopup = 0
    
    //search parameter is converted to string, allowing numbers to be entered in search criteria
    self.api.loadData(search: String(removedSpaces), activityIndicator: activityIndicator) { Response in
      
      //adds new search data from API to local array
      self.filteredResults = self.api.storedData.results
      self.tableView.reloadData()
      
      //dismisses search bar after search is clicked
      self.searchController.isActive = false
    }
  }
}
