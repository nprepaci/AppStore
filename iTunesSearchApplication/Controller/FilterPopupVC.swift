//
//  FilterPopupVC.swift
//  iTunesSearchApplication
//
//  Created by Nicholas Repaci on 8/28/21.
//

import UIKit

protocol PassDataDelegate {
  func passData(category: String, filterDataYN: Bool, selectedRow: Int)
}

class FilterPopupVC: UIViewController {
  
  @IBOutlet weak var popupContainer: UIView!
  @IBOutlet weak var genreTableView: UITableView!
  var delegate: PassDataDelegate?
  var selectedRow = 0
  var selectedCategory: String = String()
  var filterDataYN: Bool = Bool()
  var pickerData: [String] = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    pickerData = ["All", "Apple Watch Apps", "Books", "Business", "Developer Tools", "Education", "Entertainment", "Finance", "Food & Drink", "Graphic & Design", "Health & Fitness", "Kids", "Lifestyle", "Magazine & Newspaper", "Medical", "Music", "Navigation", "News", "Photo & Video", "Productivity", "Reference", "Shopping", "Social Networking", "Sports", "Travel", "Utilities", "Weather"]
    
    self.genreTableView.delegate = self
    self.genreTableView.dataSource = self
    
    popupContainer.layer.cornerRadius = 15
    genreTableView.layer.cornerRadius = 10
    
  }
  // MARK: - Navigation
  
  @IBAction func applyButtonClicked(_ sender: Any) {
    delegate?.passData(category: selectedCategory, filterDataYN: filterDataYN, selectedRow: selectedRow)
    
    DataManager.shared.viewController.performFilterOfResults(searchCriteria: selectedCategory)
    DataManager.shared.viewController.tableView.reloadData()
    dismiss(animated: true, completion: nil)
    
  }
}

extension FilterPopupVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedRow = indexPath.row
    for cell in tableView.visibleCells {
      cell.accessoryType = .none
    }
    //adds checkmark to selected row
    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    
    //if the user selects category of "All", changes filter data to false
    //doing this removes filter on table view, therefore displaying all search results
    if (indexPath.row == 0) {
      filterDataYN = false
      selectedCategory = ""
      //if a filter category is selected, filter criteria is then assigned to variables to pass via delegate method
    } else {
      filterDataYN = true
      selectedCategory = pickerData[indexPath.row]
      print(selectedCategory)
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      cell.accessoryType = indexPath.row == selectedRow ? .checkmark : .none
  }
}

extension FilterPopupVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pickerData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = genreTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
    cell.textLabel?.text = pickerData[indexPath.row]
    
    return cell
  }
}





