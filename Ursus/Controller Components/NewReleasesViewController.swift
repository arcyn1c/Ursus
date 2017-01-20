//
//  NewReleasesViewController.swift
//  Ursus
//
//  Created by Jeffery Jackson on 11/12/16.
//  Copyright © 2016 Jeffery Jackson, Jr. All rights reserved.
//

import UIKit

class NewReleasesViewController: UrsusViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
		
	@IBOutlet weak var settingsButton: SettingsButton!
	@IBOutlet weak var artistsButton: ArtistsButton!
	@IBOutlet weak var searchButton: SearchButton!
	
	@IBOutlet weak var newReleasesCountIndicator: UrsusCountIndicator!
	
	@IBOutlet weak var settingsButtonShowingConstraint: NSLayoutConstraint!
	@IBOutlet weak var settingsButtonHidingConstraint: NSLayoutConstraint!
	@IBOutlet weak var artistsButtonShowingConstraint: NSLayoutConstraint!
	@IBOutlet weak var artistsButtonHidingConstraint: NSLayoutConstraint!
	@IBOutlet weak var searchButtonShowingConstraint: NSLayoutConstraint!
	@IBOutlet weak var searchButtonHidingConstraint: NSLayoutConstraint!
	@IBOutlet weak var searchButtonRestingSizeConstraint: NSLayoutConstraint!
	@IBOutlet weak var searchButtonFocusedSizeConstraint: NSLayoutConstraint!
    @IBOutlet weak var newReleasesCountIndicatorHidingConstraint: NSLayoutConstraint!
    @IBOutlet weak var newReleasesCountIndicatorRestingConstraint: NSLayoutConstraint!
			
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		let refreshControl = UIRefreshControl(frame: CGRect(x: 0, y: 100, width: 45, height: 45))
//		self.collectionView.addSubview(refreshControl)
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		PreferenceManager.shared.updateNewReleases {
			
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
			DispatchQueue.main.async {
				// update new release count
				self.newReleasesCountIndicator.setTitle(String(PreferenceManager.shared.newReleases.count), for: .normal)
				
				self.collectionView?.reloadData()
				
			}
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if PreferenceManager.shared.followingArtists.isEmpty {
			self.bottomScrollFadeView?.alpha = 0.5
		}
		
		DispatchQueue.main.async {
			
			if PreferenceManager.shared.themeMode == .dark {
				self.collectionView?.indicatorStyle = .white
			} else {
				self.collectionView?.indicatorStyle = .black
			}
			
		}

	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if PreferenceManager.shared.followingArtists.isEmpty {
			
			DispatchQueue.main.async {
				
				self.backdrop?.overlay.removeConstraints([self.settingsButtonHidingConstraint, self.searchButtonHidingConstraint])
				self.backdrop?.overlay.addConstraints([self.settingsButtonShowingConstraint, self.searchButtonShowingConstraint])
				self.searchButton?.removeConstraint(self.searchButtonRestingSizeConstraint)
				self.searchButton?.addConstraint(self.searchButtonFocusedSizeConstraint)
			}
			
			// show search bar
			if PreferenceManager.shared.firstLaunch {
				self.performSegue(withIdentifier: "NewReleases->ArtistSearch", sender: nil)
				PreferenceManager.shared.firstLaunch = false
			}
			
		} else {
			
			DispatchQueue.main.async {
				
				self.backdrop?.overlay.removeConstraints([self.settingsButtonHidingConstraint, self.artistsButtonHidingConstraint, self.searchButtonHidingConstraint])
				self.backdrop?.overlay.addConstraints([self.settingsButtonShowingConstraint, self.artistsButtonShowingConstraint, self.searchButtonShowingConstraint])
				
				if PreferenceManager.shared.newReleases.isEmpty {
				
					self.searchButton?.removeConstraint(self.searchButtonRestingSizeConstraint)
					self.searchButton?.addConstraint(self.searchButtonFocusedSizeConstraint)
				} else {
					self.backdrop?.overlay.removeConstraint(self.newReleasesCountIndicatorHidingConstraint)
					self.backdrop?.overlay.addConstraint(self.newReleasesCountIndicatorRestingConstraint)
				}
			}
		}
		
		DispatchQueue.main.async {
			
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
				
				self.backdrop?.overlay.layoutIfNeeded()
				self.searchButton?.layoutIfNeeded()
				self.searchButton?.setNeedsDisplay()
			})
		}
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	
	
	
	// MARK: - Custom Functions
	
	
	
	
	
	// MARK: - Notifications
	override func themeDidChange() {

		super.themeDidChange()
		
		DispatchQueue.main.async {
			
			if PreferenceManager.shared.themeMode == .dark {
				self.collectionView?.indicatorStyle = .white
			} else {
				self.collectionView?.indicatorStyle = .black
			}
			
		}
		
	}
	
	
	
	
	
	// MARK: - UICollectionViewDataSource
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return PreferenceManager.shared.newReleases.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewReleaseCell", for: indexPath) as! ReleaseCollectionViewCell
		
		cell.releaseTitleLabel.text = PreferenceManager.shared.newReleases[indexPath.row].title
		
		// get artist
		if let artist: Artist = PreferenceManager.shared.followingArtists.first(where: {
			$0.releases.contains(where: {
				$0.itunesID == PreferenceManager.shared.newReleases[indexPath.row].itunesID
			})
		}) {
			cell.secondaryLabel.text = artist.name
		}
		
		RequestManager.shared.loadImage(from: PreferenceManager.shared.newReleases[indexPath.row].thumbnailURL!) { (image, error) in
			
			DispatchQueue.main.async {
				cell.releaseArtView.imageView.image = image
				cell.releaseArtView.showArtwork()
			}
		}
		
		return cell
	}
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "NoNewReleasesFooter", for: indexPath) as! FooterCollectionReusableView
        return reusableView
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.bounds.size.width, height: 100)
	}
	
	
	
	
	
	
	// MARK: - Navigation
	func dismissDestination() {
		self.presentedViewController?.performSegue(withIdentifier: "Settings->NewReleases", sender: nil)
	}
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
		
		if segue.identifier == "NewReleases->Release" {
			// set current release for release view controller
			(segue.destination as! ReleaseViewController).currentRelease = PreferenceManager.shared.newReleases[(self.collectionView?.indexPathsForSelectedItems?[0].row)!]
			
			// adjust colors
			if PreferenceManager.shared.themeMode == .dark {
				segue.destination.view.tintColor = StyleKit.darkBackgroundColor
			} else {
				segue.destination.view.tintColor = StyleKit.lightBackgroundColor
			}
		}
		
		else if segue.identifier == "NewReleases->Settings" {
			let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissDestination))
			self.view.addGestureRecognizer(tapGestureRecognizer)
		}
	}
}