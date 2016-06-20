/*
  ADDING SEARCH CONTROLLER TO A TABLEVIEW

  Key Concepts
    - Intialize the Search Controller, Properties and Add to View
      -> this includes adding scope buttons

    - The SearchViewController to conform to UISearchResultsUpdating protocol
      -> must implement updateSearchResultsForSearchController()
    
    - Create a robost data filtering/ results populating function that accepts scopes
  
    - Scope Implementation, Requires conformation to UISearchBarDelegate



  Key Concepts
    - The protocol extension to the ViewController informs the ViewController of every change to search with searchBar context
      -> hence we call our results populating/filtering function here with info from searchBar.

    - When Populating the tableView, we must either use unfiltered data or filtered data.
      -> it is important to swap between the two data sources when the search is active or not
*/

import UIKit

class MasterViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
  
  // MARK: - Properties
  var detailViewController: DetailViewController? = nil
  var candies = [Candy]()
  var filteredCandies = [Candy]()
  
  // MARK: Search Controller
  let searchController = UISearchController(searchResultsController: nil)

  
  // MARK: - View Setup
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // NOTE: Populate tableView
    candies = [
        Candy(category:"Chocolate", name:"Chocolate Bar"),
        Candy(category:"Chocolate", name:"Chocolate Chip"),
        Candy(category:"Chocolate", name:"Dark Chocolate"),
        Candy(category:"Hard", name:"Lollipop"),
        Candy(category:"Hard", name:"Candy Cane"),
        Candy(category:"Hard", name:"Jaw Breaker"),
        Candy(category:"Other", name:"Caramel"),
        Candy(category:"Other", name:"Sour Chew"),
        Candy(category:"Other", name:"Gummi Bear")
    ]

    // MARK: - Search Controller Parameters
    
    searchController.searchResultsUpdater = self // protocol allows viewController to be informed as text changes within search bar
    searchController.dimsBackgroundDuringPresentation = false
    definesPresentationContext = true  // important, ensures search controller is removed after navigating to other views
    tableView.tableHeaderView = searchController.searchBar  // add the search bar to header
    searchController.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
    searchController.searchBar.delegate = self
  
    // MARK: - View Setup
    if let splitViewController = splitViewController {
      let controllers = splitViewController.viewControllers
      detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? DetailViewController
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    clearsSelectionOnViewWillAppear = splitViewController!.collapsed
    super.viewWillAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Results Populating Function (UISearchResultsUpdating)
  func filterContentForSearchText(searchText: String, scope: String = "All") {
    filteredCandies = candies.filter { candy in
      
      let categoryMatch = (scope == "All") || (candy.category == scope)
      let stringMatch: Bool
      if searchText == "" {
        stringMatch = true
      } else {
        print("searchText == \(searchText)")
        stringMatch = candy.name.lowercaseString.containsString(searchText.lowercaseString)
      }
      print(stringMatch, categoryMatch)
      return stringMatch && categoryMatch
      
    }
    
    tableView.reloadData()
  }
  // MARK: - UISearchBarDelegate Method
  func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
  }
  
  // MARK: - UISearchResultsUpdating Protocol Conformation
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    let searchBar = searchController.searchBar
    let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
    filterContentForSearchText(searchController.searchBar.text!, scope: scope)
  }
  
  // MARK: - Table View
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // NOTE: Search Controller
    if searchController.active {
      return filteredCandies.count
    }
    return candies.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
    
    let candy: Candy
    
    // NOTE: Search Controller
    if searchController.active {
      candy = filteredCandies[indexPath.row]
    } else {
      candy = candies[indexPath.row]
    }
    cell.textLabel!.text = candy.name
    cell.detailTextLabel!.text = candy.category
    return cell
  }
  
  // MARK: - Segues
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showDetail" {
      if let indexPath = tableView.indexPathForSelectedRow {
        
        let candy: Candy
        if searchController.active {
          candy = filteredCandies[indexPath.row]
        } else {
          candy = candies[indexPath.row]
        }
        
        let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
        controller.detailCandy = candy
        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        controller.navigationItem.leftItemsSupplementBackButton = true
      }
    }
  }
}



