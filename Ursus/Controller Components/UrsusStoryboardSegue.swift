//
//  UrsusStoryboardSegue.swift
//  Ursus
//
//  Created by Jeffery Jackson, Jr. on 12/1/16.
//  Copyright © 2016 Jeffery Jackson, Jr. All rights reserved.
//

import UIKit

class UrsusStoryboardSegue: UIStoryboardSegue {
    
    override func perform() {
		
		if self.identifier == "NewReleases->Release" {
			self.source.present(self.destination, animated: false)
		
		} else if self.identifier == "Release->NewReleases" {
			
			let release = self.source as! ReleaseViewController
			
			UIView.animate(withDuration: 0.4, animations: {
				release.blurView.effect = nil
			}, completion: { (completed) in
				self.source.dismiss(animated: false)
			})

		}
			
			
			
			
		else if self.identifier == "NewReleases->Settings" {
            
//            let settings = self.destination as! SettingsViewController
//            settings.view.addSubview(self.source.view.copy() as! UIView)
//            settings.view.removeConstraint(settings.newReleasesViewContainerRestingConstraint)
//            settings.view.addConstraint(settings.newReleasesViewContainerPresentedConstraint)
//            settings.view.layoutIfNeeded()

			self.source.present(self.destination, animated: false)
//            settings.view.removeConstraint(settings.newReleasesViewContainerPresentedConstraint)
//            settings.view.addConstraint(settings.newReleasesViewContainerRestingConstraint)
//            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
//                settings.view.layoutIfNeeded()
//            }, completion: nil)
			
		} else if self.identifier == "Settings->NewReleases" {
			self.source.dismiss(animated: false)
		}
		
			
			
			
		else if self.identifier == "NewReleases->Artists" {
			self.source.present(self.destination, animated: false)
			
		} else if self.identifier == "Artists->NewReleases" {
			self.source.dismiss(animated: false)
		}
			
			
			
			
			
        else if self.identifier == "NewReleases->ArtistSearch" {
            self.source.present(self.destination, animated: false)
			
		} else if self.identifier == "ArtistSearch->NewReleases" {
			
			let artistSearch = self.source as! ArtistSearchViewController
			
			artistSearch.searchBar.textField.text = ""
			
			DispatchQueue.main.async {
				
				artistSearch.searchBar.textField.resignFirstResponder()
				
				artistSearch.view.removeConstraint(artistSearch.searchBarCenteredConstraint)
				artistSearch.view.addConstraint(artistSearch.searchBarHidingConstraint)
				
				UIView.animate(withDuration: 0.85, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .curveEaseIn, animations: {
					
					artistSearch.view.layoutIfNeeded()
				}, completion: { (completed) in
					
					artistSearch.dismiss(animated: false)
				})
				
				UIView.animate(withDuration: 0.4, animations: {
					artistSearch.blurView.effect = nil
				})
			}
		}
			
			
			
			
			
        else if self.identifier == "ArtistSearch->ArtistSearchResults" {
            self.source.present(self.destination, animated: false)

        } else if self.identifier == "ArtistSearchResults->ArtistSearch" {
            self.source.dismiss(animated: false)
        }
        
        
			
			
        
        else if self.identifier == "ArtistSearch->Artist" {
            self.source.present(self.destination, animated: false)
            
        } else if self.identifier == "Artist->ArtistSearch" {
            self.source.dismiss(animated: false)
        }
			
			
			
			
			
		else if self.identifier == "Artist->Release" {
			self.source.present(self.destination, animated: false)
			
		} else if self.identifier == "Release->Artist" {

			let release = self.source as! ReleaseViewController
			
			UIView.animate(withDuration: 0.4, animations: {
				release.blurView.effect = nil
			}, completion: { (completed) in
				self.source.dismiss(animated: false)
			})
		}
    }
	
}
