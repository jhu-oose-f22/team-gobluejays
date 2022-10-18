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
    @IBOutlet weak var ActivityBlock2: UIView!
    
//    var activityID
    
    @IBAction func likes_click(_ sender: UIButton) {
        if collect.tag == 0 {
            let config = UIImage.SymbolConfiguration(scale: .medium)
            let image = UIImage(systemName: "heart.fill", withConfiguration: config)
            collect.setImage(image, for: .normal)
            collect.tintColor = .red
            collect.tag = 1
        } else {
            let config = UIImage.SymbolConfiguration(scale: .medium)
            let image = UIImage(systemName: "heart", withConfiguration: config)
            collect.setImage(image, for: .normal)
            collect.tintColor = .lightGray
            collect.tag = 0
        }
    }
    
    
    @IBAction func likes_click2(_ sender: UIButton) {
        if collect2.tag == 0 {
            let config = UIImage.SymbolConfiguration(scale: .medium)
            let image = UIImage(systemName: "heart.fill", withConfiguration: config)
            collect2.setImage(image, for: .normal)
            collect2.tintColor = .red
            collect2.tag = 1
        } else {
            let config = UIImage.SymbolConfiguration(scale: .medium)
            let image = UIImage(systemName: "heart", withConfiguration: config)
            collect2.setImage(image, for: .normal)
            collect2.tintColor = .lightGray
            collect2.tag = 0
        }
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
    
    func assign_ID() {
        
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
