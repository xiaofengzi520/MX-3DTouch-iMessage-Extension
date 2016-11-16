//
//  ViewController.swift
//  MX-3DTouch-iMessage-Extension
//
//  Created by muxiao on 2016/11/15.
//  Copyright © 2016年 muxiao. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIViewControllerPreviewingDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerPreview();
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func registerPreview() {
        if self.traitCollection.forceTouchCapability == .available {
            self.registerForPreviewing(with: self, sourceView: self.view)
        }
    }
    
    //MARK: UIViewControllerPreviewingDelegate
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVc = storyboard.instantiateViewController(withIdentifier: "viewcontroller");
        secondVc.preferredContentSize = CGSize(width: 0, height: 500);
        previewingContext.sourceRect = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40)
        return secondVc;
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.show(viewControllerToCommit, sender: self);
    }
    
    override var previewActionItems: [UIPreviewActionItem]{
        get{
            let previewAction = UIPreviewAction(title: "点我啊", style: .default, handler: {
                (action, vc) in
                print(action.title);
            }
            )
            return [previewAction];
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

