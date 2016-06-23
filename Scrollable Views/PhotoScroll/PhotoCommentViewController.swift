/*
  PhotoCommentViewController
  
  Vertically Scrollable,
    achieved by setting the width of the container relative to the view size and setting the height to a constant height.
    i.e. (constant height) adding a lot of content in a view that wont be able to fit on a screen

    constraints in Interface Builder are key!
    we have three views:
      content, scrollView and topView
    
    content is constrained to top, bottom, leading and trailing edges of scrollView (value of 0)
    scrollView is constrained to top, bottom, leading and trailing edges of topView (value of 0)
    
    KEY CONSTRAINT : the width of the content is equal to width of topView (SKIPPING OVER SCROLL VIEW)
        and the Height of Content is set to a constant value (in this case 500)
    

*/

import UIKit

public class PhotoCommentViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var textField: UITextField!
  
  public var photoName: String!
  public var photoIndex: Int!
  
  // MARK: - Setup Views
  override public func viewDidLoad() {
    super.viewDidLoad()

    // photoName passed from colleciton view is loaded into view here
    if let photoName = photoName {
      self.imageView.image = UIImage(named: photoName)
    }
    
  // MARK: - Keyboard Observer
    
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: Selector("keyboardWillShow:"),
      name: UIKeyboardWillShowNotification,
      object: nil
    )
    
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: Selector("keyboardWillHide:") ,
      name: UIKeyboardWillHideNotification,
      object: nil
    )
  }
  
  // MARK: - Keyboard
  @IBAction func hideKeyboard(sender: AnyObject) {
    textField.endEditing(true)
  }
  
  func adjustInsetForKeyboardShow(show: Bool, notification: NSNotification) {
    // push content view upwards with height of keyboard and some padding
    
    guard let value = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
    let keyboardFrame = value.CGRectValue()
    
    let adjustmentHeight = (CGRectGetHeight(keyboardFrame) + 20) * (show ? 1 : -1) // take height from notification,  add 20 for padding

    scrollView.contentInset.bottom += adjustmentHeight
    scrollView.scrollIndicatorInsets.bottom += adjustmentHeight
  }
  
  // Hide or Show Keyboard
  func keyboardWillShow(notification: NSNotification) {
    adjustInsetForKeyboardShow(true, notification: notification)
  }
  func keyboardWillHide(notification: NSNotification) {
    adjustInsetForKeyboardShow(false, notification: notification)
  }
  
  deinit {    // Remove observers when PhotoCommentViewController not active (? i think ?)
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  // MARK: - ZoomingController
  
  @IBAction func openZoomingController(sender: AnyObject) {
    // Go to Zoomed Photo View Controller
    self.performSegueWithIdentifier("zooming", sender: nil)
  }
  
  override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let id = segue.identifier,
      zoomedPhotoViewController = segue.destinationViewController as? ZoomedPhotoViewController {
        if id == "zooming" {
          zoomedPhotoViewController.photoName = photoName
        }
    }
  }
}







