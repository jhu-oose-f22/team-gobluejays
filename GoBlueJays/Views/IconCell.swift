//
//  IconCell.swift
//  GoBlueJays
//
//  Created by Jessie Luo on 8/14/22.
//

import UIKit

class IconCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var tabName: UIView!
    @IBOutlet weak var label: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
