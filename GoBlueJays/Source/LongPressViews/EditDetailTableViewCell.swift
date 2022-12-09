//
//  EditDetailTableViewCell.swift
//  AdvancedCalendar
//
//  Created by Kaia Gao on 11/27/22.
//

import UIKit
import JZCalendarWeekView

class EditDetailTableViewCell: UITableViewCell {
    static let identifier = "EditDetailTableViewCell"
    
    let datePicker = UIDatePicker()

    var cell:AllDayEvent!
    
    
    var label:UILabel = {
        var label = UILabel(frame: CGRect(x: 10, y: 5, width: 100, height: 40))
        label.text = "label"
        return label
    }()
    
    var textField:UITextField = {
        var field = UITextField(frame: CGRect(x: 120, y: 5, width: 200, height: 40))
        field.placeholder = "textField"
        field.addTarget(self, action: #selector(textDidChange(textField:)), for: .editingChanged)
        return field
    }()
    
    var btn:UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 120, y: 5, width: 50, height: 40)
        btn.backgroundColor = .systemBackground
        btn.setTitleColor(.systemRed, for: .normal)
        btn.setTitleColor(.systemGreen, for: .selected)
        btn.setTitle("No", for: .normal)
        btn.setTitle("Yes", for: .selected)
        btn.layer.borderWidth = 0
        
        return btn
    }()
    
    @objc func textDidChange(textField:UITextField){
        
        switch label.text{
        case "Title":
            self.cell.title = textField.text ?? "undefine"
        case "Location":
            self.cell.location = textField.text ?? "undefine"
        case "Note":
            self.cell.note = textField.text ?? "undefined"
        default:
            break
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupBasic()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textField.frame = CGRect(x: 120, y: 5, width: Int(frame.width)-100, height: Int(frame.height)-10)
        addSubviews([label,textField])
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        switch label.text{
        case "Complete":
            btn.becomeFirstResponder()
            
        default:
            textField.becomeFirstResponder()
            
        }
        
        
        
    }
    
    func setupBasic() {
        self.contentView.backgroundColor = .white
    }
    
    // update cell based on title state
    func updateCell(title: String, textField: String, cell:AllDayEvent) {
        self.label.text = title
        self.textField.text = textField
        self.cell = cell
        switch title{
        case "Title":
            self.textField.placeholder = textField
        case "Start":
            createDatePicker()
        case "End":
            createDatePicker()
        case "Complete":
            createCompleteBtn(with:textField)
        case "Note":
            self.textField.placeholder = textField
        default:
            self.textField.text = textField
        }
    }
    
    
    
    func createCompleteBtn(with textField: String){
        
        if textField == "true"{
            btn.isSelected = true
        }
        else{
            btn.isSelected = false
        }

        btn.addTarget(self, action: #selector(completePressed(sender:)), for: .touchUpInside)
        self.textField.removeFromSuperview()
        addSubview(btn)


    }
    
    @objc func completePressed(sender:UIButton){
        btn.isSelected = !btn.isSelected
        self.cell.completed = btn.isSelected
    }

    func createDatePicker(){
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar Button
        if #available(iOS 15.0, *) {
            let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDate))
            toolbar.setItems([doneBtn], animated: true)
        } else {
            // Fallback on earlier versions
        }
        
        // assign toolbar
        self.textField.inputAccessoryView = toolbar
        
        // assign date picker to the text field
        datePicker.frame = CGRect(x: 0, y: self.frame.height-200, width: self.frame.width, height: 200)
        self.textField.inputView = datePicker
    }
    
    @available(iOS 15.0, *)
    @objc func doneDate(){
        textField.text = "\(self.datePicker.date.formatted())"
        
        if self.label.text == "Start"{
            self.cell.startDate = self.datePicker.date
        }
        else if self.label.text == "End"{
            self.cell.endDate = self.datePicker.date
        }
        self.endEditing(true)
    }

    


}
