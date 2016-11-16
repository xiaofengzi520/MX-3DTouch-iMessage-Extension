//
//  PTGameStartViewController.swift
//  MX-Message-CustomStickerPacks
//
//  Created by muxiao on 2016/11/16.
//  Copyright © 2016年 muxiao. All rights reserved.
//

import UIKit

class MXGameStartViewController: UIViewController {

    var onButtonTap:((Void) -> Void)?
    @IBAction func startPlayGame(_ sender: Any) {
        onButtonTap?();
    }
}
