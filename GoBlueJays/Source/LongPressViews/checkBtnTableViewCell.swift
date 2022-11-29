//
//  checkBtnTableViewCell.swift
//  AdvancedCalendar
//
//  Created by Kaia Gao on 11/27/22.
//

import UIKit

class checkBtnTableViewCell: UITableViewCell {
    static let identifier = "checkBtnTableViewCell"
    
    
    var label:UILabel = {
        var label = UILabel(frame: CGRect(x: 10, y: 5, width: 100, height: 40))
        label.text = "label"
        return label
    }()
    
    var btn: UIButton = {
        var btn = UIButton()
        btn.setTitle("No", for: .normal)
        btn.setTitle("Yes", for: .selected)
  
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(completePressed(sender:)), for: .touchUpInside)
        return btn
    }()

    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupBasic()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews([label,btn])
        
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        btn.becomeFirstResponder()
        
        
    }
    
    func setupBasic() {
        self.contentView.backgroundColor = .white
//        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(headerViewTapped)))
    }
    
    func updateCell(title: String, textField: String) {
        self.label.text = title
        btn.addTarget(self, action: #selector(completePressed(sender:)), for: .touchUpInside)
        }
    
    
    
    @objc func completePressed(sender: UIButton){
        sender.isSelected = !sender.isSelected
    }


}
