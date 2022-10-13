//
//  ActivityCell.swift
//  GoBlueJays
//
//  Created by 刘忻岩 on 10/7/22.
//

import UIKit

class ActivityCell: UITableViewCell{
    

    @IBOutlet weak var ActivityImage: UIImageView!
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var collect: UIButton!
    @IBOutlet weak var back: UIView!
    
    @IBOutlet weak var Title2: UILabel!
    @IBOutlet weak var time2: UILabel!
    @IBOutlet weak var collect2: UIButton!
    @IBOutlet weak var location2: UILabel!
    @IBOutlet weak var ActivityImage2: UIImageView!
    @IBOutlet weak var back2: UIView!
    
    @IBAction func tapBotton() {
        
    }
    
    func configure() {
        collect.setTitle("", for: .normal)
        collect.tintColor = .lightGray
        collect.imageView?.contentMode = .scaleAspectFit
        collect2.setTitle("", for: .normal)
        collect2.tintColor = .lightGray
        collect2.imageView?.contentMode = .scaleAspectFit
        
        ActivityImage.layer.cornerRadius = 5
        ActivityImage.clipsToBounds = true
        ActivityImage2.layer.cornerRadius = 5
        ActivityImage2.clipsToBounds = true
        
        back.layer.cornerRadius = 5
        back.clipsToBounds = true
        back2.layer.cornerRadius = 5
        back2.clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collect.setTitleColor(.link, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
