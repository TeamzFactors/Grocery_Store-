//
//  Cell.swift
//  Grecory Store
//
//  Created by Kasin Thappawan on 20/11/2565 BE.
//

import UIKit

class Cell: UITableViewCell {
    
    @IBOutlet weak var nameshow: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
