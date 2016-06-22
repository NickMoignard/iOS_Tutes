/*  ManagePageViewController Class
    
    Synopis: allow left/ right swiping to load new view controllers

    Notes:
      ViewControllers are programatically instantiated then set in viewDidLoad with setViewControllers() method
      
      a data source delegate must be set, in this case, self
      hence viewControllerBefore and viewControllerAfter functions must be implemented

    How Pagination Works:
      We first are passed the indexPath.row which has beem selected and we load the corresponding viewController
      in viewDidLoad()
      
      then with subsequent swipe gestures, viewDidLoad is called again, however the UIPageViewControllerDataSource delegate
      methods return a different view to be loaded than the current. depending on swipe left or right
*/

import UIKit

class ManagePageViewController: UIPageViewController {
  var photos = ["photo1", "photo2", "photo3", "photo5", "photo5"]
  var currentIndex: Int!
  
  override func viewDidLoad() {
    // Note: viewDidLoad() is called for every new pagination
    
    super.viewDidLoad()

    dataSource = self
    
    // Instantiate the View Controller(s) to be passed into page controller
    if let viewController = viewPhotoCommentController(currentIndex ?? 0) {
      let viewControllers = [viewController]
      
      setViewControllers(  // load the viewController
        viewControllers,
        direction: .Forward,
        animated: false,
        completion: nil)
    }
  }
  
  func viewPhotoCommentController(index: Int) -> PhotoCommentViewController? {
    // Progamatically create a PhotoCommentViewController
    
    if let storyboard = storyboard,
      page = storyboard.instantiateViewControllerWithIdentifier("PhotoCommentViewController") as? PhotoCommentViewController {
        page.photoName = photos[index]
        page.photoIndex = index
        return page
    }
    
    return nil
  }
  
}

extension ManagePageViewController: UIPageViewControllerDataSource {
  // Provide the correct content for paging forwards or backwards
  
  // This is done by grabbing the current viewController
  // Accessing its index
  // Instantiating a new view controller with the incremented/ decremented index
  // Then returning the new viewController.

  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    // Page backwards
    if let viewController = viewController as? PhotoCommentViewController {
      var index = viewController.photoIndex
      guard index != NSNotFound && index != 0 else { return nil }  // trap invalid parameters, early return if so
      index! -= 1
      return viewPhotoCommentController(index)
    }
    return nil
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    // Page forwards
    if let viewController = viewController as? PhotoCommentViewController {
      var index = viewController.photoIndex
      guard index != NSNotFound else { return nil }
      index! += 1
      guard index != photos.count else { return nil }  // don't go further than lenght of data source
      return viewPhotoCommentController(index)
    }
    return nil
  }
  // MARK: - UIPageControl
  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    // Number of pages to display in the controller
    return photos.count
  }
  
  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
    // Current page selected to display in controller
    return currentIndex ?? 0
  }
}











