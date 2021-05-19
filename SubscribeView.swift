//
//  SubscribeView.swift
//  Traductor
//
//  Created by Zara Davtyan on 13.05.21.
//  Copyright © 2021 Traductor. All rights reserved.
//

import UIKit

class SubscribeView: UIView {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
    
    var onSubscribe: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGradientLayer()
        descriptionLbl.text = NSLocalizedString("subscription_desc", comment: "")
        subscribeButton.setTitle(NSLocalizedString("subscribe", comment: "").uppercased(), for: .normal)
        subscribeButton.layer.cornerRadius = 6
    }
    
    func addGradientLayer() {
        let layer0 = CAGradientLayer()

        layer0.colors = [

          UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 0).cgColor,

          UIColor(red: 0.782, green: 0.782, blue: 0.782, alpha: 0.07).cgColor,

          UIColor(red: 0.914, green: 0.914, blue: 0.914, alpha: 0.81).cgColor,

          UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1).cgColor

        ]

        layer0.locations = [0, 0.06, 0.29, 1]

        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)

        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)

        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1.25, c: -1.25, d: 0, tx: 1.13, ty: 0))

        layer0.bounds = bgView.bounds.insetBy(dx: -0.5 * bgView.bounds.size.width, dy: -0.5 * bgView.bounds.size.height)

        layer0.position = self.center

        bgView.layer.addSublayer(layer0)
    }
    
    
    @IBAction func subscribeAction(_ sender: Any) {
        onSubscribe?()
    }
    
}
