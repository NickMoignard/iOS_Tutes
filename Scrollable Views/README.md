# Scroll Views

Simple app to demo UIScrollView usages.

Scrolling Functionality is a result of implementing a ScrollView inside the interface builder.
However Zooming requires implementing the ScrollViewDelegate in the view controller

App consists of,
	Nav Controller > Collection View > Page View Controller
	
		Detail View Controllers > Image Zooming Controllers

	after selecting a cell in the collection view, user is presented with a detail view of the image for commenting.
	the detail views are presented inside a pageViewController which allows swiping to the previous/ next image in the collection view
	tapping on the image in detail view brings up a zoomed in view for further inspection of the image
	
	NOTE: the Detail View Controllers are vertically scrollable.
		the zooming views are x & y axis scrollable

	Key Files:
		ZoomedPhotoViewController.swift
		PhotoCommentViewController.swift
		ManagePageViewController.swift
	
	Small changes to apps appearence are made in:
		AppDelegate.swift 
		
	

