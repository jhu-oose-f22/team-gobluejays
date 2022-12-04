//
//  ToastUtil.swift
//  JZiOSFramework
//
//  Created by Jeff Zhang on 22/3/18.
//  Copyright © 2018 Jeff Zhang. All rights reserved.
//

import UIKit
import JZCalendarWeekView

// From JZiOSFramework
open class ToastUtil {

    static private let defaultLabelSidesPadding: CGFloat = 20

    static private let defaultMidFont = UIFont.systemFont(ofSize: 13)
    static private let defaultMidBgColor = UIColor(hex: 0xE8E8E8)
    static private let defaultMidTextColor = UIColor.darkGray
    static private let defaultMidHeight: CGFloat = 40
    static private let defaultMidMinWidth: CGFloat = 80
    static private let defaultMidToBottom: CGFloat = 20 + UITabBarController().tabBar.frame.height

    static private let defaultExistTime: TimeInterval = 1.5
    static private let defaultShowTime: TimeInterval = 0.5

    static private var toastView: UIView!
    static private var toastLabel: UILabel!
    
    
    public static func addDetailPage(cell:JZBaseEvent? = nil){
        guard let currentscene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate, toastView == nil else { return }
        guard let currentWindow = currentscene.window else { return }

        if let allday = cell?.isKind(of: AllDayEvent.self){
            let allDayCell = cell as! AllDayEvent
            switch allDayCell.type{
            case 0: // event
                let controller =
                currentWindow.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "EventDetailStoryboard") as! EventDetailVC
                controller.event = allDayCell
                (((currentWindow.rootViewController?.presentedViewController as? UITabBarController)?.viewControllers![1] as? UINavigationController)?.viewControllers[0] as! LongPressViewController).present(controller, animated: true)
            case 1: // course
                break
            default:
                break
            }
            
            
        }
        
//        currentWindow.rootViewController?.performSegue(withIdentifier: "showEventDetail", sender: currentWindow.rootViewController)
        
    }
    
    
    public static func toastMessageInTheMiddle(message: String, bgColor: UIColor? = nil, existTime: TimeInterval? = nil, cell:JZBaseEvent? = nil) {
        guard let currentscene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate, toastView == nil else { return }
        guard let currentWindow = currentscene.window else { return }


        toastView = UIView()
        toastView.backgroundColor = defaultMidBgColor
        toastView.alpha = 0
        toastView.layer.cornerRadius = defaultMidHeight/2
        toastView.clipsToBounds = true
        addToastLabel(message: message)

        currentWindow.addSubview(toastView)
        var bottomYAnchor: NSLayoutYAxisAnchor
        // Support iPhone X
        if #available(iOS 11.0, *) {
            bottomYAnchor = currentWindow.safeAreaLayoutGuide.bottomAnchor
        } else {
            bottomYAnchor = currentWindow.bottomAnchor
        }
        toastView.setAnchorCenterHorizontallyTo(view: currentWindow, heightAnchor: defaultMidHeight, bottomAnchor: (bottomYAnchor, -defaultMidToBottom))
        toastView.widthAnchor.constraint(greaterThanOrEqualToConstant: defaultMidMinWidth).isActive = true

        let delay = existTime ?? defaultExistTime
        UIView.animate(withDuration: defaultShowTime, delay: 0, options: .curveEaseInOut, animations: {
            toastView.alpha = 1
            toastLabel.alpha = 1
        }, completion: { _ in

            UIView.animate(withDuration: defaultShowTime, delay: delay, options: .curveEaseInOut, animations: {
                toastView.alpha = 0
                toastLabel.alpha = 0
            }, completion: { _ in
                toastView.removeFromSuperview()
                toastView = nil
            })
        })
    }
    
    
    private static func addToastLabel(message: String) {
        toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.font = defaultMidFont
        toastLabel.textColor = defaultMidTextColor
        toastLabel.textAlignment = .center
        toastLabel.alpha = 0
        toastView.addSubview(toastLabel)
        toastLabel.centerYAnchor.constraint(equalTo: toastView.centerYAnchor, constant: 0).isActive = true
        toastLabel.setAnchorCenterVerticallyTo(view: toastView, heightAnchor: defaultMidHeight, leadingAnchor: (toastView.leadingAnchor, defaultLabelSidesPadding), trailingAnchor: (toastView.trailingAnchor, -defaultLabelSidesPadding))
    }
}
