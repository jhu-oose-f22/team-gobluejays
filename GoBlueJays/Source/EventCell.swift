//
//  EventCell.swift
//  timegenii
//
//  Created by Jeff Zhang on 14/9/17.
//  Copyright © 2017 unimelb. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class EventCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    
    var event: DefaultEvent!
    var borderColor:UIColor! = UIColor(hex: 0x0899FF)
    var contentColor:UIColor! = UIColor(hex: 0xEEF7FF)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupBasic()
    }
    
    func setupBasic() {
        self.clipsToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0
        locationLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.backgroundColor = contentColor
        borderView.backgroundColor = borderColor
    }
    
    func configureCell(event: DefaultEvent) {
        self.event = event
        locationLabel.text = event.location
        titleLabel.text = event.title
        print("configure")
        print(event.title)
        print(event.completed)
        if event.completed {
            contentColor = UIColor(hex: 0xfff1ee)
            borderColor = UIColor(hex: 0xe06560)
        }
        
    }
}
