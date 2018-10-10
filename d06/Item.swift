//
//  Item.swift
//  d06
//
//  Created by Zenande GODONGWANA on 2018/10/08.
//  Copyright © 2018 Zenande GODONGWANA. All rights reserved.
//

import UIKit

enum Form : UInt {
    case square = 0
    case circle
}


class Item: UIView {

    let elasticity : UIDynamicItemBehavior = {
        let did = UIDynamicItemBehavior()
        did.allowsRotation = true
        did.elasticity = 0.75
        return did
    }()
    
    let sizeItem = 100
    let gravity = UIGravityBehavior()
    let collider : UICollisionBehavior = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
        return collider
    }()
    
    lazy var animator : UIDynamicAnimator = UIDynamicAnimator(referenceView: self)
    var animation : Bool = false{
        didSet{
            if animation{
                animator.addBehavior(gravity)
                animator.addBehavior(collider)
                animator.addBehavior(elasticity)
            }
            else{
                animator.removeBehavior(gravity)
                animator.removeBehavior(collider)
                animator.removeBehavior(elasticity)
            }
        }
    }
    
    func getRandomColor() -> UIColor
    {
        switch arc4random() % 6 {
        case 0:
            return UIColor.red
        case 1:
            return UIColor.blue
        case 2:
            return UIColor.green
        case 3:
            return UIColor.yellow
        case 4:
            return UIColor.cyan
        case 5:
            return UIColor.purple
        default:
            return UIColor.black
        }
    }
    
    func getRandomForm() -> CGFloat{
        switch arc4random() % 2 {
        case 0:
            return 0
        default:
            return CGFloat(sizeItem / 2)
        }
    }
    
    func add(point:CGPoint)
    {
        let frame = CGRect(origin:CGPoint(x: point.x - CGFloat(sizeItem / 2), y: point.y - CGFloat(sizeItem/2)), size: CGSize(width: sizeItem, height: sizeItem))
        let shape = UIView(frame: frame)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panHandler(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchHandler(_:)))
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(self.rotationHandler(_:)))
        
        shape.backgroundColor = getRandomColor()
        shape.layer.cornerRadius = getRandomForm()
        shape.clipsToBounds = true
        addSubview(shape)
        gravity.addItem(shape)
        collider.addItem(shape)
        elasticity.addItem(shape)
        shape.isUserInteractionEnabled = true
        shape.addGestureRecognizer(panGesture)
        shape.addGestureRecognizer(pinchGesture)
        shape.addGestureRecognizer(rotateGesture)
    }
    
    @objc func panHandler(_ sender:UIPanGestureRecognizer) {
            switch sender.state {
            case .began:
                print("Pan Began")
                self.gravity.removeItem(sender.view!)
            // gesture.view?.center = gesture.location(in: gesture.view?.superview)
            case .changed:
                //print("Changed to \(sender.location(in: self))")
                sender.view?.center = sender.location(in: sender.view?.superview)
                animator.updateItem(usingCurrentState: sender.view!)
            case .ended:
                print("Pan Ended")
                self.gravity.addItem(sender.view!)
            case .failed, .cancelled:
                print("Failed or Cancelled")
            case .possible:
                print("Possible")
            }
        
    }
    
    @objc func pinchHandler(_ sender: UIPinchGestureRecognizer) {
        print("handlePinch")
        if let view = sender.view {
            print(sender.scale)
            
            switch sender.state {
            case .began:
                print("Pinch Began")
                self.gravity.removeItem(view)
                self.collider.removeItem(view)
                self.elasticity.removeItem(view)
                
            case.changed:
                print("Pinch Changed")
                sender.view?.layer.bounds.size.height *= sender.scale
                sender.view?.layer.bounds.size.width *= sender.scale
                
                //Do this if it's a Circle
                if (sender.view!.layer.cornerRadius != 0) {
                    sender.view!.layer.cornerRadius *= sender.scale
                }
                
                sender.scale = 1
                
            case .ended:
                print("Pinch Ended")
                self.gravity.addItem(view)
                self.collider.addItem(view)
                self.elasticity.addItem(view)
                
                
            case .failed, .cancelled:
                print("Failed or Cancelled")
            case .possible:
                print("Possible")
            }
        }
        
    }
    
    @objc func rotationHandler(_ sender: UIRotationGestureRecognizer) {
        print("handleRotate")
        if let view = sender.view {
            print(sender.rotation)
            switch sender.state {
            case .began:
                print("Rotation Began")
                self.gravity.removeItem(view)
                
            case.changed:
                print("Rotation Changed")
                
                view.transform = view.transform.rotated(by: sender.rotation)
                animator.updateItem(usingCurrentState: sender.view!)
                sender.rotation = 0
            case .ended:
                print("Rotation Ended")
                self.gravity.addItem(view)
            case .failed, .cancelled:
                print("Failed or Cancelled")
            case .possible:
                print("Possible")
            }
        }
    }
    
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType{
        return .ellipse
    }

}
