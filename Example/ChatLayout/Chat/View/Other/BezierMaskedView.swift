//
// ChatLayout
// BezierMaskedView.swift
// https://github.com/ekazaev/ChatLayout
//
// Created by Eugene Kazaev in 2020-2021.
// Distributed under the MIT license.
//

import Foundation
import UIKit

final class BezierMaskedView<CustomView: UIView>: UIView {

    lazy var customView = CustomView(frame: bounds)

    var bubbleType: Cell.BubbleType = .tailed {
        didSet {
            updateChannelStyle()
        }
    }

    var messageType: MessageType = .outgoing {
        didSet {
            updateChannelStyle()
        }
    }

    var offset: CGFloat {
        switch bubbleType {
        case .tailed:
            return 2
        case .normal:
            return 6
        }
    }

    var maskingPath: UIBezierPath {
        let bezierPath: UIBezierPath
        let size = bounds.size
        switch bubbleType {
        case .tailed:
            switch messageType {
            case .incoming:
                bezierPath = generateIncomingTailedBezierPath(offset: offset, size: size)
            case .outgoing:
                bezierPath = generateOutgoingTailedBezierPath(offset: offset, size: size)
            }
        case .normal:
            switch messageType {
            case .incoming:
                bezierPath = generateIncomingNormalBezierPath(offset: offset, size: size)
            case .outgoing:
                bezierPath = generateOutgoingNormalBezierPath(offset: offset, size: size)
            }
        }
        return bezierPath
    }

    private var borderLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateChannelStyle()
    }

    private func setupSubviews() {
        layoutMargins = .zero
        translatesAutoresizingMaskIntoConstraints = false
        insetsLayoutMarginsFromSafeArea = false
        preservesSuperviewLayoutMargins = false
        addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        customView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        customView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        customView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
    }

    private func updateChannelStyle() {
        UIView.performWithoutAnimation {
            let maskLayer = CAShapeLayer()
            maskLayer.frame = bounds
            maskLayer.path = maskingPath.cgPath
            layer.mask = maskLayer
        }
    }

}

private func generateIncomingTailedBezierPath(offset: CGFloat, size: CGSize) -> UIBezierPath {
    let size = CGSize(width: size.width - offset, height: size.height)
    let bezierPath = UIBezierPath()
    bezierPath.move(to: CGPoint(x: 22, y: size.height))
    bezierPath.addLine(to: CGPoint(x: size.width - 17, y: size.height))
    bezierPath.addCurve(to: CGPoint(x: size.width, y: size.height - 17), controlPoint1: CGPoint(x: size.width - 7.61, y: size.height), controlPoint2: CGPoint(x: size.width, y: size.height - 7.61))
    bezierPath.addLine(to: CGPoint(x: size.width, y: 17))
    bezierPath.addCurve(to: CGPoint(x: size.width - 17, y: 0), controlPoint1: CGPoint(x: size.width, y: 7.61), controlPoint2: CGPoint(x: size.width - 7.61, y: 0))
    bezierPath.addLine(to: CGPoint(x: 21, y: 0))
    bezierPath.addCurve(to: CGPoint(x: 4, y: 17), controlPoint1: CGPoint(x: 11.61, y: 0), controlPoint2: CGPoint(x: 4, y: 7.61))
    bezierPath.addLine(to: CGPoint(x: 4, y: size.height - 11))
    bezierPath.addCurve(to: CGPoint(x: 0, y: size.height), controlPoint1: CGPoint(x: 4, y: size.height - 1), controlPoint2: CGPoint(x: 0, y: size.height))
    bezierPath.addLine(to: CGPoint(x: -0.05, y: size.height - 0.01))
    bezierPath.addCurve(to: CGPoint(x: 11.04, y: size.height - 4.04), controlPoint1: CGPoint(x: 4.07, y: size.height + 0.43), controlPoint2: CGPoint(x: 8.16, y: size.height - 1.06))
    bezierPath.addCurve(to: CGPoint(x: 22, y: size.height), controlPoint1: CGPoint(x: 16, y: size.height), controlPoint2: CGPoint(x: 19, y: size.height))
    bezierPath.close()
    bezierPath.apply(CGAffineTransform(translationX: offset, y: 0))

    return bezierPath
}

private func generateOutgoingTailedBezierPath(offset: CGFloat, size: CGSize) -> UIBezierPath {
    let bezierPath = generateIncomingTailedBezierPath(offset: offset, size: size)
    bezierPath.apply(CGAffineTransform(scaleX: -1, y: 1))
    bezierPath.apply(CGAffineTransform(translationX: size.width, y: 0))
    return bezierPath
}

private func generateIncomingNormalBezierPath(offset: CGFloat, size: CGSize) -> UIBezierPath {
    let bezierPath = UIBezierPath(roundedRect: CGRect(x: offset, y: 0, width: size.width - offset, height: size.height), cornerRadius: 17)
    return bezierPath
}

private func generateOutgoingNormalBezierPath(offset: CGFloat, size: CGSize) -> UIBezierPath {
    let bezierPath = generateIncomingNormalBezierPath(offset: offset, size: size)
    bezierPath.apply(CGAffineTransform(scaleX: -1, y: 1))
    bezierPath.apply(CGAffineTransform(translationX: size.width, y: 0))
    return bezierPath
}