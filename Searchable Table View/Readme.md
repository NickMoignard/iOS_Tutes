  ADDING SEARCH CONTROLLER TO A TABLEVIEW

All implementation of search occurs inside MasterViewController.swift
Everything else is implentation of a basic two view tableView application

Check https://www.raywenderlich.com/113772/uisearchcontroller-tutorial
for the asscociated tutorial with this code

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

