//
//  BorderedLayer.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import SwiftyColor

// MARK: - BorderedLayer

final class BorderedLayer: CALayer {

  struct Border: OptionSet, Hashable {
    var rawValue: UInt
    var hashValue: Int

    init(rawValue: UInt) {
      self.rawValue = rawValue
      self.hashValue = Int(rawValue)
    }

    static let top    = Border(rawValue: 1 << 0)
    static let left   = Border(rawValue: 1 << 1)
    static let bottom = Border(rawValue: 1 << 2)
    static let right  = Border(rawValue: 1 << 3)
    static let shadow = Border(rawValue: 1 << 4)
  }

  typealias Insets = (CGFloat, CGFloat)

  var borders: Border = [] {
    didSet {
      self.updateBordersHidden()
    }
  }

  let topBorder = CALayer()
  let leftBorder = CALayer()
  let bottomBorder = CALayer()
  let rightBorder = CALayer()

  let shadowLayers = [CALayer(), CALayer(), CALayer()]

  var borderColors = [Border: UIColor]() {
    didSet {
      self.updateBordersColor()
    }
  }
  var borderWidths = [Border: CGFloat]() {
    didSet {
      self.updateBordersFrame()
    }
  }
  var borderInsets = [Border: Insets]() {
    didSet {
      self.updateBordersFrame()
    }
  }

  override var frame: CGRect {
    didSet {
      self.updateBordersFrame()
    }
  }


  override init() {
    super.init()

    self.borderColor = nil
    self.borderWidth = 0

    self.addSublayer(self.topBorder)
    self.addSublayer(self.leftBorder)
    self.addSublayer(self.bottomBorder)
    self.addSublayer(self.rightBorder)
    for shadow in self.shadowLayers {
      self.addSublayer(shadow)
    }

    self.updateBordersHidden()
    self.updateBordersColor()
  }

  override init(layer: Any) {
    super.init(layer: layer)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateBordersHidden() {
    self.topBorder.isHidden = !self.borders.contains(.top)
    self.leftBorder.isHidden = !self.borders.contains(.left)
    self.bottomBorder.isHidden = !self.borders.contains(.bottom)
    self.rightBorder.isHidden = !self.borders.contains(.right)

    let shadowHidden = !self.borders.contains(.shadow)
    for shadowLayer in self.shadowLayers {
      shadowLayer.isHidden = shadowHidden
    }
  }

  func updateBordersColor() {
    self.topBorder.backgroundColor = self.colorForBorder(.top).cgColor
    self.leftBorder.backgroundColor = self.colorForBorder(.left).cgColor
    self.bottomBorder.backgroundColor = self.colorForBorder(.bottom).cgColor
    self.rightBorder.backgroundColor = self.colorForBorder(.right).cgColor

    let color = self.colorForBorder(.shadow)
    for (i, shadow) in self.shadowLayers.enumerated() {
      let alpha = (CGFloat(self.shadowLayers.count - i) - 0.6) / CGFloat(self.shadowLayers.count)
      shadow.backgroundColor = (color~alpha).cgColor
    }
  }

  func updateBordersFrame() {
    CATransaction.begin()
    CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)

    let topInsets = self.insetsForBorder(.top)
    self.topBorder.frame.size.width = self.frame.width - topInsets.0 - topInsets.1
    self.topBorder.frame.size.height = self.widthForBorder(.top)
    self.topBorder.frame.origin.x = topInsets.0

    let bottomInsets = self.insetsForBorder(.bottom)
    self.bottomBorder.frame.size.width = self.frame.width - bottomInsets.0 - bottomInsets.1
    self.bottomBorder.frame.size.height = self.widthForBorder(.bottom)
    self.bottomBorder.frame.origin.x = bottomInsets.0
    self.bottomBorder.frame.origin.y = self.frame.height - self.bottomBorder.frame.size.height

    let leftInsets = self.insetsForBorder(.left)
    self.leftBorder.frame.size.width = self.widthForBorder(.left)
    self.leftBorder.frame.size.height = self.frame.height - leftInsets.0 - leftInsets.1
    self.leftBorder.frame.origin.y = leftInsets.0

    let rightInsets = self.insetsForBorder(.right)
    self.rightBorder.frame.size.width = self.widthForBorder(.right)
    self.rightBorder.frame.size.height = self.frame.height - rightInsets.0 - rightInsets.1
    self.rightBorder.frame.origin.x = self.frame.width - self.rightBorder.frame.size.width
    self.rightBorder.frame.origin.y = rightInsets.0

    CATransaction.commit()
  }

  override func layoutSublayers() {
    super.layoutSublayers()
    self.topBorder.zPosition = CGFloat(self.sublayers?.count ?? 0)
    self.leftBorder.zPosition = self.topBorder.zPosition
    self.bottomBorder.zPosition = self.topBorder.zPosition
    self.rightBorder.zPosition = self.topBorder.zPosition

    CATransaction.begin()
    CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)

    for (i, shadow) in self.shadowLayers.enumerated() {
      shadow.frame.origin.y = self.frame.size.height + (i.f / UIScreen.main.scale)
      shadow.frame.size.width = self.bottomBorder.frame.size.width
      shadow.frame.size.height = 1 / UIScreen.main.scale
    }

    CATransaction.commit()
  }


  // MARK: Utils

  func colorForBorder(_ border: Border) -> UIColor {
    if let value = self.borderColors[border] {
      return value
    }
    for (key, value) in self.borderColors {
      if key.contains(border) {
        return value
      }
    }
    return UIColor.db_border
  }

  func widthForBorder(_ border: Border) -> CGFloat {
    if let value = self.borderWidths[border] {
      return value
    }
    for (key, value) in self.borderWidths {
      if key.contains(border) {
        return value
      }
    }
    return 1 / UIScreen.main.scale
  }

  func insetsForBorder(_ border: Border) -> Insets {
    if let value = self.borderInsets[border] {
      return value
    }
    for (key, value) in self.borderInsets {
      if key.contains(border) {
        return value
      }
    }
    return (0, 0)
  }

}


// MARK: - UIView Extension

extension UIView {
  var borderedLayer: BorderedLayer? {
    return self.layer as? BorderedLayer
  }
}
