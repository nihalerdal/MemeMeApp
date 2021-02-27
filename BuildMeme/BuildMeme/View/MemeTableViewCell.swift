//
//  MemeTableViewCell.swift
//  BuildMeme
//
//  Created by Nihal Erdal on 2/26/21.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var tableCellImageView: UIImageView!
    
    @IBOutlet weak var memeTitle: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
