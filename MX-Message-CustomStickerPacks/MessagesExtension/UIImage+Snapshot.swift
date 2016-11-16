//
//  UIImage+Snapshot.swift
//  MX-Message-CustomStickerPacks
//
//  Created by muxiao on 2016/11/16.
//  Copyright © 2016年 muxiao. All rights reserved.
//

import Foundation
import UIKit
extension UIImage {
    /// Create an image represenation of the given view
    class func snapshot(from view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot!
    }
}
