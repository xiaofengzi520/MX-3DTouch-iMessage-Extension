//
//  TodayViewController.swift
//  MX-TimerExtension
//
//  Created by muxiao on 2016/11/16.
//  Copyright © 2016年 muxiao. All rights reserved.
//

import UIKit
import NotificationCenter
import SimpleTimerKit

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBAction func switchTimer(_ sender: Any) {
        if switchButton.isOn {
            extensionContext?.open(URL(string: "simpleTimer://start")!, completionHandler: nil);
        }else{
            extensionContext?.open(URL(string: "simpleTimer://finished")!, completionHandler: nil);
        }
    }
    var timer: MXTimer!

    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var timerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(openLocalApp))
        view.addGestureRecognizer(tap);
        if let userDefaults = UserDefaults(suiteName: "group.mxtimerSharedDefaults") {
            let leftTimeWhenQuit = userDefaults.integer(forKey: keyLeftTime)
            let quitDate = userDefaults.integer(forKey: keyQuitDate)
            
            let passedTimeFromQuit = Date().timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(quitDate)))
            let leftTime = leftTimeWhenQuit - Int(passedTimeFromQuit)
            if (leftTime > 0) {
                timer = MXTimer(timeInteral: TimeInterval(leftTime))
                switchButton.setOn(true, animated: true);
                _ = timer.start({
                    [weak self] leftTick in self!.updateLabel()
                    }, stopHandler: {
                        [weak self] finished in self!.showFinished()
                })
            } else {
                showFinished()
            }
        }
    }
    
    private func showFinished() {
        timerLabel.text = "Finished"
        switchButton.setOn(false, animated: true);
    }

    private func updateLabel() {
        timerLabel.text = timer.leftTimeString
    }

    @objc private func openLocalApp(){
        extensionContext?.open(URL(string: "simpleTimer://")!, completionHandler: nil);

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
