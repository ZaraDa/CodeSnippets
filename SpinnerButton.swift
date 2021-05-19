//
//  SpinnerButton.swift
//  SceytDemoApp
//
//  Created by Zaruhi Davtyan on 8/19/20.
//  Copyright © 2020 Varmtech LLC. All rights reserved.
//

import Foundation
import UIKit

class RoundedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = bounds.height / 2
    }
}



class SpinnerButton: RoundedButton {
    var spinnerColor: UIColor = UIColor.white {
        didSet {
            spiner.color = spinnerColor
        }
    }
    private lazy var spiner: SpinerLayer = {
        let spiner = SpinerLayer()
        self.layer.addSublayer(spiner)
        return spiner
    }()
    
    private var cachedTitle: String?
    private var cachedImage: UIImage?
    
    private let shrinkCurve = CAMediaTimingFunction(name: .linear)
    private let expandCurve = CAMediaTimingFunction(controlPoints: 0.95, 0.02, 1, 0.05)
    private let shrinkDuration: CFTimeInterval = 0.1

    init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        spiner.setToFrame(self.frame)
    }
    
    private func setup() {
        spiner.color = spinnerColor
    }
    
    func startAnimation() {
        isUserInteractionEnabled = false
        cachedTitle = title(for: .normal)
        cachedImage = image(for: .normal)
        setTitle("",  for: .normal)
        setImage(nil, for: .normal)
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.layer.cornerRadius = self.frame.height / 2
        }, completion: { completed -> Void in
            self.shrink()
            self.spiner.animation()
        })
    }
    
    func stopAnimation() {
        self.setOriginalState()
    }
    
    private func setOriginalState() {
        animateToOriginalWidth()
        spiner.stopAnimation()
        setTitle(self.cachedTitle, for: .normal)
        setImage(self.cachedImage, for: .normal)
        isUserInteractionEnabled = true
    }
 
    private func animateToOriginalWidth() {
        let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnim.fromValue = (self.bounds.height)
        shrinkAnim.toValue = (self.bounds.width)
        shrinkAnim.duration = shrinkDuration
        shrinkAnim.timingFunction = shrinkCurve
        shrinkAnim.fillMode = .forwards
        shrinkAnim.isRemovedOnCompletion = false
        layer.add(shrinkAnim, forKey: shrinkAnim.keyPath)
    }
    
    private func shrink() {
        let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnim.fromValue = frame.width
        shrinkAnim.toValue = frame.height
        shrinkAnim.duration = shrinkDuration
        shrinkAnim.timingFunction = shrinkCurve
        shrinkAnim.fillMode = .forwards
        shrinkAnim.isRemovedOnCompletion = false
        layer.add(shrinkAnim, forKey: shrinkAnim.keyPath)
    }
}


class SpinerLayer: CAShapeLayer {
    
    var color = UIColor.white {
        didSet {
            strokeColor = color.cgColor
        }
    }
    
    override init() {
        super.init()
        fillColor = nil
        strokeColor = color.cgColor
        lineWidth = 1
        strokeEnd = 0.4
        isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animation() {
        self.isHidden = false
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = 0
        rotate.toValue = Double.pi * 2
        rotate.duration = 0.4
        rotate.timingFunction = CAMediaTimingFunction(name: .linear)
        rotate.repeatCount = HUGE
        rotate.fillMode = .forwards
        rotate.isRemovedOnCompletion = false
        self.add(rotate, forKey: rotate.keyPath)
    }
    
    func setToFrame(_ rect: CGRect) {
        let radius: CGFloat = rect.height / 2 * 0.5
        frame = CGRect(x: 0, y: 0, width: rect.height, height: rect.height)
        let center = CGPoint(x: rect.height / 2, y: bounds.midY)
        let startAngle = 0 - Double.pi/2
        let endAngle = Double.pi * 2 - Double.pi/2
        let clockwise: Bool = true
        path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: clockwise).cgPath
    }
    
    func stopAnimation() {
        isHidden = true
        removeAllAnimations()
    }
}
