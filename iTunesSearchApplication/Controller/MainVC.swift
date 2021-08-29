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
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  //var passDataToFilterScreenDelegate: PassDataToFilterScreenDelegate?
  var api = API()
  var localApiData: [Response] = []
  var indexOfCurrentRow = 0
 // var imageDataArray = [Data]()
  let searchController = UISearchController(searchResultsController: nil)
  var filteredResults: [Result] = []
  var filteredByPriceResults: [Result] = []
  var filteredIndex: Int = 0
  var selectedCategory: String = ""
  //var filterByFreePaidAll: String = "All"
  var didFilterResults: Bool = false
  var selectedRowForFilterPopup: Int = 0
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
  
  override func viewDidAppear(_ animated: Bool) {
    print(selectedRowForFilterPopup, "selectedfilterrow")
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let detailsVC = segue.destination as! DetailsVC
    //Determines whether user added a filter to the search results and passes the data from the appropriate array
    if didFilterResults == false {
      detailsVC.detailLabel = api.storedData.results[indexOfCurrentRow].description
      detailsVC.appIcon = UIImage(data: try! Data(contentsOf: URL(string: api.storedData.results[indexOfCurrentRow].artworkUrl512) ?? URL.init(fileURLWithPath: "")))
      //appDetailsVC.appIcon = UIImage(data: api.imageArrayOfData[indexOfCurrentRow])
      detailsVC.appName = api.storedData.results[indexOfCurrentRow].trackName
    } else {
      detailsVC.detailLabel = filteredResults[indexOfCurrentRow].description
      detailsVC.appIcon = UIImage(data: try! Data(contentsOf: URL(string: filteredResults[indexOfCurrentRow].artworkUrl512) ?? URL.init(fileURLWithPath: "")))
      //appDetailsVC.appIcon = UIImage(data: api.imageArrayOfData[indexOfCurrentRow])
      detailsVC.appName = filteredResults[indexOfCurrentRow].trackName
    }
    
  }
  
  @IBAction func searchButtonClicked(_ sender: Any) {
    self.searchController.isActive = true
  }
  
  @IBAction func filterButtonClicked(_ sender: Any) {
    let filteredDataVC = storyboard?.instantiateViewController(identifier: "FilterData") as! FilterPopupVC
    filteredDataVC.passDataToMainViewDelegate = self
    filteredDataVC.selectedRow = selectedRowForFilterPopup
    filteredDataVC.filterDataYN = didFilterResults
    filteredDataVC.selectedCategory = selectedCategory
    //passDataToFilterScreenDelegate?.passDataToFilterScreen(category: selectedCategory, didFilterData: didFilterResults, rowPreviouslySelected: selectedRowForFilterPopup)
    //DataManager.shared.filterViewController.genreTableView.reloadData()
    present(filteredDataVC, animated: true, completion: nil)
    //navigationController?.pushViewController(filteredDataVC, animated: true)
  }
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
      //filterByFreePaidAll = "All"
      print("All")
      
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
      //filterByFreePaidAll = "Free"
      print("free")
      
    case 2: //Paid
      if (didFilterResults == true) {
        //Filters array by selected category
        filteredResults = api.storedData.results.filter { $0.primaryGenreName.contains(selectedCategory) }
        //Applies additional price based filter
        filteredResults = filteredResults.filter { $0.price > 0 }
        tableView.reloadData()
      } else if (didFilterResults == false) {
       // filterByFreePaidAll = "Paid"
        //adds all api results back to the array, removing any filters
        //might be redundant since you are doing this in the completion handler function
        //filteredResults = api.storedData.results
       // print(filteredResults)
        filteredResults = api.storedData.results.filter { $0.price > 0 }
        self.tableView.reloadData()
        //Applies price based filter
//        testCompletion { Result in
//          DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.tableView.reloadData()
//          }
//          //self.tableView.reloadData()
//          //print(self.filteredResults)
//        }
        //filteredResults = api.storedData.results.filter { $0.price > 0 }
      // tableView.reloadData()
      }
     // filterByFreePaidAll = "Paid"
      print("paid")
    default:
      break
    }
  }
