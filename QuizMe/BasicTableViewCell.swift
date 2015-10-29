//
//  BasicTableViewCell.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/26/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit

class BasicTableViewCell: UITableViewCell {

    
    @IBOutlet var lbType: UILabel!
    @IBOutlet var lbQuestion: UILabel!
    
    //@IBOutlet var tvAnswer: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
