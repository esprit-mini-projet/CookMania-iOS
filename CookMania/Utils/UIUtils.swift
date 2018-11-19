//
//  UIUtils.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/18/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit

final class UIUtils: NSObject {
    public static func showErrorAlert(title: String, message: String, viewController: UIViewController) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    public static func showErrorAlert(viewController: UIViewController) -> Void {
        let alert = UIAlertController(title: "Error", message: "Something went wrong. please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
}
