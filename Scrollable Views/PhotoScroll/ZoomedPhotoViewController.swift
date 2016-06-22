/*
  Scroll View Notes
  
  implement the delegate function viewForZoomingInScrollView() which returns the specific view
  
  center image each time zooming events occurs scrollViewDidZoom()

  inside viewDidLayoutSubviews() set the minimum Zoom and initialZoom, (triggers the above function to center)


*/

import UIKit

class ZoomedPhotoViewController: UIViewController, UIScrollViewDelegate {
  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet weak var scrollView: UIScrollView!

  @IBOutlet weak var bottomImageViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var topImageViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var leadingImageViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var trailingImageViewConstraint: NSLayoutConstraint!
  
  var photoName: String!
  
  // MARK: - Setup Views
  
  override func viewDidLoad() {
    imageView.image = UIImage(named: photoName)
    scrollView.delegate = self
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    updateMinZoomScaleForSize(view.bounds.size)
  }
  
  // MARK: - Scoll View
  
  private func updateMinZoomScaleForSize(size: CGSize) {
    /* set the initial zoomScale to have imageView fill the screen but not be cropped, and set this as the base level zoom */
    
    let widthScale = size.width / imageView.bounds.width
    let heightScale =  size.height / imageView.bounds.height
    let minScale = min(widthScale, heightScale)  // find which length gets cropped first by screen
    
    scrollView.minimumZoomScale = minScale   // don't make image smaller than screen
    scrollView.zoomScale = minScale  // set initial zoom as size of screen
  }
  
  private func updateConstraintsForSize(size: CGSize) {
    /* Center imageView on screen by programatically changing constraints on the imageView */
    
    let yOffset = max(0, (size.height - imageView.frame.height) / 2)
    let xOffset = max(0, (size.width - imageView.frame.width) / 2)
    
    topImageViewConstraint.constant = yOffset
    bottomImageViewConstraint.constant = yOffset
    leadingImageViewConstraint.constant = xOffset
    trailingImageViewConstraint.constant = xOffset
    
    view.layoutIfNeeded()
  }
  
  // MARK: - UIScrollViewDelegate Methods
  
  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    /*  Defines which view should be made bigger and smaller when the scroll view is pinched.
        the scrollView is basically a great big gesture recognizer that resizes a view underneath it!*/
    return imageView
  }
  
  func scrollViewDidZoom(scrollView: UIScrollView) {
    /* delegate method, gets called whenever zooming occurs */
    updateConstraintsForSize(view.bounds.size)
  }
  

  

}


