//
//  MXShipDestroyViewController.swift
//  MX-Message-CustomStickerPacks
//
//  Created by muxiao on 2016/11/16.
//  Copyright © 2016年 muxiao. All rights reserved.
//

import UIKit

class MXShipDestroyViewController: UIViewController {

    @IBOutlet weak var shipsLabel: UILabel!
    @IBOutlet weak var attemptsLabel: UILabel!
    @IBOutlet weak var gameBoard: MXGameBoardView!
    var model: MXGameModel!
    var onGameCompletion: ((MXGameModel, Bool, UIImage) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        if model.isComplete {
            let alert = UIAlertController(title: "Game Complete!", message: "The game's already finished!", preferredStyle: .alert)
            present(alert, animated: true)
            gameBoard.isHidden = true
            attemptsLabel.isHidden = true
            shipsLabel.isHidden = true
            return
        }
        updateLabels()
        gameBoard.onCellSelection = {
            [unowned self]
            cellLocation in
            
            if self.model.shipLocations.contains(cellLocation) {
                self.gameBoard.alterCell(at: cellLocation, applying: .selectedGreen)
            }
            else {
                self.gameBoard.alterCell(at: cellLocation, applying: .selectedRed)
            }
            
            self.updateLabels()
            self.checkGameCompletion()
        }

    }

}

 extension MXShipDestroyViewController {
    func updateLabels() {
        shipsLabel.text = "Hit: \(shipsHitCount())/\(MXGameConstants.totalShipCount)"
        
        let livesRemaining = MXGameConstants.incorrectAttemptsAllowed - incorrectAttemptsCount()
        attemptsLabel.text = "Lives: \(livesRemaining)/\(MXGameConstants.incorrectAttemptsAllowed)"
    }
}

// Kick to main screen when game complete
extension MXShipDestroyViewController {
    func checkGameCompletion() {
        let snapshot = UIImage.snapshot(from: gameBoard)
        
        if incorrectAttemptsCount() >= MXGameConstants.incorrectAttemptsAllowed {
            model.isComplete = true
            onGameCompletion?(model, false, snapshot)
        }
        else if shipsHitCount() == MXGameConstants.totalShipCount {
            model.isComplete = true
            onGameCompletion?(model, true, snapshot)
        }
    }
    
    func incorrectAttemptsCount() -> Int {
        return gameBoard.selectedCells.filter { !model.shipLocations.contains($0) }.count
    }
    
    func shipsHitCount() -> Int {
        return gameBoard.selectedCells.filter { model.shipLocations.contains($0) }.count
    }
}

