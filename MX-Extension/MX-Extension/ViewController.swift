//
//  ViewController.swift
//  MX-Extension
//
//  Created by muxiao on 2016/11/16.
//  Copyright © 2016年 muxiao. All rights reserved.
//

import UIKit
import SimpleTimerKit

let defaultTimeInterval: TimeInterval = 100
let taskDidFinishedInWidgetNotification: String = "com.xiaoself.simpleTimer.TaskDidFinishedInWidgetNotification"
let taskStartInWidgetNotification: String = "com.xiaoself.simpleTimer.TaskDidFinishedInWidgetNotification"

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    var timer:MXTimer!;
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive(_:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil);
        NotificationCenter.default
            .addObserver(self, selector: #selector(taskFinishedInWidget), name: NSNotification.Name(rawValue: taskDidFinishedInWidgetNotification), object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(startTimer(_:)), name: NSNotification.Name(rawValue: taskStartInWidgetNotification), object: nil)
    }
    

    private func showFinishAlert(_ finished: Bool) {
        let ac = UIAlertController(title: nil , message: finished ? "Finished" : "Stopped", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {[weak ac] action in ac!.dismiss(animated: true, completion: nil)}))
        present(ac, animated: true, completion: nil)
    }

    private func updateLabel() {
        timeLabel.text = timer.leftTimeString
    }

    dynamic private func taskFinishedInWidget() {
        if let realTimer = timer {
            let (stopped, error) = realTimer.stop(interrupt: false)
            if !stopped {
                if let realError = error {
                    print("error: \(realError.code)")
                }
            }
        }
    }
    

    func applicationWillResignActive(_ sender:Notification){
        if timer == nil {
            clearDefaults()
        } else {
            if timer.running {
                saveDefaults()
            } else {
                clearDefaults()
            }
        }
    }
    
    private func saveDefaults() {
        if let userDefault = UserDefaults(suiteName: "group.mxtimerSharedDefaults") {
            userDefault.set(Int(timer.leftTime), forKey: keyLeftTime)
            userDefault.set(Int(NSDate().timeIntervalSince1970), forKey: keyQuitDate)
            
            userDefault.synchronize()
        }
    }
    private func clearDefaults() {
        if let userDefault = UserDefaults(suiteName: "group.mxtimerSharedDefaults") {
            userDefault.removeObject(forKey: keyLeftTime)
            userDefault.removeObject(forKey: keyQuitDate)
            userDefault.synchronize()
        }
    }

    @IBAction func stopTimer(_ sender: Any) {
        if let realTimer = timer {
            let (stopped, error) = realTimer.stop(interrupt: true)
            if !stopped {
                if let realError = error {
                    print("error: \(realError.code)")
                }
            }
        }
    }
    @IBAction func startTimer(_ sender: Any) {
        if timer == nil {
            timer = MXTimer(timeInteral: defaultTimeInterval)
        }
        
        let (started, error) = timer.start({
            [weak self] leftTick in self!.updateLabel()
            }, stopHandler: {
                [weak self] finished in
                self!.showFinishAlert(finished)
                self!.timer = nil
        })
        
        if started {
            updateLabel()
        } else {
            if let realError = error {
                print("error: \(realError.code)")
            }
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

