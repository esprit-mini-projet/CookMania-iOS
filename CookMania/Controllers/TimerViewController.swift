//
//  TimerViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 12/22/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    var time: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func dismissTimerView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
