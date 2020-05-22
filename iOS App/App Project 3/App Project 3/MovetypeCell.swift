//
//  Movetype.swift
//  App Project 3
//
//  Created by Wade on 9/30/18.
//  Copyright © 2018 Wade Murdock. All rights reserved.
//

import UIKit

class MovetypeCell: UITableViewCell {
    
    @IBOutlet var Name_Label: UILabel!
    @IBOutlet var Img_View: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