//  
//  func testCompletion(completionHandler: @escaping ([Result]) -> Void) {
//    if filterByFreePaidAll == "Paid" {
//      filteredResults = api.storedData.results.filter { $0.price > 0 }
//      completionHandler(self.filteredResults)
//    }
//  }
  
  func performFilterOfResults(searchCriteria: String) {
    filteredResults = api.storedData.results.filter { $0.primaryGenreName.contains(searchCriteria) }
//    if (filterByPaid == true) {
//      filteredResults = api.storedData.results.filter { $0.price > 0 }
//    }
  }
  
  func performFilterofAppPriceCategory() {
    
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
    //Prevents selected row from remaining highlighted
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    
    return filteredResults.count
    
    //var count: Int = Int()
    //return api.storedData.resultCount
   // if didFilterResults == false {
      //returnCount = api.storedData.resultCount
//      //returnCount = api.imageArrayOfData.count
//    } else {
//      returnCount = filteredResults.count
//    }
//    return returnCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableCell
    cell.cellImage.layer.cornerRadius = 25
    //clips to bounds needed in order to apply cornerRadius to price label
    cell.priceLabel.clipsToBounds = true
    cell.priceLabel.backgroundColor = UIColor.init(red: 175/255, green: 185/255, blue: 186/255, alpha: 1)
    cell.priceLabel.layer.cornerRadius = 15
    //checks if user applied filter to results. Pulls data from appropriate array if filtered vs. not filtered
    
    //new version, always referencing one single filtered array
    cell.cellImage.image = UIImage(data: try! Data(contentsOf: URL(string: filteredResults[indexPath.row].artworkUrl512) ?? URL.init(fileURLWithPath: "")))
    cell.label.text = filteredResults[indexPath.row].trackName
    //checks if app is free or not and displays the appropriate label
    if (filteredResults[indexPath.row].price == 0.00) {
      cell.priceLabel.text = "View"
    } else {
      cell.priceLabel.text = "$ \(String(filteredResults[indexPath.row].price))"
    }
    return cell
   // if (filterByFreePaidAll == "All") {
      
      
      //check if genre filter is appied
      //if not, display all api items
      //if genre is applied, display all items within that genre
      
    //} else if (filterByFreePaidAll == "Free") {
      
      //check if genre filter is applied,
      //if applied, display all free apps within specified genre
      //if not applied, display all free apps
      
      
   // } else if (filterByFreePaidAll == "Paid") {
      //check if genre filter is applied,
      //if applied, display all paid apps within specified genre
      //if not applied, display all paid apps
    //}
    
    
    //Returns all data from api without any filters
    
//    if (didFilterResults == false) {
//      //cell.cellImage.image = UIImage(data: api.imageArrayOfData[indexPath.row])
//      cell.cellImage.image = UIImage(data: try! Data(contentsOf: URL(string: api.storedData.results[indexPath.row].artworkUrl512) ?? URL.init(fileURLWithPath: "")))
//      cell.label.text = api.storedData.results[indexPath.row].trackName
//      //checks if app is free or not and displays the appropriate label
//      if (api.storedData.results[indexPath.row].price == 0.00) {
//        cell.priceLabel.text = "View"
//      } else {
//        cell.priceLabel.text = "$ \(String(api.storedData.results[indexPath.row].price))"
//      }
//
//      //returns all data from api where price is free and/or if an additional genre filter is applied
//    } else if (didFilterResults == true) {
//      cell.cellImage.image = UIImage(data: try! Data(contentsOf: URL(string: filteredResults[indexPath.row].artworkUrl512) ?? URL.init(fileURLWithPath: "")))
//      cell.label.text = filteredResults[indexPath.row].trackName
//      //checks if app is free or not and displays the appropriate label
//      if (filteredResults[indexPath.row].price == 0.00) {
//        cell.priceLabel.text = "View"
//      } else {
//        cell.priceLabel.text = "$ \(String(filteredResults[indexPath.row].price))"
//      }
//    }
//    return cell
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
      //adds new search data from API to local array
      self.filteredResults = self.api.storedData.results
      self.tableView.reloadData()
      //dismisses search bar after search is clicked
      self.searchController.isActive = false
      // self.activityIndicator.stopAnimating()
    }
  }
}





//8/29

//
//  ViewController.swift
//  iTunesSearchApplication
//
//  Created by Nicholas Repaci on 8/28/21.
//

