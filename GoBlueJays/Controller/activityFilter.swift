//
//  ActivityFilter.swift
//  GoBlueJays
//
//  Created by david on 11/15/22.
//

import UIKit
protocol userDidFilterDelegate: ActivityVC {
    func returnFilterCategory(info: [String])
}

class activityFilter: UIViewController {
    
    // MARK: All Buttons Array
    var allButtons = [UIButton]()
    @IBOutlet weak var academicsBtn: UIButton!
    @IBOutlet weak var sportBtn: UIButton!
    @IBOutlet weak var volunteerBtn: UIButton!
    @IBOutlet weak var artMakerBtn: UIButton!
    
    weak var delegate: userDidFilterDelegate?
    var info = [String]()
    var filterInfo = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Category"
        // initialize all buttons
        allButtons.append(academicsBtn)
        allButtons.append(sportBtn)
        allButtons.append(volunteerBtn)
        allButtons.append(artMakerBtn)
        
        for button in allButtons {
            button.backgroundColor = UIColor.cyan
        }
        
        // initialize filters with all categories selected
        info.append("Academic")
        info.append("Sport")
        info.append("Volunteer Opportunities")
        info.append("Art/Maker Space")
    }
    
    @IBAction func sendData(_ sender: Any) {
        if filterInfo.isEmpty {
            delegate?.returnFilterCategory(info: info)
        } else {
            delegate?.returnFilterCategory(info: filterInfo)
        }
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: click button and change color
    @IBAction func academicsBtnClicked(_ sender: Any) {
        if self.academicsBtn.backgroundColor == UIColor.cyan {
            self.academicsBtn.backgroundColor = UIColor.blue
            filterInfo.append("Academic")
        } else {
            self.academicsBtn.backgroundColor = UIColor.cyan
            if let index = filterInfo.firstIndex(of: "Academic") {
                filterInfo.remove(at: index)
            }
        }
    }
    @IBAction func sportBtnClicked(_ sender: Any) {
        if self.sportBtn.backgroundColor == UIColor.cyan {
            self.sportBtn.backgroundColor = UIColor.blue
            filterInfo.append("Sport")
        } else {
            self.sportBtn.backgroundColor = UIColor.cyan
            if let index = filterInfo.firstIndex(of: "Sport") {
                filterInfo.remove(at: index)
            }
        }
    }
    
    @IBAction func volunteerBtnClicked(_ sender: Any) {
        if self.volunteerBtn.backgroundColor == UIColor.cyan {
            self.volunteerBtn.backgroundColor = UIColor.blue
            filterInfo.append("Sport")
        } else {
            self.volunteerBtn.backgroundColor = UIColor.cyan
            if let index = filterInfo.firstIndex(of: "Sport") {
                filterInfo.remove(at: index)
            }
        }
    }
    
    @IBAction func artMakerBtnClicked(_ sender: Any) {
        if self.artMakerBtn.backgroundColor == UIColor.cyan {
            self.artMakerBtn.backgroundColor = UIColor.blue
            filterInfo.append("Sport")
        } else {
            self.artMakerBtn.backgroundColor = UIColor.cyan
            if let index = filterInfo.firstIndex(of: "Sport") {
                filterInfo.remove(at: index)
            }
        }
    }
}
