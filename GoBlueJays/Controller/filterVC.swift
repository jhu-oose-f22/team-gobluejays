//
//  filterVC.swift
//  GoBlueJays
//
//  Created by 刘忻岩 on 12/4/22.
//

import UIKit
protocol userFilterDelegate: ActivityVC {
    func returnFilter(category: String, rank: String)
}

class filterVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    weak var delegate: userFilterDelegate?
    
    @IBOutlet weak var reset: UIButton!
    @IBOutlet weak var apply: UIButton!
    
    @IBOutlet weak var rank_btn: UIButton!
    @IBOutlet weak var rankField: UITextField!
    var rank_list: [String] = ["Nearby","Upcoming"]
    @IBOutlet weak var cat_btn: UIButton!
    @IBOutlet weak var categoryField: UITextField!
    var category_list: [String] = []
    
    var selectedRow = 0
    var selectedRow2 = 0
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 2
    
    var currentCategoryMessage = "Choose a category"
    var currentRankMessage = "Rank by ..."
    
    @IBAction func resetClick(_ sender: Any) {
        delegate?.returnFilter(category: "reset", rank: "reset")
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func applyClick(_ sender: Any) {
        if categoryField.text == "Choose a category" || rankField.text == "Rank by ..." {
            showAlert(message: "Please fulfill filter options")
        } else {
            delegate?.returnFilter(category: category_list[selectedRow], rank: rank_list[selectedRow2])
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func popCatPickUp(_ sender: Any) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = 1
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Select Activity Category", message: "", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = pickerView
        alert.popoverPresentationController?.sourceRect = pickerView.bounds
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            self.categoryField.text = self.currentCategoryMessage
        }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
            self.selectedRow = pickerView.selectedRow(inComponent: 0)
            self.categoryField.text = self.category_list[self.selectedRow]
        }))
        
        self.present(alert,animated: true, completion:nil)
        categoryField.inputView = pickerView
    }
    
    
    @IBAction func popRankPickUp(_ sender: Any) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = 2
        pickerView.selectRow(selectedRow2, inComponent: 0, animated: false)
        
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Select Rank Basis", message: "", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = pickerView
        alert.popoverPresentationController?.sourceRect = pickerView.bounds
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            self.rankField.text = self.currentRankMessage
        }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
            self.selectedRow2 = pickerView.selectedRow(inComponent: 0)
            self.rankField.text = self.rank_list[self.selectedRow2]
        }))
        
        self.present(alert,animated: true, completion:nil)
        rankField.inputView = pickerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonConfig()
        fieldConfig()
        
        if categoryField.text != "Choose a category" {
            selectedRow = category_list.firstIndex(of: currentCategoryMessage) ?? 0
        }
        if rankField.text != "Rank by ..." {
            selectedRow2 = rank_list.firstIndex(of: currentRankMessage) ?? 0
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        present(alert,animated:true)
    }
    
    func fieldConfig() {
        categoryField.textColor = .systemGray3
        categoryField.text = currentCategoryMessage
        rankField.textColor = .systemGray3
        rankField.text = currentRankMessage
    }
    
    func buttonConfig() {
        let config = UIImage.SymbolConfiguration(scale: .medium)
        let image = UIImage(systemName: "chevron.down.circle", withConfiguration: config)
        cat_btn.setTitle("", for: .normal)
        cat_btn.imageView?.contentMode = .scaleAspectFit
        cat_btn.setImage(image, for: .normal)
        cat_btn.tintColor = .systemBlue
        
        rank_btn.setTitle("", for: .normal)
        rank_btn.imageView?.contentMode = .scaleAspectFit
        rank_btn.setImage(image, for: .normal)
        rank_btn.tintColor = .systemBlue
        
        reset.backgroundColor = .systemGray6
        reset.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        reset.setTitle("Reset", for: .normal)
        reset.setTitleColor(UIColor.systemBlue, for: .normal)
        reset.layer.cornerRadius = 5
        
        apply.backgroundColor = .systemGray6
        apply.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        apply.setTitle("Apply", for: .normal)
        apply.setTitleColor(UIColor.systemBlue, for: .normal)
        apply.layer.cornerRadius = 5
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return category_list.count
        } else if pickerView.tag == 2 {
            return rank_list.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return category_list[row]
        } else if pickerView.tag == 2 {
            return rank_list[row]
        }
        return nil
    }
}