//import UIKit
//import Foundation
//
////protocol PassDataToFilterScreenDelegate {
////  func passDataToFilterScreen(category: String, didFilterData: Bool, rowPreviouslySelected: Int)
////}
//
//class ViewController: UIViewController {
//
//  @IBOutlet weak var tableView: UITableView!
//  @IBOutlet weak var searchButton: UIBarButtonItem!
//  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//  @IBOutlet weak var filterButton: UIBarButtonItem!
//  @IBOutlet weak var segmentedControl: UISegmentedControl!
//  //var passDataToFilterScreenDelegate: PassDataToFilterScreenDelegate?
//  var api = API()
//  var localApiData: [Response] = []
//  var indexOfCurrentRow = 0
// // var imageDataArray = [Data]()
//  let searchController = UISearchController(searchResultsController: nil)
//  var filteredResults: [Result] = []
//  var filteredByPriceResults: [Result] = []
//  var filteredIndex: Int = 0
//  var selectedCategory: String = ""
//  var filterByFreePaidAll: String = "All"
//  var didFilterResults: Bool = false
//  var selectedRowForFilterPopup: Int = 0
//  var returnCount: Int = Int()
//  var isSearchBarEmpty: Bool {
//    return searchController.searchBar.text?.isEmpty ?? true
//  }
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    activityIndicator.hidesWhenStopped = true
//    //Prevents search bar from displaying as the incorrect color
//    self.extendedLayoutIncludesOpaqueBars = true
//    //self.navigationController?.isNavigationBarHidden = true
//    self.navigationController?.isNavigationBarHidden = false
//    tableView.dataSource = self
//    tableView.delegate = self
//    DataManager.shared.viewController = self
//    //be sure to make struing of IBM blank before publishing
//    api.loadData(search: "ibm") { Results in
//      self.tableView.reloadData()
//    }
//    self.title = "Apps"
//    searchController.searchBar.delegate = self
//    //dims background when search icon is tapped
//    searchController.obscuresBackgroundDuringPresentation = true
//    //adds placeholder to search field
//    searchController.searchBar.placeholder = "Search Apps"
//    //adds search bar to UI
//    navigationItem.searchController = searchController
//  }
//
//  override func viewDidAppear(_ animated: Bool) {
//    print(selectedRowForFilterPopup, "selectedfilterrow")
//  }
//
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    let detailsVC = segue.destination as! DetailsVC
//    //Determines whether user added a filter to the search results and passes the data from the appropriate array
//    if didFilterResults == false {
//      detailsVC.detailLabel = api.storedData.results[indexOfCurrentRow].description
//      detailsVC.appIcon = UIImage(data: try! Data(contentsOf: URL(string: api.storedData.results[indexOfCurrentRow].artworkUrl512) ?? URL.init(fileURLWithPath: "")))
//      //appDetailsVC.appIcon = UIImage(data: api.imageArrayOfData[indexOfCurrentRow])
//      detailsVC.appName = api.storedData.results[indexOfCurrentRow].trackName
//    } else {
//      detailsVC.detailLabel = filteredResults[indexOfCurrentRow].description
//      detailsVC.appIcon = UIImage(data: try! Data(contentsOf: URL(string: filteredResults[indexOfCurrentRow].artworkUrl512) ?? URL.init(fileURLWithPath: "")))
//      //appDetailsVC.appIcon = UIImage(data: api.imageArrayOfData[indexOfCurrentRow])
//      detailsVC.appName = filteredResults[indexOfCurrentRow].trackName
//    }
//
//  }
//
//  @IBAction func searchButtonClicked(_ sender: Any) {
//    self.searchController.isActive = true
//  }
//
//  @IBAction func filterButtonClicked(_ sender: Any) {
//    let filteredDataVC = storyboard?.instantiateViewController(identifier: "FilterData") as! FilterPopupVC
//    filteredDataVC.passDataToMainViewDelegate = self
//    filteredDataVC.selectedRow = selectedRowForFilterPopup
//    //passDataToFilterScreenDelegate?.passDataToFilterScreen(category: selectedCategory, didFilterData: didFilterResults, rowPreviouslySelected: selectedRowForFilterPopup)
//    //DataManager.shared.filterViewController.genreTableView.reloadData()
//    present(filteredDataVC, animated: true, completion: nil)
//    //navigationController?.pushViewController(filteredDataVC, animated: true)
//  }
//  @IBAction func segmentedControlChanged(_ sender: Any) {
//    switch segmentedControl.selectedSegmentIndex
//    {
//    case 0: //All
//      if (didFilterResults == true) {
//        filteredResults = api.storedData.results.filter { $0.primaryGenreName.contains(selectedCategory) }
//        //filteredResults = api.storedData.results.filter { $0.price >= 0 }
//        tableView.reloadData()
//      } else if (didFilterResults == false) {
//        filteredByPriceResults = []
//        tableView.reloadData()
//      }
//      filterByFreePaidAll = "All"
//    case 1: //Free
//      if (didFilterResults == true) {
//        filteredResults = api.storedData.results.filter { $0.primaryGenreName.contains(selectedCategory) }
//        filteredResults = api.storedData.results.filter { $0.price == 0 }
//        tableView.reloadData()
//      } else if (didFilterResults == false) {
//        filteredByPriceResults = api.storedData.results.filter { $0.price == 0 }
//        tableView.reloadData()
//      }
//      filterByFreePaidAll = "Free"
//      print("free")
//    case 2: //Paid
//      if (didFilterResults == true) {
//        filteredResults = api.storedData.results.filter { $0.primaryGenreName.contains(selectedCategory) }
//        filteredResults = api.storedData.results.filter { $0.price > 0 }
//        tableView.reloadData()
//      } else if (didFilterResults == false) {
//        filteredByPriceResults = api.storedData.results.filter { $0.price > 0 }
//        tableView.reloadData()
//      }
//      filterByFreePaidAll = "Paid"
//      print("paid")
//    default:
//      break
//    }
//  }
//
//  func performFilterOfResults(searchCriteria: String) {
//    filteredResults = api.storedData.results.filter { $0.primaryGenreName.contains(searchCriteria) }
////    if (filterByPaid == true) {
////      filteredResults = api.storedData.results.filter { $0.price > 0 }
////    }
//  }
//
//  func performFilterofAppPriceCategory() {
//
//  }
//}
//
//extension ViewController: PassDataToMainViewDelegate {
//  func passDataToMainView(category: String, filterDataYN: Bool, selectedRow: Int) {
//    selectedCategory = category
//    didFilterResults = filterDataYN
//    selectedRowForFilterPopup = selectedRow
//  }
//}
//
//extension ViewController: UITableViewDelegate {
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    indexOfCurrentRow = indexPath.row
//    performSegue(withIdentifier: "ShowAppDetails", sender: self)
//    //Prevents selected row from remaining highlighted
//    tableView.deselectRow(at: indexPath, animated: true)
//  }
//}
//
//extension ViewController: UITableViewDataSource {
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    //var count: Int = Int()
//    //return api.storedData.resultCount
//    if didFilterResults == false {
//      returnCount = api.storedData.resultCount
//      //returnCount = api.imageArrayOfData.count
//    } else {
//      returnCount = filteredResults.count
//    }
//    return returnCount
//  }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableCell
//    cell.cellImage.layer.cornerRadius = 25
//    //clips to bounds needed in order to apply cornerRadius to price label
//    cell.priceLabel.clipsToBounds = true
//    cell.priceLabel.backgroundColor = UIColor.init(red: 175/255, green: 185/255, blue: 186/255, alpha: 1)
//    cell.priceLabel.layer.cornerRadius = 15
//    //checks if user applied filter to results. Pulls data from appropriate array if filtered vs. not filtered
//
//    if didFilterResults == false {
//      //cell.cellImage.image = UIImage(data: api.imageArrayOfData[indexPath.row])
//      cell.cellImage.image = UIImage(data: try! Data(contentsOf: URL(string: api.storedData.results[indexPath.row].artworkUrl512) ?? URL.init(fileURLWithPath: "")))
//      cell.label.text = api.storedData.results[indexPath.row].trackName
//      //checks if app is free or not and displays the appropriate label
//      if (api.storedData.results[indexPath.row].price == 0.00) {
//        cell.priceLabel.text = "View"
//      } else {
//        cell.priceLabel.text = "$ \(String(api.storedData.results[indexPath.row].price))"
//      }
//    } else if (didFilterResults == true) {
//      cell.cellImage.image = UIImage(data: try! Data(contentsOf: URL(string: filteredResults[indexPath.row].artworkUrl512) ?? URL.init(fileURLWithPath: "")))
//      cell.label.text = filteredResults[indexPath.row].trackName
//      //checks if app is free or not and displays the appropriate label
//      if (filteredResults[indexPath.row].price == 0.00) {
//        cell.priceLabel.text = "View"
//      } else {
//        cell.priceLabel.text = "$ \(String(filteredResults[indexPath.row].price))"
//      }
//    }
//    return cell
//  }
//}
//
//extension ViewController: UISearchBarDelegate {
//  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//    let searchBar = searchController.searchBar
//    activityIndicator.startAnimating()
//    //Clearing array before api call to prevent index out of range
//    //self.api.imageArrayOfData.removeAll()
//    //change filter to false to no longer use filtered results when performing a new search
//    didFilterResults = false
//    //resets filter choice to 0 -- this changes the checked item on the filter popup to "All"
//    selectedRowForFilterPopup = 0
//
//    self.api.loadData(search: searchBar.text!) { Response in
//      //dismisses search bar after search is clicked
//
//      self.tableView.reloadData()
//      self.searchController.isActive = false
//      // self.activityIndicator.stopAnimating()
//    }
//  }
//}
//
//
//
