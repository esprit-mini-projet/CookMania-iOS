//
//  TimerViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 12/22/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import HGCircularSlider
import AVFoundation

class TimerViewController: UIViewController {

    @IBOutlet weak var circularSlider: CircularSlider!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var playerSegmentedControl: UISegmentedControl!
    
    // date formatter user for timer label
    let dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        
        return formatter
    }()
    
    var time: Int?
    var seconds: Int = 1
    var isPaused: Bool = false
    var stopAlarm: Bool = false
    let systemSoundID: SystemSoundID = 1005
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        circularSlider.maximumValue = CGFloat(time!*60)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updatePlayerUI), userInfo: nil, repeats: true)
    }
    
    func playSystemSound(){
        AudioServicesPlaySystemSoundWithCompletion(systemSoundID) {
            if !self.stopAlarm{
                self.playSystemSound()
            }
        }
    }
    
    @IBAction func dismissTimerView(_ sender: Any) {
        timer?.invalidate()
        stopAlarm = true
        dismiss(animated: true, completion: nil)
    }
    
    @objc func updatePlayerUI() {
        if !isPaused {
            if seconds <= (time!*60) {
                circularSlider.endPointValue = CGFloat(seconds)
                var components = DateComponents()
                components.second = Int(seconds)
                timerLabel.text = dateComponentsFormatter.string(from: components)
                seconds+=1
            }else{
                timer?.invalidate()
                AudioServicesRemoveSystemSoundCompletion(systemSoundID);
                AudioServicesPlaySystemSound (systemSoundID)
                timerLabel.text = "Time is up!"
                playSystemSound()
            }
        }
    }
    
    @IBAction func playSegmentedToggled(_ sender: Any) {
        switch playerSegmentedControl.selectedSegmentIndex {
        case 0:
            isPaused = false
            break
        case 1:
            isPaused = true
            break
        default:
            print("default")
            break
        }
    }
    
    @IBAction func stopAlarm(_ sender: Any) {
        stopAlarm = true
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
