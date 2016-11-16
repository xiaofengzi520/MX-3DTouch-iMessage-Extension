//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by muxiao on 2016/11/16.
//  Copyright © 2016年 muxiao. All rights reserved.
//

import UIKit
import Messages

class MXMessagesViewController: MSMessagesAppViewController {
   // var stickers:[MSSticker] = []
    override func viewDidLoad() {
        super.viewDidLoad()

//        loadStickers()
//        createStickerBrowser()

        
    }
    
    override func didBecomeActive(with conversation: MSConversation) {
        configureChildViewController(for: presentationStyle, with: conversation)
    }
    
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        guard let conversation = self.activeConversation else { return }
        configureChildViewController(for: presentationStyle, with: conversation)
    }

}
private extension MXMessagesViewController{
     func configureChildViewController(for presentationStyle: MSMessagesAppPresentationStyle,
                                                  with conversation: MSConversation) {
        // Remove any existing child view controllers
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
        
        // Now let's create our new one
        let childViewController: UIViewController
        
        switch presentationStyle {
        case .compact:
            childViewController = createGameStartViewController()
        case .expanded:
            if let message = conversation.selectedMessage,
                let url = message.url {
                let model = MXGameModel(from: url)
                childViewController = createShipDestroyViewController(with: conversation, model: model)
            }
            else {
                childViewController = createShipLocationViewController(with: conversation)
            }
        }
        
        // Add controller
        addChildViewController(childViewController)
        childViewController.view.frame = view.bounds
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(childViewController.view)
        
        childViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        childViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        childViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        childViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        childViewController.didMove(toParentViewController: self)
    }
    
     func createShipLocationViewController(with conversation: MSConversation) -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "ShipLocationViewController") as? MXShipLocationViewController else {
            fatalError("Cannot instantiate view controller")
        }
        
        controller.onLocationSelectionComplete = {
            [unowned self]
            model, snapshot in
            
            let session = MSSession()
            let caption = "$\(conversation.localParticipantIdentifier) placed their ships! Can you find them?"
            
            self.insertMessageWith(caption: caption, model, session, snapshot, in: conversation)
            
            self.dismiss()
        }
        
        return controller
    }

    func createShipDestroyViewController(with conversation: MSConversation, model: MXGameModel) -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "ShipDestroyViewController") as? MXShipDestroyViewController else {
            fatalError("Cannot instantiate view controller")
        }
        
        controller.model = model
        controller.onGameCompletion = {
            [unowned self]
            model, playerWon, snapshot in
            
            if let message = conversation.selectedMessage,
                let session = message.session {
                let player = "$\(conversation.localParticipantIdentifier)"
                let caption = playerWon ? "\(player) destroyed all the ships!" : "\(player) lost!"
                
                self.insertMessageWith(caption: caption, model, session, snapshot, in: conversation)
            }
            
            self.dismiss()
        }
        
        return controller
    }
    
     func createGameStartViewController() -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "GameStartViewController") as? MXGameStartViewController else {
            fatalError("Cannot instantiate view controller")
        }
        
        controller.onButtonTap = {
            [unowned self] in
            self.requestPresentationStyle(.expanded)
        }
        
        return controller
    }

}

extension MXMessagesViewController {
    /// Constructs a message and inserts it into the conversation
    func insertMessageWith(caption: String,
                           _ model: MXGameModel,
                           _ session: MSSession,
                           _ image: UIImage,
                           in conversation: MSConversation) {
        let message = MSMessage(session: session)
        let template = MSMessageTemplateLayout()
        template.image = image
        template.caption = caption
        message.layout = template
        message.url = model.encode()
        conversation.insert(message)
    }
}

/*
private extension MXMessagesViewController{
    func loadStickers(){
        for i in 0...3 {
            if let url = Bundle.main.url(forResource: "image\(i)", withExtension: "png"){
                do {
                    let sticker = try MSSticker(contentsOfFileURL: url, localizedDescription: "");
                    stickers.append(sticker);
                } catch{
                    print(error);
                }
            }
        }
    }
    func createStickerBrowser(){
        let controller = MSStickerBrowserViewController(stickerSize: .large)
        addChildViewController(controller)
        view.addSubview(controller.view)
        //语法变了
        controller.stickerBrowserView.backgroundColor = UIColor.blue
        controller.stickerBrowserView.dataSource = self
        view.topAnchor.constraint(equalTo: controller.view.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: controller.view.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: controller.view.rightAnchor).isActive = true
    }
}

extension MXMessagesViewController: MSStickerBrowserViewDataSource{
    func numberOfStickers(in stickerBrowserView: MSStickerBrowserView) -> Int {
        return stickers.count
    }
    
    func stickerBrowserView(_ stickerBrowserView: MSStickerBrowserView, stickerAt index: Int) -> MSSticker {
        return stickers[index]
    }
}
 */
