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
        lineDashAnimation.isRemovedOnCompletion = false
        
        layer.add(lineDashAnimation, forKey: nil)
        
        view.layer.addSublayer(layer);
    }
    
    public static func downloadImage(url: URL, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = "\(documentPath)"+url.lastPathComponent
        print("File Path", documentPath)
        print("File Path", (URL(string: filePath)?.path)!)
        let fileUrl = (URL(string: filePath)?.path)!
        if FileManager.default.fileExists(atPath: fileUrl) {
            print("Exists")
            if let contetnsOfFielPath = UIImage(contentsOfFile: fileUrl) {
                completion(contetnsOfFielPath, nil)
            }
        }else {
            print("doesn't")
            UIUtils.downloadData(url: url) { data, response, error in
                if let error = error {
                    completion(nil, error)
                } else if let data = data, let image = UIImage(data: data) {
                    do {
                        if let pngImageData = image.pngData() {
                            try pngImageData.write(to: URL(string: filePath)!, options: .atomic)
                        }
                        completion(image, nil)
                    } catch {
                        completion(nil, NSError(domain: url.absoluteString, code: 500, userInfo: nil))
                    }
                } else {
                    completion(nil, NSError(domain: url.absoluteString, code: 400, userInfo: nil))
                }
            }
        }
    }
    
    fileprivate static func downloadData(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: url)) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
}
