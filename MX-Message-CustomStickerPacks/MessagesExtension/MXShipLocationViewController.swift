//
//  MXShipLocationViewController.swift
//  MX-Message-CustomStickerPacks
//
//  Created by muxiao on 2016/11/16.
//  Copyright © 2016年 muxiao. All rights reserved.
//

import UIKit

class MXShipLocationViewController: UIViewController {

    @IBOutlet weak var finishedButton: UIButton!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var gameBoard: MXGameBoardView!
    var onLocationSelectionComplete: ((MXGameModel, UIImage) -> Void)?

    @IBAction func completedShipLocationSelection(_ sender: Any) {
        let model = MXGameModel(shipLocations: gameBoard.selectedCells, isComplete: false)
        gameBoard.reset()
        onLocationSelectionComplete?(model, UIImage.snapshot(from: gameBoard))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
        gameBoard.onCellSelection = {
            [unowned self]
            cellLocation in
            guard self.shipsLeftToPosition > 0 ||
                self.gameBoard.selectedCells.contains(cellLocation) else {
                    return
            }
            self.gameBoard.toggleCellStyle(at: cellLocation)
            self.updateLabels()
        }
    }

}
private extension MXShipLocationViewController {
     var shipsLeftToPosition: Int {
        return MXGameConstants.totalShipCount - self.gameBoard.selectedCells.count
    }
    
     func updateLabels() {
        remainingLabel.text = "Ships to Place: \(shipsLeftToPosition)"
        finishedButton.isEnabled = shipsLeftToPosition == 0
    }
}
