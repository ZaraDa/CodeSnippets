//
//  ChatViewController+Presenters.swift
//  SceytDemoApp
//
//  Created by Zaruhi Davtyan on 9/3/20.
//  Copyright © 2020 Varmtech LLC. All rights reserved.
//

import Foundation
import UIKit
import Sceyt



extension ChatViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCell", for: indexPath) as! TextMessageCollectionViewCell
        cell.delegate = self
        let message = viewModel.messages[indexPath.row]
        configure(cell: cell, for: message, at: indexPath.row)
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
    
    func configure(cell: TextMessageCollectionViewCell, for message: SCTMessage, at index: Int) {
        cell.type = message.isIncomming == true ? .incoming : .outgoing
        cell.configure(message: message)
        cell.layout = viewModel.textLayouts[index]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = viewModel.textLayouts[indexPath.item]
        let size = CGSize(width: collectionView.frame.width, height: layout.totalHeight)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.messages.count - 9 {
            getMessages()
        }
    }
    
    
}
