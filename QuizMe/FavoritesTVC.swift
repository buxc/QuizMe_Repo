//
//  FavoritesTVC.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 12/11/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit

class FavoritesTVC: UITableViewCell {

    // MARK: - Data members
    var favorited = false
    var pid = 0 //pid of set
    
    // MARK: - IBOutlets
    @IBOutlet var btFavorite: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK: - Button presses
    @IBAction func btFavorite_OnClick(sender: AnyObject) {
        if favorited == true{
             accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            favorited = false
        }else{
            accessoryType = UITableViewCellAccessoryType.Checkmark
            favorited = true
        }
        NSNotificationCenter.defaultCenter().postNotificationName("Favorite_key", object: nil,userInfo: ["pid":"\(pid)","fav":"\(!favorited)"])//tells vc to add set to favorites in db
        NSNotificationCenter.defaultCenter().postNotificationName("favorites_fetch_key", object: self)//tells favsVC to refetch favorites
    }
}
