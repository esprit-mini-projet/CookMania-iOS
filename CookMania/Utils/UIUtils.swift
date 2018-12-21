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
    
    public static func addRoudedDottedBorder(view: UIView, color: UIColor){
        let rect = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: view.frame.width, height: view.frame.height))
        let layer = CAShapeLayer.init()
        let path = UIBezierPath(roundedRect: rect, cornerRadius: view.frame.width/2)
        layer.path = path.cgPath;
        layer.strokeColor = color.cgColor
        layer.lineWidth = 2
        layer.lineDashPattern = [5,5];
        layer.backgroundColor = UIColor.clear.cgColor;
        layer.fillColor = UIColor.clear.cgColor;
        
        let lineDashAnimation = CABasicAnimation(keyPath: "lineDashPhase")
        lineDashAnimation.fromValue = layer.lineDashPattern?.reduce(0) { $0 + $1.intValue }
        lineDashAnimation.toValue = 0
        lineDashAnimation.duration = 0.7
        lineDashAnimation.repeatCount = Float.greatestFiniteMagnitude
        
        layer.add(lineDashAnimation, forKey: nil)
        
        view.layer.addSublayer(layer);
    }
}
